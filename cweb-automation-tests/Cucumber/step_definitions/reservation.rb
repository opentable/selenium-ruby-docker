# Encoding: UTF-8
#
#Put reservation related functions here
#
Then /^I cancel reservation$/ do
  if $g_page.class.to_s.downcase.include? "upcomingreso"
    $g_page.cancel_reservation($RESERVATION['resid_encrypted'])
  else
    $g_page.cancel_reservation($RESERVATION['resid'])
  end
  $RESERVATION["isCancelled"] = true
end

Then /^I find a table for "([^"]*)" at "([^"]*)" on "([^"]*)" from today$/ do | party_sz, time, add_days |
  step %{I set reservation date to "#{add_days}" days from today}
  step %{I set party size to "#{party_sz}"}
  step %{I set reservation time to "#{time}"}
  step %{I click "Find a Table"}
end

Then /^I set reservation date to "([^"]*)" days from today$/ do |add_days|
  #Use the helper function in OTBasePage.rb than a local function in the step definition
  #Sometimes the RestaurantProfile page takes a while to come up and so the $g_page is not set to RestaurantProfile
  #when this step is executed and the test fails due to undefined method.
  $RESERVATION["days_fwd"] = add_days
  $g_page = BookingRestaurantProfile.new($driver)
  new_date, time = ($g_page.get_date_based_on_time_zone(add_days.to_i).to_s).split(" ")
  step %{I set reservation date to "#{new_date}"}
end

Then /^I set reservation date to "([^"]*)"$/ do |date|
  $RESERVATION["date_searched"] = date
  $g_page.set_date(date)
end

When /^I set reservation time to "([^"]*)"$/ do |time|
  $RESERVATION["time_searched"] = time
  $g_page = BookingRestaurantProfile.new($driver)  unless ($opentable_starturl.include? "singlerest.aspx")
  ##There is a timing issue where the Time is not set up properly in the new bookingflow views page during modifying a reso.  This is not ideal but checking for the presences or existence of the Time object did not work.
  if $driver.url.include? "view"
    time_picker = $driver.div(:class,"time-picker dtp-picker-selector select-native")
    $driver.wait_until(10,"Unable to find element Time in views page") {time_picker.present?}
    time_picker.focus
    time_picker.click
    sleep(0.5)
    $g_page.select("Time", time)
    sleep(0.5)
    time_picker.click
    sleep(0.5)
    $driver.send_keys :tab
  else
    $g_page.select("Time", time)
  end

end

Then /^I add and select diner$/ do
  d_fname = random_string(8)
  d_lname = random_string(8)

  $g_page = DinersList.new($driver)
  $driver.wait_until(60, "Spinner is still spinning after 60 secs"){!$driver.div(:class,"spinner").present?}
  $g_page.add_diner(d_fname, d_lname)
  $g_page.check_diner_name(d_fname, d_lname)
  $g_page.close_diners_list
  $g_page = BookingDetails.new($driver)
  $g_page.select_diner_list(d_fname, d_lname)
end

When(/^I fill in  CC number "([^"]*)" and exp date if needed$/) do |cc_no|
  $g_page.set_cc_details(cc_no, Time.now.advance(:months => 6).strftime("%m"), Time.now.advance(:years => 1).strftime("%Y"))
end


Then /^I complete reservation$/ do
  $g_page.complete_reservation
end

Then /^I convert to regular user$/ do
  $g_page.convert_user
end

Then /^I click time slot "([^"]*)" for restaurant "([^"]*)" on "([^"]*)" days from today$/ do |time, rest_name, days_fwd|
  puts "Expected restaurant name: #{rest_name}"
  $driver.wait_until(60,"Not in restaurant profile page: #{rest_name}") {$driver.element(:css, '.page-header-title').text.include? rest_name}
  puts "Actual restaurant name: #{$driver.element(:css, '.page-header-title').text}"

  BookingRestaurantProfile.new($driver).click_time_slot(time, days_fwd)
  # expected landing page details.aspx or details_pci.aspx.  Do we still have details_pci.aspx in new bookingflow??
  $driver.wait_until(60, "Expected landing page to be details.aspx or details_pci.aspx.  Landed in url #{$driver.url}") { ($driver.url.include? "details") || ($driver.url.include? "details_pci") }
  $RESTAURANT['name'] = rest_name
end

Then /^I click first available time slot in the search results$/ do
  $g_page = Opentables_newdesign.new($driver)
  $g_page.click_first_available_timeslot
end

Then /^I click first available POP time slot in the search results$/ do
  $g_page = Opentables_newdesign.new($driver)
  $g_page.click_first_available_timeslot
end

Then /^I verify reservation (ResID|BillingType|BillableSize|ResPoints|ShiftDateTime|RStateID|CallerID|CustID|PartnerID|RestaurantType|RestaurantType|IsRestWeek|ZeroReason|Anomalies|IsReferral) is "([^"]*)"$/ do |key, value|
  # Some co.uk rids have billing type as OfferReso instead OTReso.  This change allows the check for either one of the type
  if !value.to_s.include?($RESERVATION[key.to_s])
    raise Exception, "reservation anomaly found!\nexpected value for #{key}: #{value}\nactual found #{$RESERVATION[key.to_s]}"
  end
end

Then /^I verify reservation billing info for "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)"$/ do |billing_type, res_points, billablesize, partner_id|
  bill_hash = {
      "BillingType" => "#{billing_type}",
      "ResPoints" => "#{res_points}",
      "BillableSize" => "#{billablesize}",
      "PartnerID" =>"#{partner_id}",
  }

  bill_hash.each do |key, value|
    if !value.to_s.include?($RESERVATION[key.to_s])
      raise Exception, "reservation anomaly found!\nexpected value for #{key}: #{value}\nactual found #{$RESERVATION[key.to_s]}"
    end
  end
end

#Candidate for deprecation??  Better to use step "And I navigate to url <string>
Then /^I go to restref page for rid "([^"]*)"$/ do |rid|
  $driver.goto($domain.www_domain_selector+"/single.aspx?rid=#{rid}&restref=#{rid}")
end

Then /^I verify reservation details on (view page|invite preview HTML|invite preview TEXT)$/ do |object|
  $g_page.verify_reservation_details(object)
end

Then /^I verify restref is (set|not set) and points is (0|100)$/ do |restref, points|
  isRestRef=false
  isRestRef=true if restref.eql? 'set'
  @reservation ||= ReservationServiceV2.new()
  @response = @reservation.reso_retrieve('all')
  raise Exception, "Excepted Restref: #{isRestRef} Actual is set to #{@response['data']['isRestRef']}" if !@response['data']['isRestRef'].eql? isRestRef
  if ENV['TEST_ENVIRONMENT'].downcase == "preprod"
    raise Exception, "Excepted Points: #{points} Actual is set to #{@response['data']['points']}" if !@response['data']['points'].eql? points.to_i
  end
end

Then /^I should see POP "([^"]*)" points message$/ do | points |
  $g_page.verify_points(points)
end

Then(/^I should see user name "([^"]*)" "([^"]*)"and conf number on view page$/) do |fname, lname |
  $g_page.conf_number
  if fname.nil?
    fname = $USER['fname']
    lname = $USER['lname']
  end
  $g_page.verify_user_name(fname, lname )
end

def day_fwd_based_on_locale(days_forward)
  time = Time.new # system time
  expectedDtSys = (Date.new(time.year, time.month, time.day) + (days_forward.to_i)).to_s
  utctime = time.getutc
  case $domain.www_domain_selector
    when "www.opentable.co.uk"
      uktime = utctime + (1 * 3600)
      expectedDtLocal = (Date.new(uktime.year, uktime.month, uktime.day) + (days_forward.to_i)).to_s
    when "www.opentable.de", "www.opentable.de/en-gb"
      detime = utctime + (2 * 3600)
      expectedDtLocal = (Date.new(detime.year, detime.month, detime.day) + (days_forward.to_i)).to_s
    when "www.opentable.jp", "www.opentable.jp/en-gb"
      jptime = utctime + (9 * 3600)
      expectedDtLocal = (Date.new(jptime.year, jptime.month, jptime.day) + (days_forward.to_i)).to_s
    else
      expectedDtLocal = expectedDtSys
  end
  return expectedDtLocal
end

Then /^I click any POP time slot for any restaurant$/ do
  $g_page = Opentables_newdesign.new($driver)
  $g_page.select_any_pop_time_slot
end

And(/^I click on Sign in link and login as registered user$/) do
    $g_page = BookingDetails.new($driver)
    $g_page.click_sign_in_link
    $g_page.login_registered_user
end
