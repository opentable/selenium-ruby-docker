Then /^I clear cookies$/ do
  BrowserUtilities.clear_cookies($driver)
end

Then /^I close the browser$/ do
  #close_all_browser
  BrowserUtilities.close_all_browsers
  $driver=nil
end

Then /^I open the browser$/ do
  BrowserUtilities.open_browser($browser_type)
end

Given /^I start with a new browser$/ do
  #I close all browser
  BrowserUtilities.close_all_browsers
  $driver = BrowserUtilities.open_browser($browser_type)
  BrowserUtilities.clear_cookies($driver)
end

And /^I start with a new browser with locale for "([^"]*)"$/ do |domain|
  $browser_type = $default_browser
  if !ENV['BROWSER_TYPE'].nil?
    $browser_type = ENV['BROWSER_TYPE']
  end
  #I close all browser
  BrowserUtilities.close_all_browsers
  $driver = BrowserUtilities.open_browser_with_domain(domain , $browser_type)
  BrowserUtilities.clear_cookies($driver)
end

# @ToDo: refactor feature file to remove references to absolute urls
# use relative urls where possible
Then /^I navigate to url "([^"]*)"$/ do |url_partial_or_full|
  begin
    url_partial = (url_partial_or_full.eql? "#{$domain.www_domain_selector}") ? "" : url_partial_or_full
    $driver = BrowserUtilities.navigate_to_url(url_partial, $driver)
  rescue Exception => e
    begin
      $driver.refresh if !$driver.nil?
    rescue Exception => e2
      raise "Exception #{e2.message} caught while navigating to url #{url_partial} "
    end
  end
  $redirected_url = $driver.url
  puts "Testing #{$driver.url}"
end

Then /^I start Firefox browser with (default|WebDriver) profile$/ do |profilename|
  BrowserUtilities.close_all_browsers
  $driver = BrowserUtilities.open_browser("firefox", profilename)
end

When(/^I navigate to charm url "([^"]*)"$/) do |url|
  BrowserUtilities.close_all_browsers
  $driver = BrowserUtilities.open_browser($browser_type, "WebDriver")
  $driver.goto("http://#{$domain.charm_address}/#{url}")
end
