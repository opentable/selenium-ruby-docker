
Then(/^I should be on start page$/) do
  $g_page.get_element("My Profile")
end

Given(/^I am an existing "([^"]*)" user with "([^"]*)" loginname and "([^"]*)" email and have upcoming reservation in "([^"]*)" at restaurant "([^"]*)" in "([^"]*)"$/) do |usertype, loginName, email, days, rid,domain|
  $domain = Domain.new(domain)
  if usertype.downcase == 'concierge' || usertype.downcase == 'admin'
    @user = NewUserAPI.new({:email => email, :is_admin => true, :is_register => true})
    gpid = @user.get_user_gpid_by_login(loginName)
  else
    @user = NewUserAPI.new({:email => email, :is_admin => false, :is_register => true})
    gpid = @user.get_user_gpid
  end

  @reservation ||= ReservationServiceV2.new()
  current_time = Time.new.hour.to_s + ":00"
  make_body = @reservation.make_body( gpid, days, current_time, "Standard", "Default", 2 , @user.is_admin, "Standard")
  confnum = @reservation.reso_make(rid, make_body)
  raise Exception, "Failed to make reservation using api.  Status code: #{@reservation.response.code.to_i} " unless @reservation.response.code.to_i == 201
  @rid = rid
  @confnumber = confnum
  ##Adding the following rows for cancellation purposes
  $USER['email'] = email
  $USER['gpid'] = gpid
  $USER['isAdmin'] = @user.is_admin
  $RESERVATION['conf_number'] = confnum
  $RESTAURANT['RID'] = rid
  $RESERVATION['resid'] = @reservation.reso_retrieve("reservationId")
  points = @reservation.reso_retrieve("points")
  if ENV['TEST_ENVIRONMENT'].to_s.downcase == "preprod"
    awarded_points = 100
    awarded_points = 0 if $domain.domain.downcase.include? "com.au"
    raise Exception, "Expected Points for registered users to be #{awarded_points}.  Actual Points awarded: #{points.to_i} " unless points.to_i == awarded_points.to_i
  elsif ENV['TEST_ENVIRONMENT'].to_s.downcase == "prod"
    raise Exception, "Expected Points for registered users for Demoland rids is 0.  Actual Points awarded: #{points.to_i} " unless points.to_i == 0
  end
end

And(/^I login on "([^"]*)" page with "([^"]*)" and "([^"]*)"$/) do |loginpage, username, password|
  $driver = BrowserUtilities.navigate_to_url(loginpage, $driver)
  $g_page =Login.new($driver)
  $g_page.login(username, password)
end

Then /^I modify the reservation to "([^"]*)" using api$/ do |days|
  @reservation ||= ReservationServiceV2.new()
  current_time = Time.new.hour.to_s + ":00"
  make_body = @reservation.make_body( $USER['gpid'], days, current_time, "Standard", "Default", 2 , $USER['isAdmin'], "Standard")
  @reservation.reso_update(make_body)
end

Then /^I cancel my reservation using api$/ do
  @reservation ||= ReservationServiceV2.new()
  @reservation.reso_cancel()
end

And(/^I add optimizely and affiliate cookie$/) do
  browser_cookies = BrowserCookies.new($driver)
  browser_cookies.add_specific_cookie("optimizelyOptOut", "true")
  browser_cookies.add_specific_cookie("EnableNodeAffiliate", "")
end