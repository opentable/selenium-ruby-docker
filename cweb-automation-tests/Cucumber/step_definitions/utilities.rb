#Make sure method accessible in other step definitions
def ReplaceVars(string)
  # Setup variable detection pattern: "...[...]..."
  pattern = /(.*)(\[)([^\]]*)(\])(.*)/

  # Search for pattern and replace with data from runtime storage
  #  puts "start:   " + string
  while (string.match(pattern))
    s = string.split(pattern)
=begin
	puts "length : " + s.length.to_s
	puts "partall: "
	puts s
	puts "part0:   " + s[0]
	puts "part1:   " + s[1]
	puts "part2:   " + s[2]
	puts "part3:   " + s[3]
	puts "part4:   " + s[4]
	string.sub!(pattern, '\1<\3>\5')
=end
    assert(!s[0].nil?) # for some reason this is always nil
    var = $RUNTIME_STORAGE[s[3]]
    string = (s[1].nil? ? "" : s[1]) + (var.nil? ? "" : var) + (s[5].nil? ? "" : s[5])
#	puts "middle2: " + string
  end

#  puts "end:     " + string
  string
end

# @ToDo discuss grammar for below step
When /^I set test domain to "([^"]*)"$/ do |domain|
  # @ToDo: make this work with other products (ie mobile, etc), rename to <product>_address

  #Create new object of Domain class (defined in lib)
  $domain = Domain.new(domain)
  if $TEST_ENVIRONMENT.eql? "Prod"
    $domain.charm_address = $domain.charm_prod_address
    $domain.primary_metro_id = $domain.prod_primary_metro_id
    $domain.region_id = $domain.prod_region_id
    $domain.int_services = $domain.prod_int_services
  end

end

def random_string(length)
  "#{(1..length).map { |_| ('a'..'z').to_a[rand(26)] }.join}"
end

def random_integer_string(length)
  (1..length).map { |_| ('0'..'9').to_a[rand(10)] }.join
end

# # @ToDo: make below two steps into one
When /^I set mail server account login to "([^"]*)"$/ do |mail_account_user_name|
  $MAIL_USER = mail_account_user_name
end

When /^I set mail server account password to "([^"]*)"$/ do |mail_account_user_password|
  $MAIL_PWD = mail_account_user_password
end

def compare_images(img1, img2)
  puts "comparing #{img1} with #{img2}"
  puts "image compare tool exe path: #{File.expand_path("..")}/Cucumber/test_data/Testtool/ImageDiffTool/"
  out=system("#{File.expand_path("..")}/Cucumber/test_data/Testtool/ImageDiffTool/perceptualdiff.exe #{img1} #{img2}".gsub("/", "\\"))
  puts "Result is #{out}"
  out
end

def download_image(url, img_name, new_file_name)
  include "open-uri"
  unless ENV['TEST_ENVIRONMENT'].eql? "Prod"
    port = $domain.webserver_site_port
    sitetype_id = $domain.webserver_sitetype_id
    domain = $domain.www_domain_selector
    uri =  CacheMgr.new($driver).build_url_based_on_number_of_server(port, sitetype_id, domain)
  end
  if uri.class  == Array; url = uri[0] else url  end
  path = "http://#{url}#{img_name}"
  puts path
  open("#{path}") { |f|
    File.open(new_file_name, "wb") do |file|
      file.puts f.read
    end
  }
end

################################################
# takes screen shot of failed step
# and embeds into html report
#
# @browser Browser handle
#
################################################
def take_screen_shot(browser)
  time = Time.new
  screenshot = "#{time.month}-#{time.day}-#{time.year}_#{time.hour}_#{time.min}_#{time.sec}-#{(1..50).map { |_| ('a'..'z').to_a[rand(26)] }.join}.png"
  browser.driver.save_screenshot(screenshot)
  embed screenshot, 'image/png'
end
