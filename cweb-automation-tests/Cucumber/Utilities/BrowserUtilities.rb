module BrowserUtilities
  $FF_LOCALE = {
      ".com" => "en",
      ".com.mx" => "es",
      ".co.uk" => "en",
      ".de" => "de",
      ".ie" => "en",
      ".jp" => "ja",
      ".com.au" => "en"
  }

  def self.navigate_to_url(domain_specific_url, driver=$driver)
    if driver.nil?
      driver = open_browser($browser_type)
      ##Ubuntu requires the following line to work otherwise driver will be nil outside this function
      $driver = driver
    end
    puts "Partial url-> #{domain_specific_url}"
    if !(domain_specific_url.include? "http")
      if !(domain_specific_url.include? $domain.rest)
        domain_specific_url = "http://#{$domain.rest}/#{domain_specific_url}"
      else
        domain_specific_url = "http://#{domain_specific_url}"
      end
    end
    $opentable_starturl = domain_specific_url.split('?').first
    puts "$opentable_starturl -> #{$opentable_starturl}"
    if domain_specific_url.include? "?"
      domain_specific_url << "&optimizely_disable=true"
    else
      domain_specific_url << "?optimizely_disable=true"
    end
    driver.goto(domain_specific_url)
    driver.wait_until(30, "Waited 30 secs for page to complete") { driver.execute_script("return window.document.readyState") == "complete" }
    driver.cookies.add("otaboff","1",{expires: 1.days.from_now})
    driver.cookies.add("abtestDisable",true)
    driver.cookies.add("optimizelyOptOut","true",{expires: 1.days.from_now})
    ## Need to delete privacy_count cookie first before adding new so we don't get duplicates
    ## Refresh the page so that we don't see the terms of use banner
    BrowserCookies.new(driver).delete_specific_cookie("privacy_count")
    driver.cookies.add("privacy_count","3",{expires: 1.days.from_now})
    driver.refresh
    driver.wait_until(30, "Waited 30 secs for page to complete") { driver.execute_script("return window.document.readyState") == "complete" }
    return driver
  end


  def self.navigate_to_url_query_string(domain_specific_url, query, driver)
    driver.goto(domain_specific_url + (query[0].chr == '?' ? "" :"?") + query)
    return driver
  end

  def self.clear_cookies(driver)
    driver.cookies.clear
  end

  def self.attach_browser_with_title(title, driver)
    puts %{Attached to: #{driver.title} (#{driver.url})}
    driver = FireWatir::Firefox.attach(:title, /#{title}/)
    return driver
  end


  # closes defined browsers (ff, ie)
  def self.close_all_browsers
    if Kernel.is_windows?
      require 'win32ole'
      begin
        @mgmt = WIN32OLE.connect('winmgmts:\\\\.')
        @mgmt.ExecQuery("Select * from Win32_Process Where Name = 'firefox.exe' Or Name = 'chrome.exe' Or Name = 'iexplore.exe'").each do |item|
          item.Terminate()
          sleep 1
        end
      rescue

      end
    elsif Kernel.is_unix?
      process_ids = Utilities.get_unix_process_ids("chrome")
      process_ids = Utilities.get_unix_process_ids("firefox") if $default_browser == 'firefox'

      Utilities.kill_unix_process_ids(process_ids) unless process_ids.empty?
    else
      raise RuntimeError, "unrecognized environment"
    end
  end


  def self.init_driver_ff(profilename)
    begin
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile.native_events = false
      profile.secure_ssl = true
      profile.assume_untrusted_certificate_issuer = false
      driver = Selenium::WebDriver.for :firefox, marionette:true, profile:profile, :desired_capabilities => {"version" => 54.0}
    rescue Exception => e
      raise Exception, "Failed to set driver => #{e.message}\n#{e.backtrace.join("\n")}"
    end
    return driver
  end

  def self.init_driver_ie
    driver = Selenium::WebDriver.for :ie
    return driver
  end

  def self.init_driver_chrome(user_agent = nil)
    if user_agent == nil
      driver = Selenium::WebDriver.for :chrome
    else
      driver = Selenium::WebDriver.for :chrome, :switches => ["--user-agent=#{user_agent}"]
    end
    return driver
  end

  def self.find_binary(binary_name)
    binary_name = "#{binary_name}.exe"
    paths = ENV['PATH'].split(File::PATH_SEPARATOR)
    paths.each do |path|
      exe = File.join(path, binary_name)
      return exe if File.executable?(exe)
    end
    nil
  end

  def self.init_driver_phontomjs(useragent)
    if useragent == nil
      driver = Selenium::WebDriver.for :phantomjs
    else
      driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => {"phantomjs.page.settings.userAgent" => useragent}
    end
    return driver
  end

  #ToDO: Possibly Delete this code...before checking in
  def self.init_driver_headless
    capabilities = WebDriver::Remote::Capabilities.htmlunit(:javascript_enabled => true)
    driver = Watir::Browser.new(:remote, :url => 'http://127.0.0.1:4444/wd/hub', :desired_capabilities => capabilities)
    return driver
  end

  def self.init_driver_browserstack
    url = "http://larryquantz1:cimwq2pjAMH9xudxJqXq@hub.browserstack.com/wd/hub"
        capabilities = Selenium::WebDriver::Remote::Capabilities.new
    capabilities['browser'] = ENV['SELENIUM_BROWSER'] || 'safari'
    #capabilities['browser_version'] = '10'
    capabilities['browserstack.debug'] = 'true'
    capabilities['browserstack.local'] = 'true'
    capabilities['os'] = 'OS X'
    #capabilities['os'] = 'Windows'
    capabilities['os_version'] = 'Yosemite'
    #capabilities[:browserName] = 'iexplore'
    capabilities[:platform] = 'MAC'
    capabilities['device'] = 'iPad Air'

    capabilities['javascriptEnabled'] = 'true'
    capabilities['resolution'] = '1920x1080'
    driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => capabilities)
    return driver
  end

  def self.init_driver_saucelabs
    require 'selenium/webdriver/remote/http/persistent'
    http_client_persistent = ::Selenium::WebDriver::Remote::Http::Persistent.new
    http_client_persistent.timeout = 300
    #url = "http://larryquantz1:cimwq2pjAMH9xudxJqXq@hub.browserstack.com/wd/hub"
    url = "http://OpenTable:b6e45c6d-438b-44ad-a368-09c284cccf5c@ondemand.saucelabs.com:80/wd/hub"
    capabilities = initialize_saucelabs_capabilities()

=begin
    capabilities['platform'] = 'OS X 10.10'
    capabilities['version'] = '7.1'
    capabilities['deviceName'] = 'iPad Simulator'
    capabilities['device-orientation'] = 'portrait'
 =end
    capabilities['appiumVersion'] = '1.3.6'
    capabilities['deviceName'] = 'iPad Simulator'
    capabilities['device-orientation'] = 'portrait'
    capabilities['platformVersion'] = '8.1'
    capabilities['platformName'] = 'iOS'
    capabilities['browserName'] = 'Safari'

    capabilities['job-name']='CC test'

    capabilities['javascriptEnabled'] = 'true'
    capabilities['css_selectors_enabled'] = 'true'
    capabilities['native_events'] = 'true'
    #capabilities['resolution'] = '1920x1080'     
=end
    driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => capabilities, :http_client => http_client_persistent)
    return driver
  end

  def self.initialize_saucelabs_capabilities
    case ENV['BROWSER_VENDOR']
      when "IE"
        capabilities =  Selenium::WebDriver::Remote::Capabilities.internet_explorer
        capabilities['platform'] = 'Windows 7'
        capabilities['version'] = '10.0'
      when "FF"
        capabilities =  Selenium::WebDriver::Remote::Capabilities.firefox
        capabilities['platform'] = 'Windows 10'
        capabilities['version'] = '41.0'
      when "CHROME"
        capabilities =  Selenium::WebDriver::Remote::Capabilities.chrome
        capabilities['platform'] = 'Windows 10'
        capabilities['version'] = '55.0'
      else raise Exception 'unrecognized browser type!'
    end
    return capabilities
  end

  def self.open_browser(browser, profilename=nil)
    driver = nil
    $g_page = nil
    case browser
      when "firefox"
        driver = init_driver_ff(profilename)
      when "ie"
        driver = init_driver_ie
      when "chrome"
        driver = init_driver_chrome(profilename)
      when "phontomjs"
        driver = init_driver_phontomjs(profilename)
      when "headless"
        driver = init_driver_headless
      when "browserstack"
        driver = init_driver_browserstack
      when "saucelabs"
        driver = init_driver_saucelabs
      else
        raise Exception, "unsupported browser type!"
    end

    driver = Watir::Browser.new driver
    OpenTableSite::init driver
    driver = self.browser_window(driver)
    all_browsers << driver
    return driver
  end

  def self.browser_window (driver)
    #Sets window to display large date format.  Using driver.window.maximize will cause the test to fail in TeamCity as although the browser width is 1032, the responsive
    #design looks at the inner browser width (ie minus the scrollbar) to decide the date format which is the mm/dd format or variants of it
    driver.window.resize_to(1100, 1200)
    return driver
  end

  def self.get_ff_profile(profilename)
    if profilename.nil?
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile.add_extension "utilities/JSErrorCollector.xpi" rescue p "Cannot add JSErrorCollector.xpi to profile"
    else
      profile = Selenium::WebDriver::Firefox::Profile.from_name profilename
      profile.add_extension "utilities/JSErrorCollector.xpi" rescue p "Cannot add JSErrorCollector.xpi to profile"
    end
    profile
  end


  def self.open_browser_with_domain(domain, browser_type)
    if browser_type.downcase.eql? 'firefox'
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile["intl.accept_languages"] = $FF_LOCALE[domain.to_s]
      profile.native_events = false
      #driver = Selenium::WebDriver.for :firefox, :profile => profile
      driver = Selenium::WebDriver.for :firefox, marionette:true, profile:profile, :desired_capabilities => {"version" => 54.0}
    elsif browser_type.downcase.eql? 'chrome'
      profile = Selenium::WebDriver::Chrome::Profile.new
      profile["intl.accept_languages"] = $FF_LOCALE[domain.to_s]
      driver = Selenium::WebDriver.for :chrome, profile:profile
    end
    driver = Watir::Browser.new driver
    driver = self.browser_window(driver)
    return driver
  end

  def self.open_browser_with_locale(locale)
    profile = Selenium::WebDriver::Firefox::Profile.new
    #profile = get_ff_profile(profileame=nil)
    profile["intl.accept_languages"] = locale
    profile.native_events = false
    driver = Selenium::WebDriver.for :firefox, marionette:true, profile:profile, :desired_capabilities => {"version" => 54.0}
    driver = Watir::Browser.new driver
    return driver
  end

  def self.open_browser_with_user_agent(useragentname, browser_type)
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['general.useragent.override'] = useragentname
    profile.native_events = false
    #driver = Watir::Browser.new :firefox, :profile => profile
    driver = Selenium::WebDriver.for :firefox, marionette:true, profile:profile, :desired_capabilities => {"version" => 54.0}
  end

  def self.add_cookies_to_browser(cookies, driver)
    cookies.each { |c|
      unless c[:expires].nil?
         driver.driver.manage.add_cookie(c)
        end
    }
  end

  def self.get_cookies_from_browser(driver)
    cookies = driver.driver.manage.all_cookies
    return cookies
  end

  def self.all_browsers
    @@all_browsers ||= []
  end

  #clears the all browsers object allowing the drivers to be garbage collected
  def self.clear_browsers_collection
    @@all_browsers = nil
  end

  def self.close_browser_collection
    ObjectSpace.each_object Watir::Browser do |browser|
      browser.window.close
    end
  end

end
