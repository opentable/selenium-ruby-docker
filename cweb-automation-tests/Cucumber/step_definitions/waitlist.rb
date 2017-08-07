# Encoding: utf-8

And /^I set restaurant "([^"]*)" to be waitlist enabled$/ do | rid |
  $g_page = ConsumerWebBridge.new($driver)
  $g_page.enable_waitlist(rid, true)
end

And /^I add diner number "([^"]*)", "([^"]*)", party_size "([^"]*)" to waitlist for restaurant "([^"]*)"$/ do |dinerno, email, party_sz, rid|
  queue_msg = [1 => "first in line", 2 => "2nd in line", 3 => "3rd in line"]
  $RUNTIME_STORAGE['WaitListDiner'] = dinerno.to_i
  $RESTAURANT['RID'] = rid
  $USER['gpid'] = step %{I call API GetGPIDbyEmail using email "#{email}"}
  @gpid = $USER['gpid']
  $g_page = ReservationServiceV2.new($driver)
  waitlist_body = $g_page.make_waitlist_body($USER['gpid'], rid, party_sz.split(" ").first.to_i, 0)
  $g_page.reso_make(rid, waitlist_body)
  step %{I get the user information for the saved gpid}
  user = JSON.parse(@user_login.response.body)
  $USER['fname'] = user['FirstName']
  $USER['lname'] = user['LastName']
  $USER['phone'] = waitlist_body[:DinerInfo][:Phone][:Number]
  $RESERVATION["party_size"] = party_sz
  $RESERVATION['wait_list_queue'] = queue_msg[0][dinerno.to_i]
  $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"] = set_cancel_reso_data($USER['gpid'].to_i, email, $RESTAURANT['RID'], $RESERVATION['conf_number'], $RESERVATION['securityToken'] )
  puts "Diner 1 => #{$RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"]}"
end

def set_cancel_reso_data(gpid, email, rid, conf_number, securityToken)
  #--- creating a Hash for cancel reservation record used in put API ---
  res_record = {}
  #res_record = {"gpid" => -1, "email" => -1, "rid" => -1, "conf_number" => -1, "securityToken" => 1, "isCancelled" => -1}
  res_record['gpid'] = gpid
  res_record['email'] = email
  res_record['rid'] = rid
  res_record['conf_number'] = conf_number
  res_record['securityToken'] = securityToken
  res_record['isCancelled'] = false

  return res_record
end

And /^I should see "([^"]*)" in the wait list queue$/ do | number_in_queue |
  $g_page = RestaurantProfile.new($driver)
  $g_page.check_waitlist_status( number_in_queue)
end

And /^I verify "([^"]*)", date and "([^"]*)" in the wait-list details page$/ do |party_size, wait_list_queue|
  $g_page = BookingWaitListDetails.new($driver)
  $g_page.verify_waitlist_date
  $g_page.verify_party_size(party_size)
  $g_page.verify_waitlist_queue(wait_list_queue)
end

And /^I add mobile number if not available$/ do
  $g_page = BookingWaitListDetails.new($driver)
  $g_page.add_mobile_number
end

And /^I sign in as registered user$/ do
  $g_page = BookingDetails.new($driver)
  $g_page.click_sign_in_link
  $g_page.login_registered_user

  step %{I add mobile number if not available}
end

And /^I setup and sign in as anonymous user$/ do
  $g_page = BookingWaitListDetails.new($driver)
  $g_page.fill_anonymous_user_info
end

And /^I commit to waitlist$/ do
  step %{I click "Get text updates"}
  step %{I complete reservation}
  dinerno = $RUNTIME_STORAGE['WaitListDiner'].to_i
  $RUNTIME_STORAGE['WaitListDiner'] = dinerno + 1
end

Then /^I verify diner's "([^"]*)" reservation details on (Waitlist View page)$/ do |dinerno, object|
  $g_page.verify_reservation_details(object)

  step %{I call API GetGPIDbyEmail using email "#{$USER['email']}"}
  $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"] = set_cancel_reso_data($USER['gpid'], $USER['email'], $RESTAURANT['RID'], $RESERVATION['conf_number'], $RESERVATION['securityToken'] )
  puts "Diner info=> #{$RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"]}"
end

Then /^Waitlist diner "([^"]*)" leaves waitlist and my queue position is reset to "([^"]*)"$/ do |dinerno, wait_list_queue|
  $USER['email'] = $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"]['email']
  $RESERVATION['conf_number'] = $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"]['conf_number']
  $RESERVATION['securityToken'] = $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"]['securityToken']

  puts "Canceling reservation for email:#{$USER['email']}, conf_number:#{$RESERVATION["conf_number"]}, rid:#{$RESTAURANT["RID"]}"
  ReservationServiceV2.new().reso_cancel()
  $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1}"]['isCancelled'] = true
  $RESERVATION['wait_list_queue'] = wait_list_queue

  ####Reset Global Vars back to last diner in the queue
  dinerno = $RUNTIME_STORAGE['WaitListDiner'].to_i - 1
  $USER['email'] = $RUNTIME_STORAGE["wishlistdiner_#{dinerno}"]['email']
  $RESERVATION['conf_number'] = $RUNTIME_STORAGE["wishlistdiner_#{dinerno}"]['conf_number']
  $RESERVATION['securityToken'] = $RUNTIME_STORAGE["wishlistdiner_#{dinerno}"]['securityToken']

  #Refresh the browser
  $driver.refresh
  $driver.wait_until(60, "Spinner is still spinning after 60 secs"){!$driver.div(:class,"spinner").present?}
end

Then /^I leave the waitlist as Diner "([^"]*)"$/ do | dinerno |
  $g_page = BookingWaitListView.new($driver)
  $g_page.leave_waitlist(dinerno)
end

Then /^I leave the waitlist as Diner "([^"]*)" from Waitlist Cancel page$/ do | dinerno |
  $g_page = BookingWaitListCancel.new($driver)
  $g_page.leave_reservation
  $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1 }"]['isCancelled'] = true
end

Then /^I click View in the Upcoming Reservation section of My Profile$/ do
  $g_page = ProfileInfo.new($driver)
  $g_page.click_on_reso_view
end

Then /^I click Cancel in the Upcoming Reservation section of My Profile$/ do
  $g_page = ProfileInfo.new($driver)
  $g_page.click_on_reso_cancel
end