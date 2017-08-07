# -*- coding: utf-8 -*-
# encoding: utf-8

RESTAURANTS = {
    "restaurant1" => $rid1,
    "restaurant2" => $rid2,
    "restaurant3" => $rid3
}

RESTAURANT_NAMES = {
    $rid1 => $rname1,
    $rid2 => $rname2,
    $rid3 => $rname3
}

def should_see_element(element, should_be_on_page)
  if (element!=nil) #null if element not found
    if (!element.exists? && should_be_on_page)
      raise Exception, "element not found on page!"
    elsif (element.exists? && !should_be_on_page)
      raise Exception, "element found on page when it is not supposed to be!"
    elsif (!should_be_on_page)
      raise Exception, "Link Non Grata !"
    end
  else
    if (should_be_on_page)
      raise Exception, "element not found on page!"
    end
  end
end

Then /^I fill in "([^"]*)" with random email/ do |name|
  if $USER['email'].include? "Auto_Gen_"
    $g_page.set(name, $USER['email'].to_s)
  else
    value = $g_page.random_email
    $g_page.set(name, "#{value}")
    $USER['email'] = "#{value}"
  end
  puts "randomly generated email is: " + $USER['email'].to_s
end

Then /^I fill in "([^"]*)" with random text$/ do |name|
  value = "#{random_string(8)}"
  $g_page.set(name, value)
end

Then /^I fill in "([^"]*)" with "([^"]*)"$/ do |name, value|
  $g_page.set(name, value)
end

Then /^I click "([^"]*)"$/ do |name|
  if name == "Find a Table"
    $g_page = Start.new($driver) if $opentable_starturl.include? "diprogram.aspx"
    $g_page.get_element("Find a Table").focus
    $g_page.get_element("Find a Table").click
    $g_page.wait_for_spinner_to_complete()
    $driver.wait_until(60, "Search/Details page not visible") {($driver.url.include? "details") || ($driver.url.include? "view") || ($driver.url.include? "\/s\/\?covers=") || ($driver.url.eql? $redirected_url) || ($driver.url.include? "\&covers=")}
  elsif name == "Modify"
    $g_page.click_modify_link
  elsif name == "Cancel"
    $g_page.click_cancel_link
  elsif name == "My Profile"
    $g_page.click_my_profile
  elsif name == "Sign Out"
    $g_page.click_sign_out
  elsif name == "Edit Diner List"
    $g_page.click_add_diner
  elsif name == "View all reservations"
    $g_page.view_all_reservations
  elsif name == "Upcoming Reservation Count"
    $g_page.click_upcoming_reso_box
  elsif name == "Get text updates"
    $g_page.opt_in_text_updates
  else
    $g_page.click(name.strip)
  end
end

And /^I click "([^"]*)" in Upcoming Reservation window$/ do |name|
 if name == "View"
   $g_page.click("View Reservation")
 elsif name == "Modify"
   $g_page.click("Modify Reservation")
 elsif name == "Cancel"
   $g_page.click("Cancel Reservation")
 elsif name == "Invite"
   $g_page.click("Invite Friends")
 end
end

Then /^I click any available time slot$/ do
  if !($g_page.url.include? "details")
    $g_page.click_anytimeslot(false)
  end
  #$RESERVATION['reso_time']= $g_page.time_clicked
end

Then /^I click exact time slot$/ do
  if ($g_page.url.include? "change")|| ($g_page.url.include? "/book/view") || ($g_page.url.match /book\/..*\/view/)
    $g_page.click_time_slot
  end
end

Then /^I select "([^"]*)" item "([^"]*)"$/ do |name, item|
  item = item.strip
  if (name == "Select a Location")
    OTActions.SelectLocation($driver, nil, item, nil)
  else
    $g_page.select(name, item)
  end
end

Then /I select restaurant "([^"]*)"/ do |restaurant|
  sleep 0.1
  #@ToDo: Review. May or may not be good to embed multiple path flow in the step
  if !$driver.url.include? 'single.aspx'
    $g_page = Start.new($driver)
    if !$g_page.select_restaurant(restaurant)
      raise Exception, "failed to select restaurant #{restaurant}"
    end
  else  #single.aspx urls here
     if !$driver.span(:id, "TopNav_lblRestName").text.strip.eql? restaurant
          raise Exception, "invalid restaurant #{restaurant} page"
     end
  end
  $RESTAURANT['name'] = restaurant
end

Then /^I set party size to "([^"]*)"$/ do |party_size|
  $RESERVATION["party_size_searched"] = party_size
  if $opentable_starturl.include? "diprogram.aspx"
    $g_page = Start.new($driver)
    $g_page.set_party_sz_on_new_start_page(party_size.strip)
  else
    $g_page.set_party_sz(party_size.strip)
  end
end

Then /^I find and click the metro link "([^"]*)" in the (Featured|POI) Areas$/ do |href, area|
  if (area == "Featured")
    $driver.div(:id,'page-featured-metros').element.wd.location_once_scrolled_into_view
    y_position = $driver.div(:id,'page-featured-metros').wd.location[:y]
    $driver.execute_script("scroll(0, #{y_position-100})");
    ##Workaround:  Currently the Featured areas location boxes are rendered using react and with no stable ids/names to locate
    ##the webelements.  For now, click on the location links.
    $driver.wait_until(20, "Could not find metro link #{href}"){ $driver.element(:css, ".secondary[href='#{href}']").present?}
    $driver.element(:css, ".secondary[href='#{href}']").click
  else
    $driver.div(:id,'nearby-pois').element.wd.location_once_scrolled_into_view
    $driver.element(:css, ".secondary[href='#{href}']").click
  end
end

Then /^I click link with href "([^"]*)" without regex$/ do |href|
  $g_page.look_up_element("$driver", "link", "href", href, true, 10).click
end

Then /^I click link with (exact )?text "([^"]*)"$/ do |exact, text|

  obj = $g_page.look_up_element("$driver", "link", "text", text, exact=="exact ", 9)
  obj.click
end

Then /^I should see text "(.*)" in page source$/ do |text|
  should_see_in_source(text, true)
end

Then /^I should not see text "(.*)" in page source$/ do |text|
  should_see_in_source(text, false)
end

def should_see_in_source(text, bool)
  if bool
    if (!$driver.html.include?(text.to_s.strip))
      raise Exception, "text #{text} not found on page"
    end
  else
    if ($driver.html.include?(text.to_s.strip))
      raise Exception, "text #{text} found on page when it was not expected."
    end
  end
end

Then /^I should see msg in url/ do
  $driver.wait_until(90, "?mgs not found on page!") { $driver.url.downcase.include? "?msg=" }
end
#
Then /^I should see text "([^"]*)" on page$/ do |ori_text|
  text = ori_text.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  page_text = $g_page.text.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  puts "page_text=>#{page_text}"
  $driver.wait_until(60, "text #{text} not found on page!") { page_text.downcase.include? text.downcase }
end

Then /^I should not see text "([^"]*)" on page$/ do |text|
  $driver.wait_until(60, "text #{text} still found on page!") { !$g_page.text.downcase.include? text.downcase }
end

Then /^I should see link with text "([^"]*)"$/ do |text|
  should_see_element($g_page.look_up_element("$driver", "link", "text", text, false, 10), true)
end

Then /^I should see link with href "([^"]*)"$/ do |href|
  should_see_element($g_page.look_up_element("$driver", "link", "href", href.gsub(/(?=[\/?])/, '\\'), false, 10), true)
end

Then /^I click link with href "([^"]*)"$/ do |href|
  $g_page.look_up_element("$driver", "link", "href", href.gsub(/(?=[\/?])/, '\\'), false, 90).click
end

When /^I recache consumer website for "([^"]*)" item$/ do |item_to_recache|

  timeout = 600
  if item_to_recache.downcase.eql? "all"
    timeout = 1200
  end

  @cache_mgr = CacheMgr.new($driver, $domain.www_domain_selector)
  @cache_mgr.recache_website(item_to_recache, timeout)
end

Then /^I should be on URL containing "([^"]*)"$/ do |expected_url|
  exp_url = expected_url.downcase
  should_be_on(exp_url, true)

  #Take a screenshot
  $g_page.take_screenshot if ENV['TC_TAKE_SCREENSHOTS'] == "true"

end

Then /^I should url "([^"]*)" and text "([^"]*)" on new window$/ do |expected_url, text|
  $driver.windows.last.use do
    step %{I should be on URL containing "#{expected_url}"}
    step %{I should see text "#{text}" on page}
  end
  $driver.windows.last.use.close
  $driver.windows.first.use
  #Take a screenshot
  $g_page.take_screenshot if ENV['TC_TAKE_SCREENSHOTS'] == "true"

end

def should_be_on(expected_url, bool)
  bool = !bool #avoid double negative
  #to check url once browser is in stable state
  # $driver.wait_until { $driver.execute_script("return window.document.readyState") == "complete" }
  $driver.wait_until(60, "expected: #{expected_url}. Actual: #{$driver.url}") {
    ($driver.url.downcase.include?(expected_url.downcase) ^ bool)
  }
end

When /^I enter random (text|number) with length (\d+) into "([^"]*)" and store the value under "([^"]*)"$/ do |input_type, length, friendly_name, key|
  length = length.to_i
  if input_type.include? "text"
    input = random_string(length)
  else
    input = random_integer_string(length)
  end

  step %{I fill in "#{friendly_name}" with "#{input}"}
  $RUNTIME_STORAGE[key]= input
end

Then /^I should see element "([^"]*)" on page$/ do |name|
  should_see_element($g_page.get_element(name, 15), true)
end

Then /^I click label with text "([^"]*)" if there$/ do |text|
  element = $g_page.look_up_element('$driver', 'label', 'text', text, false, 1)
  if (!element.nil?)
    element.click()
  end
end

Then /^I should (not see|see) "([^"]*)" text in the span id "([^"]*)"$/ do |visibility, textvalue, spanid|
  if visibility == "see"
    if (!$driver.span(:id, spanid).exists?)
      raise Exception, "#{spanid} not found in the"
    end
    if (!$driver.span(:id, spanid).text.to_s.strip.include? textvalue.to_s.strip)
      raise Exception, "#{textvalue}  not found in the #{spanid} "
    end
  else
    if ($driver.span(:id, spanid).exists?)
      raise Exception, "#{textvalue}  found in the #{spanid} "
    end
  end
end

Then /^I login as concierge with username "([^"]*)" and password "([^"]*)"$/ do |concierge_username, password|
  $USER['email'] = concierge_username
  $USER['password'] = password
  $g_page = ConciergeLogin.new($driver, $domain.www_domain_selector)

  $g_page.login($USER['email'], $USER['password'])
  $driver.wait_until(60, "Unable to see preferred dining page") {($driver.url.include? "-restaurants") || ($driver.url.include? "/start")}
end

Then /^I set user with username "([^"]*)" and password "([^"]*)"$/ do |username, password|
  $USER['email'] = username
  $USER['password'] = password
end

When /^I should see text with (down|upper) case stored under "([^"]*)"$/ do |casetype, elementkey|
  if casetype == "upper"
    text =$RUNTIME_STORAGE[elementkey].upcase
  else
    text =$RUNTIME_STORAGE[elementkey].downcase
  end
  step %{I should see text "#{text}" on page}
end

Then /^I click "([^"]*)" and I click alert (OK|Close) button$/ do |name, alert_button_text|
  $g_page.click(name.strip)
  $g_page.click_alert_dialog(alert_button_text)
end

When /^I click Find a Table Button and fill in anonymous user info$/ do
  fname= $USER['fname']
  lname = $USER['lname']
  email= $USER['email']
  step %{I click "Find a Table"}
  $g_page.click_findatable_fillin_anonymous_user_info(fname, lname, email)

end

Then /^I fill in anonymous user info$/ do
  $g_page.fill_anonymous_user_info

end

Then(/^I fill in random private dining user info$/) do
  $g_page = PrivateDining.new($driver)
  $g_page.set_user_choice_and_submit
end

Then(/^I select private dining language "([^"]*)"$/) do |language|
  $g_page = PrivateDining.new($driver)
  $g_page.select_language(language)
end

Then /^I should see private dining filters on page$/ do
  $g_page = PrivateDining.new($driver)
  $g_page.verify_filters_are_seen
end

And(/^I should not see link with exact text "([^"]*)"$/) do |text|
  should_see_element($g_page.look_up_element("$driver", "link", "text", text, true, 10), false)
end

And /^I should see "([^"]*)" of special occasion links on page$/ do |num|
  $g_page = PrivateDining.new($driver)
  $g_page.count_special_items(num)
end

Then /^I set user info username "([^"]*)", password "([^"]*)", firstname "([^"]*)", lastname "([^"]*)", phone "([^"]*)"$/ do |username, password, fname, lname, phone|
  $USER['email'] = username
  $USER['password'] = password
  $USER['fname'] = fname
  $USER['lname'] = lname
  $USER['phone'] = phone
end