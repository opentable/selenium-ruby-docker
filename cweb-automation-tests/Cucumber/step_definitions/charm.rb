# add local ip address to partner
# expected to be logged into CHARM
When /^I add my IP address to partner "([^"]*)" in CHARM$/ do |partner_name|
  begin
    wait_timeout = 30
    # click Edit/View Partners List menu item on CHARM default page
    $driver.link(:text, "Edit/View Partners List").click
    $driver.wait_until { $driver.url.include? "/PartnersList.aspx" }

    # click Partner link
    begin
      success = false
      1.upto(wait_timeout) {
        if $driver.table(:id, "gridPartersList").exists?
          success = true
          break
        end
        sleep 1
      }
      if !success
        raise Exception, "Error finding grid partner list table"
      end

      dsc = {:text => partner_name, :href => /partneredit\.aspx\?PartnerID=/}
      $driver.table(:id, "gridPartersList").link(dsc).click
    rescue Exception => e
      raise e.message
    end

    # get local IP address
    a = `ipconfig`.to_s.match(/\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/).to_a
    if (a.length > 5)
      raise Exception, "Multiple IPs found on test agent. Using first one."
    end
    ip_full, ip_octet_1, ip_octet_2, ip_octet_3, ip_octet_4 = a

    # check in IP already added
    if (!$driver.body(:index, 0).text.include? ip_full)

      $driver.text_field(:id, "IPRangeFrom_1").set(ip_octet_1)
      $driver.text_field(:id, "IPRangeFrom_2").set(ip_octet_2)
      $driver.text_field(:id, "IPRangeFrom_3").set(ip_octet_3)
      $driver.text_field(:id, "IPRangeFrom_4").set(ip_octet_4)

      # click Add button
      $driver.button(:id, "btnAddIP").click

      $g_page.click_alert_dialog("OK")

      # recach site for Partner List
      step %{I recache consumer website for "Partner List" item}
    end
  rescue Exception => e
    raise Exception, "Failed to add IP address! Reason: #{e.message}"
  end

end

When /^I go to restaurant profile page with nURL "([^"]*)"$/ do |rest_name|
  $driver.goto("#{$domain.www_domain_selector}/#{rest_name}")
  $redirected_url = $driver.url
end

Given /^I login to CHARM$/ do
  #  step %{I start with "IE" browser}
  step %{I start Firefox browser with WebDriver profile}
  $driver.goto("http://#{$domain.charm_address}/")
end

Then /^I get reservation anomalies report from CHARM$/ do
  #get anomalies from charm
  if $TEST_ENVIRONMENT.eql? "Prod"
    get_anomalies_from_charm($domain.charm_address)
  else
    get_anomalies_from_db
  end
end

def get_anomalies_from_db
  if (!$RESTAURANT["RID"].nil? and !$RESERVATION["conf_number"].nil?)
    sql = "select ResID,BillingType,RID,ConfNumber,BillableSize,ResPoints,ShiftDateTime,RStateID,CallerID,CustID ,PartnerID,RestaurantType,IsRestWeek,ZeroReason,Anomalies,IsReferral from ReservationAnalysisVW where Rid = #{$RESTAURANT["RID"]} and ConfNumber = #{$RESERVATION["conf_number"]}"
  else
    sql = "select ResID,BillingType,RID,ConfNumber,BillableSize,ResPoints,ShiftDateTime,RStateID,CallerID,CustID ,PartnerID,RestaurantType,IsRestWeek,ZeroReason,Anomalies,IsReferral from ReservationAnalysisVW where Resid = #{$RESERVATION["resid"]}"
  end

  array = ["ResID","BillingType","RID","ConfNumber","BillableSize","ResPoints","ShiftDateTime","RStateID","CallerID","CustID" ,"PartnerID","RestaurantType","IsRestWeek", "ZeroReason","Anomalies","IsReferral"]
  db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  result_set = db.runquery_return_resultset("#{sql}")
  array.each_with_index  {|k, i|
    value = result_set[0][i]
    $RESERVATION["#{k}"] = value.to_s }

  puts $RESERVATION["BillingType"]
end

def get_anomalies_from_charm(charm_url)
  charmurl="http://#{charm_url}/"
  wait_timeout = 30
  success = false

# login to CHARM
# navigate to Anomalies report page
# find Anomalies for reservation based on res_id
  @browser = BrowserUtilities.open_browser($charm_default_browser, "WebDriver")
  begin
    # navigate to charm
    @browser.goto(charmurl)
    # click Reports menu item on CHARM default page
    obj= wait_until_element_find(wait_timeout, @browser.ul(:id, "nav_primary").link(:text, "Reports"))
    obj.click
    # click Reservation Anomalies Report
    object= wait_until_element_find(wait_timeout, @browser.div(:id, "nav_secondary_inner").link(:text, "Reservation Anomalies Report"))
    object.click
    # enter resid into ResID field
    resid = $RESERVATION["resid"]
    res_object= wait_until_element_find(wait_timeout, @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").text_field(:id, "txtResID"))

    #set resid or rid and conf number
    if (!$RESTAURANT["rid"].nil? and !$RESERVATION["conf_number"].nil?)
      rid = $RESTAURANT["rid"]
      conf_number = $RESERVATION["conf_number"]
      @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").text_field(:id, "txtRID").set(rid)
      @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").text_field(:id, "txtConfNum").set(conf_number)
    else
      @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").text_field(:id, "txtResID").set(resid)
      @browser.execute_script("document.getElementById('txtEndDate').value = '5/1/2033'")
    end

    #click search reservation
    object = wait_until_element_find(wait_timeout, @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").button(:id, "btnSearch"))
    object.click

    if (!WaitHelper.wait_until_url_present(@browser, "/reports/ReservationAnomalies.aspx", wait_timeout))
      raise Exception, "Did not land on reservation anomalies page"
    end

    # wait for table to display
    object = wait_until_element_find(wait_timeout, @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").table(:id, "dgResult"))
    # verify only one record is returned (excluding table headings)
    if @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").table(:id, "dgResult").rows.length != 2
      raise Exception, "invalid number of rows returned for resid #{resid}"
    end

    title_row = 0
    anomalies_row = 1
    key_definitions = []
    anomalies = []

    @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").table(:id, "dgResult").rows[title_row].cells.each { |c| key_definitions << c.text.strip }
    @browser.div(:id, "content_body_datafix").div(:id, "essential_wrapper").table(:id, "dgResult").rows[anomalies_row].cells.each { |c| anomalies << c.text.strip }

    # update RESERVATION hash
    key_definitions.each_with_index { |k, i| $RESERVATION[k] = anomalies[i] }
  rescue Exception => e
    # take screen shot of failed step
    take_screen_shot(@browser)
    raise Exception, "failed to check for anomalies\n#{e.message}\n#{e.backtrace}"
  ensure
    @browser.close
  end

  def wait_until_element_find(wait_timeout, object)
    success =false
    1.upto(wait_timeout) {
      begin
        if !object.nil?
          if object.exists?
            success = true
            break
          end
        end
      rescue
      end
      sleep 1
    }
    if (!success)
      raise Exception, "Results table not found on page"
    end
    return object
  end
end
