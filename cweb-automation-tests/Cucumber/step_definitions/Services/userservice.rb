When /^I call JSON GET API "([^"]*)" get response code "([^"]*)"$/ do |uri, exp_code|
  get_response_call(uri)
  response_code_check("code", exp_code)
end

def get_response_call(url)
  response = OTHttpClient.new().get(url)
  set_response_global_hash(response)
end

def get_call(uri)
  url = URI.parse(uri)
  req = Net::HTTP::Get.new(url.path)
  response = Net::HTTP.start(url.host, url.port) { |http|
    http.request(req)
  }
  set_response_global_hash(response)
end


def convert_JSON_response_to_hash
  if ($API_RESPONSE['resp_code'] == "404")
    puts " Record not found"
  else
    # we convert the returned JSON data to native Ruby structure - a hash
    $API_RESPONSE['api_resp'] = JSON.parse($API_RESPONSE['resp_body']) #### converted result in hash
    # if the hash has 'Error' as a key, we raise an error
    if $API_RESPONSE['api_resp'].has_key? 'Error'
      raise Exception, "web service error"
    end
  end
end

When /^I check value for "([^"]*)"$/ do |parameter|
  puts "#{$API_RESPONSE['api_resp'][parameter]}"
end


def set_data(userid, reslogID, resid, rid, shiftDT, rstate = 2, ps = 1, points = 100, partner_id = 1, isAnonReso = 1)
  #--- creating a Hash for reservation record used in post API ---
  res_record = {"GPID" => -1, "ReslogID" => -1, "Reservation" => {"ResID" => -1, "RID" => -1, "ShiftDT" => -1, "RStateID" => -1, "PartySize" => 1, "Points" => -1, "IsAnonReso" => -1, "PartnerID" => -1}}
  res_record["GPID"] = userid
  res_record["ReslogID"] = reslogID
  res_record["Reservation"]["ResID"] = resid
  res_record["Reservation"]["RID"] = rid
  res_record["Reservation"]["ShiftDT"] = shiftDT
  res_record["Reservation"]["RStateID"] = rstate
  res_record["Reservation"]["PartySize"] = ps
  res_record["Reservation"]["Points"] = points
  res_record["Reservation"]["PartnerID"] = partner_id
  res_record["Reservation"]["IsAnonReso"] = isAnonReso
  res_record["Reservation"]["LanguageID"] = 1
  res_record["Reservation"]["IsSelfReso"] = 0
  return res_record
end

def response_code_check(field, exp_value)
  case field
    when "code"
      puts $API_RESPONSE['resp_code']
      if !($API_RESPONSE['resp_code'] == exp_value)
        raise Exception, "response code expectd : #{exp_value} but actual #{$API_RESPONSE['resp_code']} "
      end
    when "message"
      puts $API_RESPONSE['resp_mesg']
      if !($API_RESPONSE['resp_mesg'] == exp_value)
        raise Exception, "response mesg is not as expected "
      end
    else
      puts $API_RESPONSE['resp_body']
      exp_value = "\"#{exp_value}\""
      if !($API_RESPONSE['resp_body'] == exp_value)
        raise Exception, "response body is not as expected "
      end
  end
end


When /^I check reso "([^"]*)" (present|not present) in API response$/ do |reso_no, result|
  ###-- check for reservation exist--
  resid = $RUNTIME_STORAGE["reso_resid_erbreso_#{reso_no}"]
  reso_found = check_reso_exist_mongodb(resid)
  if (reso_found == true)
    if (result == "not present")
      raise Exception, "record should not be present"
    else ### result == present
      puts "reservation : #{resid} found as expected "
    end
  else
    if (result == "present")
      raise Exception, "record should be present"
    else ### result == present
      puts "reservation : #{resid} NOT found as expected "
    end
  end

end

When /^I wait "([^"]*)" seconds$/ do |time|
  sleep time.to_i
end

When /^I check user login API returns "([^"]*)"$/ do |parameter|
  unless @user_login.parsed_response.has_key? parameter
    raise Exception, "#{parameter} does not exists"
  end
  puts "#{parameter} exist and value is : #{@user_login.parsed_response[parameter]}"
end


When /^I check user-transactions API returns "([^"]*)"$/ do |parameter|
  unless @userTransControlState.parsed_response.has_key? parameter
    raise Exception, "#{parameter} does not exists"
  end
  puts "#{parameter} exist and value is : #{@userTransControlState.parsed_response[parameter]}"
end


When /^I check user-transactions API returns total "([^"]*)" parameters$/ do |count|
  if (($API_RESPONSE['api_resp'].length).to_s.strip.eql? count.to_s.strip)
    puts "API returns total  : #{count} parameters"
  else
    raise Exception, "API doesn't return expected no of parameters'"
  end
end

When /^I store user-transactions API return "([^"]*)" in runtime storage "([^"]*)"$/ do |parameter, name|
  $RUNTIME_STORAGE[name] = $API_RESPONSE['api_resp'][parameter]
end


When /^I compare watermark (upgraded|no-change)$/ do |change|
  new_watermark = $API_RESPONSE['api_resp']["WatermarkValue"]
  if (change == "upgraded")
    if ((new_watermark).to_i > $RUNTIME_STORAGE["WaterMark"].to_i)
      puts "watermark incremented old watermark : #{$RUNTIME_STORAGE["WaterMark"]} New Watermark : #{new_watermark}"
    else
      raise Exception, "watermark should be upgraded"
    end
  end
  if (change == "no-change")
    if ((new_watermark).to_i == $RUNTIME_STORAGE["WaterMark"].to_i)
      puts "watermark stays same"
    else
      raise Exception, "watermark should not be changed"
    end
  end
end

When /^I check User had total "([^"]*)" reservations$/ do |expected_rec|
  if ($API_RESPONSE['api_resp']["ReservationHistory"].count.to_s.strip.eql? expected_rec.to_s.strip)
    puts "count is correct as expected: #{expected_rec}  "
  else
    raise Exception, "total reso count expected : #{expected_rec} and actual :#{$API_RESPONSE['api_resp']["ReservationHistory"].count}"
  end
end

When /^I check failed reso "([^"]*)" (present|not-present) in user-transactions response$/ do |resid, flag|
  found = false
  puts "failed resos #{$API_RESPONSE['api_resp']["FailedResoUpdates"]}"
  $API_RESPONSE['api_resp']["FailedResoUpdates"].each { |failed_resid|
    if (failed_resid.to_s.strip.eql? resid.to_s.strip)
      found = true
      break
    end
  }
  if ((flag == "present") && (found == false))
    raise Exception, "resid not present in FailedResoUpdates list"
  end
  if ((flag == "not-present") && (found == true))
    raise Exception, "resid present in failed reso list"
  end
end

When /^I create JSON having total "([^"]*)" reservation record for POST request$/ do |total_records|
  n = total_records.to_i
  batch = Array.new(n, Hash.new)
  for i in 0..n-1 do
    rec_no = i + 1
    batch[i] = $RUNTIME_STORAGE["record_#{rec_no}"]
  end
  $json_post_data = batch.to_json
  puts $json_post_data
end


When /^I crosscheck reservation History$/ do
  #### check reso count matches in webdb vs mongo db   ------
  total_reso_count_match() ##--- check reso counts matches in both db
  #### then check each reservation details matches for each reservations -----
  $result_set.each { |webdb_reso|
    reso_found = check_reso_detail_mongo_db(webdb_reso, "db")
    if (reso_found == false)
      raise Exception, "reso not found in mango db"
    else
      puts "Reso deatails matches in webdb mongo db for resid : #{webdb_reso[0]} "
    end
  }
end

When /^I check reservation Details "([^"]*)" "([^"]*)", "([^"]*)" "([^"]*)" "([^"]*)" for resid "([^"]*)"$/ do |rstatus, ps, points, reso_dt_time, rid, resid|
  shiftDT_time = DateTime.parse(reso_dt_time)
  webdb_reso = [resid, rid, shiftDT_time, shiftDT_time, ps, rstatus, points]
  reso_found = check_reso_detail_mongo_db(webdb_reso, 'db')
  if (reso_found == false)
    raise Exception, "reso not found in mango db"
  else
    puts "reso details matches for Reservation Id : #{resid}"
  end
end

def compare_reso_detail_webdb_mongodb(web_value, mongo_value, resid, field)
  if !(web_value.to_s.strip.eql? mongo_value.to_s.strip)
    puts ">>> resid = #{resid}"
    puts ">>> field = #{field}"
    puts ">>>>>>>> web_value   = #{web_value}"
    puts ">>>>>>>> mongo_value = #{mongo_value}"
    raise Exception, " #{field} data doesn't match for resid #{resid}"
  end
end

def check_reso_detail_mongo_db(webdb_reso, reso_detail_source)
  reso_found_mongo = false
  puts "webdb reso : #{webdb_reso}"
  $API_RESPONSE['api_resp']["ReservationHistory"].each { |mongo_reso|
    if ((mongo_reso["ResID"].to_s.strip.eql? webdb_reso[0].to_s.strip))
      puts "mongodb reso : #{mongo_reso}"
      compare_reso_detail_webdb_mongodb(webdb_reso[1], mongo_reso["RID"], mongo_reso["ResID"], "RID")
      mongo_date_time = DateTime.parse(mongo_reso["ShiftDT"]).to_time.utc
      mongo_reso_date = mongo_date_time.strftime("%Y-%m-%d")
      web_reso_date = webdb_reso[2].strftime("%Y-%m-%d")
      compare_reso_detail_webdb_mongodb(web_reso_date, mongo_reso_date, mongo_reso["ResID"], "ShiftDate")
      compare_reso_detail_webdb_mongodb(webdb_reso[4], mongo_reso["PartySize"], mongo_reso["ResID"], "PartySize")
      mongo_reso_time = mongo_date_time.strftime("%H:%M:%S")
      web_reso_time = webdb_reso[3].strftime("%H:%M:%S")
      compare_reso_detail_webdb_mongodb(web_reso_time, mongo_reso_time, mongo_reso["ResID"], "ResTime")
      compare_reso_detail_webdb_mongodb(webdb_reso[5], mongo_reso["RStateID"], mongo_reso["ResID"], "ResoStatus")
      reso_found_mongo = true
      break
    end
  }
  return reso_found_mongo
end

def total_reso_count_match()
  total_reso_webdb = $result_set.count
  total_reso_mongo = $API_RESPONSE['api_resp']["ReservationHistory"].count
  if (total_reso_webdb.to_s.strip.eql? total_reso_mongo.to_s.strip)
    puts "Total reso count matches : #{total_reso_mongo}"
  else
    raise Exception, "total reso count mismatch - webdb count : #{total_reso_webdb} and mongo db count :#{total_reso_mongo}"
  end
end

def convert_json_date(shiftdate)
  secs, microsecs = shiftdate.scan(/[0-9]+/)[0].to_i.divmod(1000)
  s = Time.at(secs, microsecs).utc #=> Time.at converts in locale time, .utc changes it to UTC "
  return s
end

def check_reso_exist_mongodb(resid)
  reso_found = false
  $API_RESPONSE['api_resp']["ReservationHistory"].each { |reso|
    if (reso["ResID"].to_s.strip.eql? resid.to_s.strip)
      reso_found = true
      break
    end
  }
  return reso_found
end

When /^I check user-transaction API returns "([^"]*)" value "([^"]*)"$/ do |param, value|
  if !(@user_login.parsed_response[param].to_s.strip.eql? value.to_s.strip)
    raise Exception, "In response : #{@user_login.parsed_response[param]} value is not #{value} "
  end
end

When /^I check user-transaction API return UserID$/ do
  raise Exception, "userid didnot match " unless @user_login.parsed_response['UserID'].to_i.eql?@user.id


end



####--------------- DB steps -------

When /^I get reso history from webdb for user "([^"]*)"$/ do |email|
  #--- get customer id ---
  sql = "select custid from customer where email = '#{email}' "
  $result_set = $g_db.runquery_return_resultset(sql)
  $RUNTIME_STORAGE["custid"] = $result_set[0][0].to_s.strip
  puts "Customer id : #{$RUNTIME_STORAGE["custid"]}"
  sql = "select resid,rid,ShiftDate,restime,partysize,rstateid,respoints from reservationVW where custid = #{$RUNTIME_STORAGE["custid"]} and Rstateid <> 1 order by 1 desc"
  $result_set = $g_db.runquery_return_resultset(sql)
  puts "WEBDB reso result :  #{$result_set}"
end

When /^I convert JSON response to HASH$/ do
  convert_JSON_response_to_hash()
end

When /^I call JSON POST API "([^"]*)" host "([^"]*)" "([^"]*)" and get response "([^"]*)"$/ do |api, host, port, exp_code|
  $host = host
  if (port.blank?)
    $port = nil
  else
    $port = port
  end
  $post_ws = api
  post
  response_code_check("code", exp_code)
end

def delete_call()
  req = Net::HTTP::Delete.new($post_ws, initheader = {'Content-Type' => 'application/json'})
  response = Net::HTTP.new($host, $port).start { |http| http.request(req) }
  set_response_global_hash(response)
end

def post
  req = Net::HTTP::Post.new($post_ws, initheader = {'Content-Type' => 'application/json'})
  #req.basic_auth @user, @pass
  req.body = $json_post_data
  puts $json_post_data
  response = Net::HTTP.new($host, $port).start { |http| http.request(req) }
  set_response_global_hash(response)
end

When /^I store reso "([^"]*)" details in HASH "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |record_no, gpid, reslogid, resid, rid, date_time, rstateid, ps, points|
  newreslogid = reslogid.to_i ### reslogid passed
  if (reslogid == "higher")
    newreslogid = ($RUNTIME_STORAGE["WaterMark"].to_i + 1)
  end
  if (reslogid == "lower")
    newreslogid = ($RUNTIME_STORAGE["WaterMark"].to_i - 1)
  end
  $RUNTIME_STORAGE["record_#{record_no}"] = set_data(gpid.to_i, newreslogid, resid.to_i, rid.to_i, date_time, rstateid.to_i, ps.to_i, points.to_i)
end

When /^I should get response "([^"]*)" "([^"]*)"$/ do |field, exp_value|
  response_code_check(field, exp_value)
end

Then /^I save my profile reservation history in a array$/ do
  get_myProfile_reso_history()
  n = $web_reso_history.count ### total record
  for j in 0..n-1 do
    puts $web_reso_history[j]
  end
end


def get_myProfile_reso_history
  if ($driver.link(:id, "linkViewAllActivity").exists?)
    $driver.link(:id, "linkViewAllActivity").click
  end
  n = $driver.table(:id, "gridActivities").rows.count
  $web_reso_history = Array.new(n-1, Hash.new)
  i = 0
  $driver.table(:id, "gridActivities").rows.each do |row|
    if !(row.tds[1].text.eql? "Date") ### ignoring Header
      reso_detail = {}
      reso_detail["ShiftDT"] = row.tds[1].text
      reso_detail["Rname/Tran"] = row.tds[2].text ### Restaurants/Transaction
      reso_detail["Points"] = row.tds[3].text
      if (((row.id).include? "Activities_Reservation") || ((row.tds[2].text).include? "No Show")) #### picking seated/NoShow reservations
        ###---- get resid
        /DescriptionName\_(\d+)/i.match(row.tds[2].link.id)
        reso_detail["ResID"] = $1
        ###---- getting RID
        /rid\=(\d+)/i.match(row.tds[2].link.href)
        reso_detail["RID"] = $1
        ####---- Rstateid -----
        if ((row.tds[2].text).include? "No Show")
          reso_detail["RStateId"] = 4
        else
          reso_detail["RStateId"] = 2
        end
      end
      $web_reso_history[i] = reso_detail
      i = i + 1
    end
  end
end

Then /^I compare reservation past history with mongo db$/ do
  #### check reso count matches in webdb vs mongo db   ------
  total_reso_webdb = $web_reso_history.count ##--- check reso counts matches in both db
  total_reso_mongo = $API_RESPONSE['api_resp']["ReservationHistory"].count
  if (total_reso_webdb.to_s.strip.eql? total_reso_mongo.to_s.strip)
    puts "Total reso count matches : #{total_reso_mongo}"
  else
    raise Exception, "total reso count mismatch - webdb count : #{total_reso_webdb} and mongo db count :#{total_reso_mongo}"
  end
  $web_reso_history.each { |reso_detail|
    shiftdt =Date.strptime(reso_detail["ShiftDT"], "%m/%d/%Y")
    webdb_reso = [reso_detail["ResID"], reso_detail["RID"], shiftdt, reso_detail["RStateId"], reso_detail["Points"]]
    reso_found = resodetail_myprofile_compare_mongo_db(webdb_reso)
    if (reso_found == false)
      raise Exception, "reso not found in mango db"
    else
      puts "Reso deatails matches in webdb mongo db for resid : #{reso_detail["ResID"]} "
    end
  }

end


def resodetail_myprofile_compare_mongo_db(webdb_reso)
  reso_found_mongo = false
  puts webdb_reso
  $API_RESPONSE['api_resp']["ReservationHistory"].each { |mongo_reso|
    if ((mongo_reso["ResID"].to_s.strip.eql? webdb_reso[0].to_s.strip))
      compare_reso_detail_webdb_mongodb(webdb_reso[1], mongo_reso["RID"], mongo_reso["ResID"], "RID")
      mongo_date_time = convert_json_date(mongo_reso["ShiftDT"])
      mongo_reso_date = mongo_date_time.strftime("%Y-%m-%d")
      web_reso_date = webdb_reso[2].strftime("%Y-%m-%d")
      compare_reso_detail_webdb_mongodb(web_reso_date, mongo_reso_date, mongo_reso["ResID"], "ShiftDate")
      #### -- my profile status seated for status 2/5/7
      case mongo_reso["RStateID"]
        when 2, 5, 7 #-- seated
          status = 2
        else
          status = mongo_reso["RStateID"]
      end
      compare_reso_detail_webdb_mongodb(webdb_reso[3], status, mongo_reso["ResID"], "RStateID")
      #### --- my profile shows points as +/-
      if (mongo_reso["Points"] > 0)
        points = "+" + mongo_reso["Points"].to_s
      end
      if (webdb_reso[3] == 4) ###--- no show case 0 points on myprofile
        points = 0
      end
      compare_reso_detail_webdb_mongodb(webdb_reso[4], points, mongo_reso["ResID"], "Points")
      reso_found_mongo = true
      break
    end
  }
  return reso_found_mongo
end

When /^I check new error logged with text "([^"]*)" after "([^"]*)"$/ do |text, errorlogid|
  sql = "select top 1 ErrorLogID,ErrMsg from errorlog where Errorlogid > #{errorlogid}  and ErrMsg like '%#{text}%' order by 1 desc"
  $result_set = $g_db.runquery_return_resultset(sql)
  if ($result_set.count == 0)
    raise Exception, "No error message logged "
  else
    puts "New Error logged with Id : #{$result_set[0][0]} "
    puts "New Error logged with Message : #{$result_set[0][1]} "
  end
end
Then /^I get response code "([^"]*)"$/ do |exp_code|
  response_code_check("code", exp_code)
end

#--- helper method to set API response in global hash  ---

def set_response_global_hash(response)
  $API_RESPONSE['resp_code'] = response.code
  $API_RESPONSE['resp_mesg'] = response.message
  $API_RESPONSE['resp_body'] = response.body
end

When /^I remove failed reso "([^"]*)" from mongodb$/ do |resid|
  #connect_mongodb('mongo-db-primary', 'Users', 'UserSvcUser/0pentab1e')
  #collection = $db['UserTransactionsFailedUpdates']
  #search_hash = { "ReservationID" => resid.to_i, "region" => "NA" }
  #collection.remove(search_hash)
  userTransaction = UserTransactions.new($domain)
  userTransaction.clear_mongo_db_data_for_failed_reso_synchronization(resid)
end
When /^I reset watermark to old value "([^"]*)"$/ do |watermark_value|
  #connect_mongodb('mongo-db-primary', 'Users', 'UserSvcUser/0pentab1e')
  #search_hash = {"Name" => 'UserTxn_Watermark', "Region" => "NA"}
  #change_hash = {"WatermarkValue" => watermark_value.to_i }
  #collection = $db['Watermarks']
  #collection.update( search_hash, '$set' => change_hash )
  userTransaction = UserTransactions.new($domain)
  userTransaction.update_DataSync_watermark(watermark_value)
end
When /^I get GlobalpersonId$/ do
  $RUNTIME_STORAGE['gpid'] = UserTransactions.new($domain).get_gpid_using_resid($RUNTIME_STORAGE['reso_resid_erbreso_1'])
end

When /^I change reservation state to seated$/ do
  $RUNTIME_STORAGE["reso_resid_erbreso_1"] = $RESERVATION["resid"]
  change_reso_status($RUNTIME_STORAGE["reso_resid_erbreso_1"])

end

When /^User makes second reservation as registered user and seats the reso$/ do
  puts @umami_web_reso.reso_detail['Diner_email']
  sleep(70) #--- adding delay to give enough gap between first reso and registration
  $USER["email"] = @umami_web_reso.reso_detail['Diner_email']
  user=User.new({:email => $USER["email"], :city => 'San Francisco', :is_admin => false, :is_register => true, :password => "password", :first_name => 'Test', :last_name => 'user'})
  user.user_registration
  ##----make another reso ---
  fwd_days = '1'
  r_time = '4:00 PM'
  r_party = '2'
  rid = '95167'
  s_date = day_fwd_based_on_locale(fwd_days).to_s
  perform_search_get_slotlock(r_party, rid, r_time, s_date)
  setup_g_page($driver.url)
  #$driver = setup_g_page($driver.url)
  isConcierge, isSignin = false
  $g_page.fill_details_page_info(isConcierge, 'neena', 'mishra', $USER["email"], isSignin)
  $g_page.complete_reservation
  setup_g_page($driver.url)
  $RUNTIME_STORAGE["reso_resid_erbreso_2"] = $RESERVATION["resid"]
  change_reso_status($RUNTIME_STORAGE["reso_resid_erbreso_2"])
  #--- get gpid ---
  $RUNTIME_STORAGE['gpid'] = UserTransactions.new($domain).get_gpid_using_resid($RUNTIME_STORAGE["reso_resid_erbreso_2"])
end

When /^User makes second reservation for a Diner and seats the reso$/ do
  #--- admin user's email
  puts @umami_web_reso.reso_detail['Diner_email']
  ##----make another reso ---
  fwd_days = '1'
  r_time = '4:00 PM'
  r_party = '2'
  rid = '95167'
  s_date = day_fwd_based_on_locale(fwd_days).to_s
  perform_search_get_slotlock(r_party, rid, r_time, s_date)
  setup_g_page($driver.url)
  #--- add a new diner --
  $g_page.get_element("Add/Edit/Delete Diner", 1).click
  setup_g_page($driver.url)
  $g_page = DinerAdd.new($driver)
  $g_page.add_diner("Diner", "One")
  sleep(5)
  setup_g_page($driver.url)
  $g_page.complete_reservation
  setup_g_page($driver.url)
  $RUNTIME_STORAGE["reso_resid_erbreso_2"] = $RESERVATION["resid"]
  change_reso_status($RUNTIME_STORAGE["reso_resid_erbreso_2"])
  #--- get gpid ---
  @getGPID = UserAPI.new($domain, @umami_web_reso.reso_detail['Diner_email'])
  @getGPID.GetGPIdByEmail()
  $RUNTIME_STORAGE['gpid'] = @getGPID.response.body
  puts $RUNTIME_STORAGE['gpid']
  $RUNTIME_STORAGE['caller_email'] = @umami_web_reso.reso_detail['Diner_email']
end

def change_reso_status(resid)
  $g_db = OTDBAction.new($domain.db_server_address, "webdb", $db_user_name, $db_password)
  sql = "update Reservation set RStateID = 2 , ShiftDate = CAST(GETDATE() AS DATE),
  ResTime = CAST('1899-12-30' AS DATETIME) + CAST(CAST(GETDATE() AS SMALLDATETIME) AS TIME)
  where ResID = #{resid}"
  puts sql
  $g_db.runquery_no_result_set(sql)
end

When /^I call GetUserTransaction API$/ do
  @userTrans = UserTransactions.new($domain, $RUNTIME_STORAGE['gpid'])
  @userTrans.Get_User_Transactions()
end

Given /^I call UserTransaction getControlState API$/ do
  @userTransControlState = UserTransactions.new($domain)
  @userTransControlState.Get_ControlState()
  set_response_global_hash(@userTransControlState.response)
  convert_JSON_response_to_hash()
end

When /^I verify reservation one is migrated as anonymous reso and reservation two as non anonymous$/ do
  assert(@userTrans.get_reservation_details(@resid)['IsAnonReso'] == true, "Expected Value is true but actual value is false")
  assert(@userTrans.get_reservation_details(@resid_2)['IsAnonReso'] == false, "Expected Value is false but actual value is true")
end

Then /^I verify reservation one is migrated as IsSelfReso and reservation two as NOTIsSelfReso$/ do
  assert(@userTrans.get_reservation_details(@resid)['IsSelfReso'] == true, "Expected Value is true but actual value is false")
  assert(@userTrans.get_reservation_details(@resid_2)['IsSelfReso'] == false, "Expected Value is false but actual value is true")
end


When /^I call UserTransaction getControlState INIT API$/ do
  @initControlState = UserTransactions.new($domain)
  @initControlState.Get_ControlState_INIT()
end

Then /^I check Transaction API return total "([^"]*)" parameters$/ do |count|
  resp_body_hash = JSON.parse(@initControlState.response.body)
  assert(resp_body_hash.length.to_s.strip == count.to_s.strip, "Expected Count #{count}, actual count #{resp_body_hash.length}")
end

When /^I check getControlState INIT API returns "([^"]*)","([^"]*)","([^"]*)","([^"]*)"$/ do |param1, param2, param3, param4|
  parameter_exist = @initControlState.check_api_returns_field(param1)
  assert(parameter_exist == true)
  parameter_exist = @initControlState.check_api_returns_field(param2)
  assert(parameter_exist == true)
  parameter_exist = @initControlState.check_api_returns_field(param3)
  assert(parameter_exist == true)
  parameter_exist = @initControlState.check_api_returns_field(param4)
  assert(parameter_exist == true)
end
Given /^I clear data for GPID "([^"]*)"$/ do |gpid|
  @obj = UserTransactions.new($domain, gpid)
  @obj.clear_mongo_db_data_for_user()
end
When /^I create request body and call UserTxnInitalization API$/ do
  @obj.post_usertxn_init()
  @obj.response_code_check('201')
  puts @obj.response.code
end
Then /^I verify data populated in mongodb by calling GetTransactions API$/ do
  #---call--GetuserTransactions -
  puts @obj.global_personID
  @obj.Get_User_Transactions()
  @obj.response_code_check('200')
  puts @obj.response.code
  puts @obj.response.body
  @obj.verify_response_with_default_post_init_data()
end

def get_gpid_using_email(email, user_type)
  #$domain =  Domain.new(".com")
  puts $domain.db_server_address
  $g_db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  if (user_type == 'Customer')
    sql = "select GlobalPersonID  from GlobalPerson G inner join customer C ON G.CustID = C.CustID where C.Email = '#{email}'"
  else
    sql = "select GlobalPersonID  from GlobalPerson G inner join caller C ON G.callerid = C.callerid where C.LoginName = '#{email}'"
  end
  puts sql
  result_set = $g_db.runquery_return_resultset(sql)
  gpid = (result_set[0][0]).to_i
  return gpid
end

When /^I set watermark and start UserTransaction Sync Task$/ do
  step %{I set watermark and start UserTransaction Sync Task to sync resid "#{$RUNTIME_STORAGE["reso_resid_erbreso_1"]}" and "#{$RUNTIME_STORAGE["reso_resid_erbreso_2"]}"}
end

Given /^I run UserTxn Data Initialization task for (Customer|Caller) having login "([^"]*)"$/ do |user_type, email|
  #------ using test email id get user's gpid ---
  $RUNTIME_STORAGE['gpid'] = get_gpid_using_email(email, user_type)
  #---Clear user data  in mongo db
  @obj = UserTransactions.new($domain, $RUNTIME_STORAGE['gpid'])
  @obj.clear_mongo_db_data_for_user()
  #-- get watermark values for reset at the end
  @obj.Get_ControlState_INIT()
  response_hash = JSON.parse(@obj.response.body)
  $RUNTIME_STORAGE['waterMark'] = response_hash['WatermarkValue']
  $RUNTIME_STORAGE['upperBound'] = response_hash['Upperbound']
  #----update watermark using test GPID
  watermark_value = $RUNTIME_STORAGE['gpid'].to_i - 1
  upperBound = $RUNTIME_STORAGE['gpid'].to_i
  @obj.update_DataINIT_watermark(watermark_value, upperBound)
  #---------update schedule task to execute and set frequency as 1 min ---
  $g_db = OTDBAction.new($domain.db_server_address, "webdb", $db_user_name, $db_password)
  sql = "update ScheduledTasks set executetask = 1 , Periodicity = 1 where TaskName = 'UserTxnInitialization'"
  $result_set = $g_db.runquery_return_resultset(sql)
  #---wait 2 min
  sleep(120)
end

Then /^I verify Total reservations returned by API matches with NON pending Reservations Count in webdb$/ do
  api_returns_reso_count = @userTrans.total_resos_returned_by_api()
  puts api_returns_reso_count
  @userTrans.get_reso_data_from_webdb()
  webdb_non_pending_reso_count = @userTrans.web_db_reso_data.count
  puts webdb_non_pending_reso_count
  assert(webdb_non_pending_reso_count.to_i == api_returns_reso_count.to_i, " expected reso count #{webdb_non_pending_reso_count}, actual reso count #{api_returns_reso_count}")
end

When /^I crosscheck reservation details matches$/ do
  @userTrans.get_reso_data_from_webdb()
  @userTrans.web_db_reso_data.each { |web_reso|
    @userTrans.compare_webdb_reso_with_API_response(web_reso)
  }
end

Given /^I call API GetGPIDbyEmail using new user's email$/ do
  @getGPID.GetGPIdByEmail()
end

When /^I verify Header info Location has correct url$/ do
  expeted_location_url = "http://#{$domain.internal_services}/user/v1/users/#{@getGPID.global_personID}"
  assert(expeted_location_url == @getGPID.response['location'], "Expected location header value : #{expeted_location_url}, actual value #{@getGPID.response['location']} ")
end


Given /^I create a new User customerType "([^"]*)"$/ do |consumer_type|
  value = random_string(8)
  email = "#{value}@opentable.com"
  is_admin = false
  if (consumer_type == 'Caller')
    is_admin = true
  end
  @user=User.new({:email => email, :city => 'San Francisco', :is_admin => is_admin, :is_register => true, :password => "password", :first_name => 'Test', :last_name => 'user'})
  @user.user_registration
  @getGPID = UserAPI.new($domain, email)
  puts email
end

Then /^I verify returned GPID is correct for new "([^"]*)"$/ do |consumer_type|
  #@getGPID.response_code_check('200')
  assert('200', @getGPID.response.code)
  #--- set GPID vaue in instance variable ---
  @getGPID.global_personID = @getGPID.response.body
  email = @getGPID.email
  db_gpid = get_gpid_using_email(email, consumer_type)
  assert(@getGPID.response.body.to_i == db_gpid.to_i, "GPID expected as : #{db_gpid}, actual GPID :#{@getGPID.response.body}")
end

When /^I call API GetGPIDbyEmail using email "([^"]*)"$/ do |email|
  @getGPID = UserAPI.new($domain, email)
  @getGPID.GetGPIdByEmail()
end

When /^I get user info using the email address$/ do
  @getGPID = UserAPI.new($domain)
  @getGPID.getUserEmail
  @getGPID.GetUserInfoByEmail(@getGPID.email)
end

When /^I get diner info using the email address "([^"]*)" and looking for "([^"]*)"$/ do |email, diner|
  @getGPID = UserAPI.new($domain, email)
  @getGPID.GetDinerInfoByUserEmail(email, diner)
end

When /^I call API PostCreateBarebonesUser using email "([^"]*)", metroid "([^"]*)"$/ do |email, mid|
  @getGPID = UserAPI.new($domain, email)
  @getGPID.POST_GPIdByEmail()
end

When /^I call API PostCreateBarebonesUser using random email$/ do
  value = random_string(8)
  email = "#{value}@opentable.com"
  @getGPID = UserAPI.new($domain, email)
  @getGPID.POST_GPIdByEmail()
end

Then /^I verify response code is "([^"]*)"$/ do |rcode|
  assert(rcode, @getGPID.response.code)
  #@getGPID.response_code_check(rcode)
end

When /^I verify API returns correct GPID$/ do
  @getGPID.global_personID = @getGPID.response.body
  email = @getGPID.email
  db_gpid = get_gpid_using_email(email, 'Customer')
  assert(@getGPID.response.body.to_i == db_gpid.to_i, "GPID expected as : #{db_gpid}, actual GPID :#{@getGPID.response.body}")
end

When /^I call API GetGPIDbylogin using new user's login$/ do
  @getGPID.GetGPIdBylogin()
end

When /^I call API GetGPIDbylogin using login "([^"]*)"$/ do |login|
  @getGPID = UserAPI.new($domain, login)
  @getGPID.GetGPIdBylogin()
end

When /^I create reso "([^"]*)" with details "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |record_no, gpid, reslogid, resid, rid, date_time, rstateid, ps, points, anony, isSelf, lang|
  newreslogid = reslogid.to_i ### reslogid passed
  if (reslogid == "higher")
    newreslogid = ($RUNTIME_STORAGE["WaterMark"].to_i + 1)
  end
  if (reslogid == "lower")
    newreslogid = ($RUNTIME_STORAGE["WaterMark"].to_i - 1)
  end
  $RUNTIME_STORAGE["record_#{record_no}"] = set_data_witout_few_fields(gpid.to_i, newreslogid, resid.to_i, rid.to_i, date_time, rstateid.to_i, ps.to_i, points, anony, isSelf, lang)
end

def set_data_witout_few_fields(gpid, reslogID, resid, rid, date_time, rstateid, ps, points, isAnonReso, isSelf, lang)
  res_record = {}
  #res_record = { "GPID" => -1 , "ReslogID" => -1 , "Reservation" => { "ResID" => -1 , "RID" => -1 , "ShiftDT" => -1, "RStateID" => -1 ,"PartySize" => 1, "Points" => -1, "IsAnonReso" => -1, "PartnerID" => -1 } }
  res_record["GPID"] = gpid
  res_record["ReslogID"] = reslogID
  res_record["Reservation"] = {}
  res_record["Reservation"]["ResID"] = resid
  res_record["Reservation"]["RID"] = rid
  res_record["Reservation"]["ShiftDT"] = date_time
  res_record["Reservation"]["RStateID"] = rstateid
  res_record["Reservation"]["PartySize"] = ps
  if (points != 'NA')
    if (points.empty?)
      res_record["Reservation"]["Points"] = nil
    else
      res_record["Reservation"]["Points"] = points.to_i
    end
  end
  res_record["Reservation"]["PartnerID"] = 1
  if (isAnonReso != 'NA')
    if (isAnonReso.empty?)
      res_record["Reservation"]["IsAnonReso"] = nil
    else
      res_record["Reservation"]["IsAnonReso"] = isAnonReso
    end
  end
  res_record["Reservation"]["LanguageID"] = lang.to_i
  if (isSelf != 'NA')
    if (isSelf.empty?)
      res_record["Reservation"]["IsSelfReso"] = nil
    else
      res_record["Reservation"]["IsSelfReso"] = isSelf.to_i
    end
  end
  return res_record
end


When /^I call userlogin api using email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  @user_login = UserAPI.new($domain)
  email = @user.email if email.eql? ""
  @user_login.Get_UserLogin(email, password)
  set_response_global_hash(@user_login.response)
  convert_JSON_response_to_hash()
end


Given(/^As a regular user I make reservation for (\d+) days from today to any available restaurant in "([^"]*)" domain$/) do |days, domain|
  $domain = Domain.new(domain)
  @user = User.new({:is_register => true})
  @user.user_registration
  @gpid = gpid_using_email_from_db(@user.email).to_i
  @reservation = RestReservation.new({:rid => "", :is_register => true, :email => @user.email, :password => @user.password, :search_day => days})
  @reservation.multi_search_make_to_randomly_available_rest
  @resid = get_resid_from_db(@reservation.conf_number, @reservation.rid)
end

And(/^Same user makes another reservation for tomorrow to any available restaurant$/) do
  @reservation_2 = RestReservation.new({:rid => "", :is_register => true, :email => @user.email, :password => @user.password, :search_day => 1})
  @reservation_2.multi_search_make_to_randomly_available_rest
  @resid_2 = get_resid_from_db(@reservation_2.conf_number, @reservation_2.rid)
end

And(/^I change the second reservation to seated$/) do
  shiftdate = 'ShiftDate - 1'
  status_id = 2
  restime = ''
  partysize = ''
  update_reso_status(@resid_2, status_id, shiftdate, restime, partysize)
end

And(/^I call user service transaction end point$/) do
  @userTrans = UserTransactions.new($domain, @gpid.to_i)
  @userTrans.Get_User_Transactions()
end

And(/^I set watermark and start UserTransaction Sync Task to sync resid "([^"]*)" and "([^"]*)"$/) do |resid1, resid2|
  @gpid ||=""
  @userTrans ||= UserTransactions.new($domain, @gpid.to_i)
  @userTrans.Get_ControlState()
  response_hash = JSON.parse(@userTrans.response.body)
  $RUNTIME_STORAGE['waterMark'] = response_hash['WatermarkValue']
  puts "Old Watermark : #{$RUNTIME_STORAGE['waterMark']}"
#--- get new values and update watermark ---
  $g_db = OTDBAction.new($domain.db_server_address, "webdb", $db_user_name, $db_password)
  sql = "select MIN(reslogid) from reservationlog where resid in (#{resid1},#{resid2})"
  result_set = $g_db.runquery_return_resultset(sql)
  watermark_value = result_set[0][0].to_i - 1
  puts " New Watermark : #{watermark_value}"
  @userTrans.update_DataSync_watermark(watermark_value)
#---------update schedule task to execute and set frequency as 1 min ---
  sql = "select executetask from ScheduledTasks where TaskName = 'UserTxnSync'"
  result_set = $g_db.runquery_return_resultset(sql)
  $RUNTIME_STORAGE['UserTxnSync_execbit'] = result_set[0][0]
  sql = "update ScheduledTasks set executetask = 1 , Periodicity = 1 where TaskName = 'UserTxnSync'"
  $g_db.runquery_return_resultset(sql)
end


And(/^I set watermark and re-start UserTransaction sync task$/) do
  step %{I set watermark and start UserTransaction Sync Task to sync resid "#{@resid_2}" and "#{@resid}"}
end


And(/^I should see only seated reservation info in the response$/) do
  @userTrans.parsed_response['ReservationHistory'].count == 1
  @userTrans.parsed_response['ReservationHistory'].each do |reso|
    if reso['ResID'] == @resid and reso['ResID'] != @resid_2
      raise Exception, " reservation #{@resid_2} information found in the response"
    end
  end
end


And(/^I seat the first reservation$/) do
  shiftdate = 'ShiftDate - 2'
  status_id = 2
  restime = ''
  partysize = ''
  update_reso_status(@resid, status_id, shiftdate, restime, partysize)
end


And(/^I no-show second reservation but update the party size to negative number$/) do
  shiftdate = 'ShiftDate - 1'
  status_id = 4
  restime = ''
  partysize = -2
  update_reso_status(@resid_2, status_id, shiftdate, restime, partysize)
end

And(/^I verify failed reso should present in the sync control state record$/) do
  @userTrans.Get_ControlState()
  if !@userTrans.parsed_response['FailedResoUpdates'].include? @resid_2
    raise Exception, "reservation #{@resid_2} is not present"
  end
end

And(/^I update the no-show reso party size to positive number$/) do
  shiftdate = ''
  status_id = ''
  restime = ''
  partysize = 2
  update_reso_status(@resid_2, status_id, shiftdate, restime, partysize)
end

And(/^I see both seated and no-show reservation$/) do
  @userTrans.parsed_response['ReservationHistory'].count == 2
  @userTrans.parsed_response['ReservationHistory'].each do |reso|
    unless reso['ResID'] == @resid or reso['ResID'] == @resid_2
      raise Exception, " reservation #{@resid_2} information found in the response"
    end
  end
end

And(/^I verify failed reso record is removed from the sync control state record$/) do
  @userTrans.Get_ControlState()
  if !@userTrans.parsed_response['FailedResoUpdates'].nil? and @userTrans.parsed_response['FailedResoUpdates'].include? @resid_2
    raise Exception, "reservation #{@resid_2} still present in the failed list"
  end
end

And(/^I see only seated reservation info in the response$/) do
  @userTrans.parsed_response['ReservationHistory'].count == 1
  @userTrans.parsed_response['ReservationHistory'].each do |reso|
    if reso['ResID'] != @resid and reso['ResID'] == @resid_2
      raise Exception, " reservation #{@resid_2} information found in the response"
    end
  end
end

And(/^Same user makes another reservation as registered user and seats the reso$/) do
  @user = User.new({:is_register => true, :email => @reservation.email, :first_name => @reservation.first_name, :last_name => @reservation.last_name})
  @user.user_registration
  @reservation_2 = RestReservation.new({:rid => "", :is_register => true, :email => @user.email, :password => @user.password, :search_day => 2})
  @reservation_2.multi_search_make_to_randomly_available_rest
  @resid_2 = get_resid_from_db(@reservation_2.conf_number, @reservation_2.rid)
  #seating second reso too
  update_reso_status(@resid_2, 2, 'ShiftDate - 2', "", @reservation_2.party_size)
end

Given(/^As an Admin user, I make self reso for tomorrow in "([^"]*)" domain and seat the reso$/) do |domain|
  $domain = Domain.new(domain)
  @user = User.new({:is_register => true, :is_admin => true})
  @user.user_registration
  @gpid = get_caller_gpid_using_email_from_db(@user.email).to_i
  @reservation = RestReservation.new({:rid => "", :is_admin => true, :is_register => true, :email => @user.email, :password => @user.password, :search_day => 1, :first_name => @user.first_name, :last_name => @user.last_name})
  @reservation.multi_search_make_to_randomly_available_rest
  @resid = get_resid_from_db(@reservation.conf_number, @reservation.rid)
  update_reso_status(@resid, 2, 'ShiftDate - 2', "", @reservation.party_size)
end


And(/^I makes second reservation for a Diner and seats the reso$/) do
  @reservation_2 = RestReservation.new({:rid => "", :is_admin => true, :is_register => true, :email => @user.email, :password => @user.password, :search_day => 1})
  @reservation_2.multi_search_make_to_randomly_available_rest
  @resid_2 = get_resid_from_db(@reservation_2.conf_number, @reservation_2.rid)
  #seating second reso too
  update_reso_status(@resid_2, 2, 'ShiftDate - 2', "", @reservation_2.party_size)
end


And(/^I have a registered regular user linked with "([^"]*)"$/) do |social_type|
  if social_type == 'facebook'
    social_type_id = 1
  elsif social_type == 'google'
    social_type_id = 3
  else
    raise Exception, 'Invalid social type'
  end

  $g_db = OTDBAction.new($domain.db_server_address, "webdb", $db_user_name, $db_password)
  sql = "select top 1 gp.GlobalPersonID, s.SiteUserID from GlobalPerson gp inner join SocialCustomer s on gp.CustID = s.CustID where s.SocialTypeID = #{social_type_id}"
  result_set = $g_db.runquery_return_resultset(sql)
  @gpid = result_set[0][0].to_i
  @socialUserId = result_set[0][1]
end

And(/^I have a registered admin user linked with "([^"]*)"$/) do |social_type|
  if social_type == 'facebook'
    social_type_id = 1
  elsif social_type == 'google'
    social_type_id = 3
  else
    raise Exception, 'Invalid social type'
  end

  $g_db = OTDBAction.new($domain.db_server_address, "webdb", $db_user_name, $db_password)
  sql = "select top 1 gp.GlobalPersonID, s.SiteUserID from GlobalPerson gp inner join SocialCaller s on gp.CallerID = s.CallerID where s.SocialTypeID = #{social_type_id}"
  result_set = $g_db.runquery_return_resultset(sql)
  @gpid = result_set[0][0].to_i
  @socialUserId = result_set[0][1]
end

When(/^I get the user information for the saved gpid$/) do
  @user_login = UserAPI.new($domain)
  @user_login.GetUserInfoByGPID(@gpid)
end

When(/^I get diner info using the admin GPID diners uri$/) do
  @getGPID = UserAPI.new($domain)
  diner = @getGPID.getCallerDiner
  @getGPID.GetDinerInfoByUserEmail(@getGPID.email, diner)
end

Then(/^the user "([^"]*)" ids should match$/) do |social_type|
  if social_type == 'facebook'
    social_type_id = 1
  elsif social_type == 'google'
    social_type_id = 3
  else
    raise Exception, 'Invalid social type'
  end

  user_info = JSON.parse(@user_login.response.body)
  social_id = 0
  user_info['SocialInfos'].each { |social_info|
    social_id = social_info['SocialUid'] unless social_info['SocialType'] != social_type_id
  }

  assert(@socialUserId == social_id, "The #{social_type} ids don't match")
end


Given(/^I am an OT (customer|caller) have social login$/) do |user_type|
  $domain = Domain.new(".com")
  is_admin = false
  if user_type == "caller"
    is_admin = true
  end
  @user = User.new({:is_admin => is_admin})
  @user.user_registration
  @userSvc = UserAPI.new()
  @userSvc.update_social_caller_cust_table(@user.id, @user.is_admin)
end


When(/^I request user social id end point with "([^"]*)" provider for (customer|caller)$/) do |provider, user_type|
  is_admin = false
  if user_type == "caller"
    is_admin = true
  end
  @userSvc.get_user_social_id(@user.id, is_admin )
  @userSvc.getUserDetailsBySocial(@userSvc.siteUser_id, provider)
end


Then(/^I should see "([^"]*)" in the user response code$/) do |code|
  @userSvc.response.code.to_i.should == code.to_i
end

And(/^I validate user data$/) do
  @userSvc.get_user_info_from_web_db(@user.email, @user.is_admin)
  @userSvc.validate_data
end


When(/^I request user social id end point with "([^"]*)"$/) do |provider|
  siteUser_id = '100007827690408'
  @userSvc = UserAPI.new
  @userSvc.getUserDetailsBySocial(siteUser_id, provider)
end

When(/^I request user social id end point with invalid site userid$/) do
  @userSvc = UserAPI.new
  @userSvc.getUserDetailsBySocial("123456")
end

And(/^I clear user demographic and friends data from mongodb and delete social customer table for email "([^"]*)"$/) do |email|
  @userSvc = UserAPI.new($domain, email)
  #get gpid using the userservice and remove the userdata from mongo
  @userSvc.GetGPIdByEmail
  @userSvc.remove_user_doc("Users", 'UserDemographics', 'GPID', @userSvc.global_personID.to_i)
  unless @userSvc.response.code.to_i.eql? 404
    #delete the social customer using the v3 service
    @user = User.new({@email => email}).delete_user_social_association(email, 1)
    #update email with random email
    newemail= "#{random_string(10)}@opentable.com"
    sql= "UPDATE Customer set Email = '#{newemail}' where Email='#{email}'"
    @userSvc.connect_db_run_sql(sql, true)
  end
end


And(/^I enable facebook value lookup and recache website for all valuelookups$/) do
  sql = "update ValueLookup set ValueInt = 1 where LKey = 'UserFacebook_IsEnabled'"
  @userSvc.connect_db_run_sql(sql, true)
  step %{I recache consumer website for "all valuelookups" item}
end

And(/^I login on consumer site using facebook account username "([^"]*)" and password "([^"]*)"$/) do |username, password|
  @userSvc ||= UserAPI.new($domain, username)
  @userSvc.login_to_facebook(username, password)
end

Then(/^User demographic data is present in mongo$/) do
  sleep 1
  @userSvc.GetGPIdByEmail
  1.upto (5) {
    @userSvc.get_record_from_mongo("Users", 'UserDemographics', 'GPID', @userSvc.global_personID.to_i)
    break unless @userSvc.result_set.nil?
    sleep 2
  }
  raise Exception, "did not find user demographic detailes in user collection" if @userSvc.result_set.nil?
end

And(/^I verify user "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)"$/) do |fname, lname, gender, country, source, region, fb_likes_count|
  @userSvc.result_set
  @userSvc.result_set['GPID'].to_i.should.eql? @userSvc.global_personID.to_i
  @userSvc.result_set['FName'].should.eql? fname
  @userSvc.result_set['LName'].should.eql? lname
  @userSvc.result_set['Gender'].should.eql? gender
  @userSvc.result_set['Country'].should.eql? country
  @userSvc.result_set['Region'].should.eql? region
  @userSvc.result_set['Source'].should.eql? source
  @userSvc.result_set['Location'].should.nil?
  @userSvc.result_set['FacebookLikes'].count.should.eql? fb_likes_count.to_i

end

And(/^User friends data is present in mongo and number of friends is "([^"]*)"$/) do |count|
  1.upto (5) {
    @userSvc.get_record_from_mongo('UserFriends', 'UserFriends', '_id', @userSvc.global_personID.to_i)
    break unless @userSvc.result_set.nil?
    sleep 2
  }
  raise Exception, "did not find user friends details in usersfriends collection" if @userSvc.result_set.nil?
  @userSvc.result_set['Friends'].count.should.eql? count.to_i
end


And(/^I verify user has a friend fname "([^"]*)", lname "([^"]*)"$/) do |fname, lname|
  @userSvc.result_set['Friends'].find_index { |frd| frd["FName"].should.eql? fname and frd['LName'].should.eql? lname }
end

And(/^I update fbuser with email "([^"]*)" "([^"]*)" to "([^"]*)" in userdemographic collection$/) do |email, hash_key, hash_value|
  @userSvc = UserAPI.new($domain, email)
  @userSvc.GetGPIdByEmail
  doc = {hash_key => hash_value}
  @userSvc.update_user_doc("Users", 'UserDemographics', 'GPID', @userSvc.global_personID.to_i, doc)
end

And(/^I update friends data to empty record$/) do
  doc = {'Friends' => []}
  @userSvc.update_user_doc('UserFriends', 'UserFriends', '_id', @userSvc.global_personID.to_i, doc)
end

And(/^I disable facebook value lookup and recache website for all valuelookups$/) do
  sql = "update ValueLookup set ValueInt = 0 where LKey = 'UserFacebook_IsEnabled'"
  @userSvc.connect_db_run_sql(sql, true)
  step %{I recache consumer website for "all valuelookups" item}
end

Then(/^User demographic data should not present in mongo$/) do
  sleep 1
  @userSvc.GetGPIdByEmail
  1.upto (2) {
    @userSvc.get_record_from_mongo("Users", 'UserDemographics', 'GPID', @userSvc.global_personID.to_i)
    break if @userSvc.result_set.nil?
    sleep 2
  }
  raise Exception, "found data user demographic detailes in user collection" unless @userSvc.result_set.nil?
end

And(/^User friends data should not present in mongo$/) do
  1.upto (2) {
    @userSvc.get_record_from_mongo('UserFriends', 'UserFriends', '_id', @userSvc.global_personID.to_i)
    break if @userSvc.result_set.nil?
    sleep 2
  }
  raise Exception, "did not find user demographic detailes in userFriends collection" unless @userSvc.result_set.nil?
end


