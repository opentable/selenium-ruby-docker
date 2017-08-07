Then(/^I move to the affiliated restaurant page with url "([^"]*)"$/) do |url|
  handlecount = $driver.driver.window_handles.size
  if  $driver.driver.window_handles.size == 1
    $driver.driver.switch_to.window($driver.driver.window_handles[0])
  else

    url_tmp = url.gsub(/\//, '\/')
    url_tmp = url.gsub(/\?/, '\?')

    begin
      found = false
      $driver.driver.switch_to.window($driver.driver.window_handles[1])
      found = $driver.wait_until(60, "Waited 60 secs for page to complete") { $driver.execute_script("return window.document.readyState") == "complete" }
      if !found
        raise Exception, "Unable to find a window with url: #{url}"
      end

    rescue => e
      raise Exception, "Window with url: #{url} was not found. Error: #{e}"
    end
  end
end

And(/^I should see affiliated restaurant "([^"]*)" on page$/) do |affiliatedRestaurant|
  $driver.wait_until(30, "text #{affiliatedRestaurant} not found on page!") { $g_page.text.downcase.include? affiliatedRestaurant.downcase }
end

And(/^I click on restaurant "([^"]*)"$/) do |r_name|
  $driver.link(:text => r_name).link.when_present.click
  puts "thadinginathom"
  # rest_link.click
end