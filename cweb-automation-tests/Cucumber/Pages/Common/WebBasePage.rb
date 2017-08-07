# -*- coding: utf-8 -*-

# Contains methods to that implement various wait conditions
# All static methods
class WaitHelper

  def self.wait_until_url_present(browser, expected_url, timeout_in_seconds)
    1.upto(timeout_in_seconds) {
      url = browser.url
      if url.include? expected_url
        return true
      end
      sleep 1
    }
    false
  end

  # Wait until object is not nil and until object exists
  # Returns true of false
  # @param object [UI object, ie browser.text_field(:id, "id")]
  # @param timeout_in_seconds [Time ount in seconds (integer)]
  def self.wait_until_exists(object, timeout_in_seconds)
    1.upto(timeout_in_seconds) {
      if !object.nil?
        if object.exists?
          return true
        end
      end
      sleep 1
    }
    false
  end

end

class WebBasePage < OpenTableSite::PageObject

  def self.page_url_match? (url)
    url.match /#{product_name}\..*\/#{page_name}/i
  end

  def self.product_name
    nil
  end

  def self.set_g_page (url)
#    puts "url=>#{url}"
    if $driver.element(:css, "div[data-page-identifier='restaurantProfile']").exists?
      return setup_new_page(RestaurantProfile)
    elsif url.to_s=~/(\w+).*-restaurants/ or $driver.html.include?("window.OTCurrentPage = 'start'")
      return setup_new_page(Start, $metro)
    else
      number_of_matches = 0
      matches = Array.new
      self.descendants.each do |page_class|
        if page_class.page_url_match?(url)
          matches << page_class
          number_of_matches += 1
        end
      end

      if number_of_matches == 0
        return WebBasePage.new($driver)
      elsif number_of_matches > 1
        throw "multiple matches found to match the url #{url} matches: #{matches}"
      else
        return matches[0].new($driver)
      end
    end
  end

  def self.set_g_page_by_name (page_class)
    page_class.new($driver)
  end

  attr_reader :elements, :browser_version

  def initialize(browser, elements = {})
    @driver = browser
    super browser

    # initialize base elements hash
    @elements = base_elements
    @elements = @elements.merge(elements)
  end

  def base_elements
    @elements = {
        "User Info" => "link_text;User Info", # Used by Charm
        "Modify Reservation" => {
            "1" => "element_css;.upcoming-res-link.secondary:nth-of-type(2)",  #defines regular reservation
            "2" => "element_css;.upcoming-res-link.secondary:nth-of-type(1)"   #defines waitlist reservation
        },
        "Cancel Reservation" => {
            "1" => "element_css;.upcoming-res-link.secondary:nth-of-type(3)",  #defines regular reservation
            "2" => "element_css;.upcoming-res-link.secondary:nth-of-type(2)",   #defines waitlist reservation
        },
        "View Reservation" => "element_css;.upcoming-res-link.secondary:nth-of-type(1)",
        "Reso Restaurant Name" => "element_css;a[data-bf-acceptance='restaurantNameNetwork']",

    }

    @elements
  end

  protected :base_elements

  def create_timeline_for_ot_request_id()
    current_date = Time.now.strftime("%Y-%m-%d")
    if $driver.div(:class, "modal-content-body").frame(:id, "login-iframe").exists?
      footer_msg =  $driver.div(:class, "modal-content-body").frame(:id, "login-iframe").element(:css,"#sysInfo").text
      otrequestid =  $driver.div(:class, "modal-content-body").frame(:id, "login-iframe").element(:css,"#sysInfo").text[/OT-RequestId:.*$/,0].split(':').last.gsub(/\)$/,"")
    elsif $driver.div(:class, "modal-content-body").frame(:id, "convert-user-iframe").exists?
      footer_msg = $driver.div(:class, "modal-content-body").frame(:id, "convert-user-iframe").element(:css,"#sysInfo").text
      otrequestid = $driver.div(:class, "modal-content-body").frame(:id, "convert-user-iframe").element(:css,"#sysInfo").text[/OT-RequestId:.*$/,0].split(':').last.gsub(/\)$/,"")
    elsif @driver.element(:css,"#global-footer-system-info").exists? || @driver.element(:css,".global-footer-system-info").exists?
      if @driver.element(:css,"#global-footer-system-info").exists?
        footer_msg = driver.element(:css,"#global-footer-system-info").text
        otrequestid = driver.element(:css,"#global-footer-system-info").text[/Request ID:.*$/,0].split(':').last.gsub(/\)$/,"")
      else
        footer_msg = @driver.element(:css,".global-footer-system-info").text
        otrequestid = @driver.element(:css,".global-footer-system-info").text[/Request ID:.*$/,0].split(':').last.gsub(/\)$/,"")
      end
    end
    puts "\n\n Timeline=> http://timeline.otenv.com/request-timeline/?requestId=#{otrequestid.strip!}&searchdate=#{current_date}"
  end

  def random_email()
    unique_identifier = DateTime.now.strftime('%Y%m%d%H%M%S%L')
    email = "autogen_#{random_string(8)}" + "_" + unique_identifier + '@opentable.com'
  end

  def visit(url)
    @driver.goto(url)
  end

  def wait_for_spinner_to_complete()
    @driver.wait_until(30, "Spinner is still spinning after 30 secs"){!@driver.div(:class,"spinner").present?}
    @driver.wait_until(60, "Waiting on search page to render completely") { @driver.execute_script("return window.document.readyState") == "complete" }
  end

# returns current url
  def url()
    @driver.url
  end

  def click_alert_dialog(button_text)
    if @driver.alert.exists?
      if button_text.downcase == "close"
        @driver.alert.close
      else
        @driver.alert.ok
      end
    end
  end

# gets element of page
  def get_element(friendly_name, timeout_in_seconds = 10, context ="@driver")
    obj = nil

    #@ToDo: make key lookup case insensitive
    if !@elements.has_key?(friendly_name)
      puts "Error: friendly name \'#{friendly_name}\' not found on page with URL: " + @driver.url + ". Current page class: #{$g_page.class}"
    else
      1.upto(timeout_in_seconds) {
        if @elements[friendly_name].class.to_s.eql?("Hash")
          @elements[friendly_name].each_value { |query|
            obj = look_up(query, "#{context}")
            if !obj.nil?
              if (obj.present?) || (obj.exists?)
                return obj
              end
            end
          }
          return nil
        else
          query = @elements[friendly_name]
          obj = look_up(query, "#{context}")
          begin
             if !obj.nil?
               if (obj.present?) || (obj.exists?)
                return obj
               end
             end
          rescue
          end
        end
        sleep 1
      }
      puts "Element #{friendly_name} not found."
      return nil
    end
  end

  def look_up(query, context)
    frame_type = ""
    frames=""

    #split the query and extract the element type and the description
    if query.match(/^\(\w*\)(.*)$/)
      frame_type, desc= query.match(/^\(\w*\)\w*\;(.*)$/).to_s.split(';')
      type = frame_type[frame_type.index(')') + 1..-1]
      #add frames if there is a match. supports multiple frames.  Look for frames from the type, not desc so children of css selectors can be used
      frame_type.scan(/\(\w*\)/).each { |s|
        s = s.to_s.delete("()")
        if (s.to_s.strip=="") #support for empty frame
          frames=%{#{frames}.frame()}
        else
          frames=%{#{frames}.frame(:id,"#{s}")}
        end
      }
    else
      type, desc= query.match(/\w*\;(.*)$/).to_s.split(';')
    end

    element_type, attr = type.split("_")

    #take care of text_field and select_list because of the extra "_"
    if (type.include? "text_field") || (type.include? "select_list")
      type.match(/(.*)_(.*)_(.*)/)
      element_type = "#{$1}_#{$2}"
      attr = $3
    end

    look_up_element("#{context}#{frames}", "#{element_type}", "#{attr}", "#{desc}", true)
  end

  private :look_up

  def look_up_element(context, element_type, how, desc, b_exact_match =true, time_in_seconds =1)
    if (b_exact_match)
      str = %{#{context}.#{element_type}(:#{how}, "#{desc}")}
    else
      str = %{#{context}.#{element_type}(:#{how}, /#{desc}/i)}
    end
    begin
      1.upto(time_in_seconds) do
        obj = eval(str)
        if !obj.nil?
          if  (obj.present?) || (obj.exists?)
            return obj
          end
        elsif (time_in_seconds>1) # avoid sleep on default value
          sleep 1
        end
      end
      return nil
    rescue Exception => e
      puts "look_up_element() returned null because of the following exception: #{e.message} on element #{desc}"
      return nil
    end
  end

# returns page source
  def text
    @driver.text
  end

  def click_upcoming_reso_box
    #This is a workaround as the notification box is not always present.  AUTO-160
    $i = 0
    while !get_element( "Upcoming Reservation Count", 10).present? && $i < 3 do
      @driver.goto($driver.url)
    end
    $i += 1
    if get_element( "Upcoming Reservation Count").present?
      $g_page.click("Upcoming Reservation Count")
    else
      raise Exception "Upcoming Reservation box not found"
    end
  end

  def find(friendly_name)
    get_element(friendly_name)
  end

  def click_my_profile
    #This is a workaround for a bug where the user name does not show immediately in SRS menu AUTO-160
    $i = 0
    while !get_element( "User Name", 15).present? && $i < 4 do
      if ($domain.include? ".jp") && ($driver.url.include? "?msg=")
        @driver.goto("http://#{$domain}/start/?m=1")
      else
        @driver.goto($driver.url)
      end
      $i += 1
    end

    raise Exception, "Can't Find User Name" if !get_element("User Name",15).present?
    get_element("User Name").click
    get_element("My Profile").click if get_element("My Profile").present?
    @driver.wait_until(30, "My Profile page Not found") {$driver.url.include? "profile"}
  end

  def click_sign_out
    get_element("User Name").click unless !get_element("User Name", 5).exists?
    @driver.element(:css, 'a#no-global_nav_logout.menu-list-link').click unless !@driver.element(:css, 'a#no-global_nav_logout.menu-list-link').present?
  end

  def click(friendly_name)
    @driver.wait_until(30, "Element: #{friendly_name} Not found") {get_element(friendly_name).present?}
    get_element(friendly_name).click
    if (friendly_name=="Forgot Password")
      @driver.refresh
    elsif (friendly_name=="Create an account")
      get_element("First", 30)
    end
  end

  def select(friendly_name, value)
    if !get_element(friendly_name).selected? value
      get_element(friendly_name).select value
      # revert back the change
      @driver.send_keys :enter
    end

  end

  def select_by_value_attribute(friendly_name, value)
    if !get_element(friendly_name).option(:value, "#{value}").selected?
      get_element(friendly_name).select_value("#{value}")
      # revert back the change
      @driver.send_keys :enter
    end
  end

  def escape_char(value)
    matchers = {
        "'" => "\\'",
        "[" => "\\[",
        "]" => '\\]'
    }
    value.gsub!(/\'|\[|\]/) { |match| matchers[match] }
    puts "Value=>#{value}"
    return value
  end

  def set(friendly_name, value)
    value = escape_char(value)
    @driver.wait_until(30, "Unable to find element #{friendly_name} after 30 secs"){get_element(friendly_name).present?}
    type, cssSelector = @page_elements[friendly_name].split(";")
    cssSelector = escape_char(cssSelector)
    @driver.execute_script("document.querySelector(\'#{cssSelector}\').value = \'#{value}\'")
    get_element(friendly_name).click
   end

  def clear(friendly_name)
    get_element(friendly_name).clear
  end

  def get(friendly_name)
    get_element(friendly_name)
    #   e.get value
  end

# returns all ui objects defined
  def elements
    @elements
  end

  def login(login_name, pwd, timeout)
    case $domain.www_domain_selector
      when /\www\.opentable\.de\/en-GB/
        domain = "www.opentable.de"
      else
        domain = $domain.www_domain_selector
    end
    @login = Login.new(@driver, domain)

    if !@login.login(login_name, pwd, timeout)
      raise Exception, "failed to login!"
    end
  end

  def fill_in_text_directly(name, value)
    get_element(name, 1).send_keys(value)
  end

  # New take a screen shot function
  def take_screenshot
    #Set scenario name before each scenario
    if $scenario.class == Cucumber::Ast::Scenario or $scenario.class == Cucumber::Ast::ScenarioOutline
      scenario_name = $scenario.title
      feature_name  = $scenario.feature.title
    elsif $scenario.class == Cucumber::Ast::OutlineTable::ExampleRow
      scenario_name = $scenario.scenario_outline.title
      feature_name  = $scenario.scenario_outline.feature.title
    end

    #Set step descriptions
    long_summary = "Feature: #{feature_name} | Scenario: #{scenario_name} | Domain: #{$domain.domain.downcase} | Screenshot: #{$screenshots_path.length}"
    puts long_summary
    id_digest ||= Digest::MD5.hexdigest(long_summary)

    begin
      if ENV['TEST_ENVIRONMENT'].nil?
        file_path = "screenshots/#{scenario_name.gsub(/[^\w-]/, "_")[0..50]}/#{$domain.domain.downcase}/"
        #Create a folder for that scenario
        unless File.directory?(file_path)
          `mkdir -p #{file_path}`
        end
      else
        file_path =""
      end

      ObjectSpace.each_object Watir::Browser do |browser|
        begin
          browser.windows.each do |window|
            unless browser.url.eql? "about:blank"
              begin
                browser.window.resize_to(320, 568)
                browser.window(:url, window.url).use do
                  screenshot = "#{file_path}#{id_digest}.png"
                  browser.driver.save_screenshot(screenshot)
                  $screenshots_path[screenshot] = false
                  puts "saved screen shot #{screenshot}"
                  if screenshot_compare(screenshot)
                    $screenshots_path[screenshot] = true
                  end
                end
              rescue Exception => e
                puts "failed screenshot at the window level: #{e.class}, #{e.message}, do not be alarmed, this will happen sometimes even when things are working"
              end
            end
          end
        rescue Exception => e
          puts "failed screenshot at the browser level: #{e.class}, #{e.message}, do not be alarmed, this will happen sometimes even when things are working"
        end
      end
    rescue Exception => e
      raise Exception, "Failed to execute After Scenario Hooks for Scenario: #{e.message}\n#{e.backtrace}"
    end
  end

  #To compare baseline screen shots with current pages
  def screenshot_compare(image, output="diff_#{image}", threshold=100, gamma=2.2, fov=85, lum=100, color=1)
    if ENV['TC_COMPARE_SCREENSHOTS'] == "true"
      begin
        FileUtils.cp "screenshots\\baseline\\#{image}", "base_#{image}"
        cmd    = "Utilities\\perceptualdiff.exe base_#{image} #{image} -output #{output} -threshold #{threshold} -gamma #{gamma} -fov #{fov} -luminance #{lum} -colorfactor #{color}"
        #puts cmd
        result = Array.new
        begin
          Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
            while line = stdout.gets
              puts line
              result << line
            end
          end
        rescue Exception => e
          puts "Fail to compare screen shots: #{e.class}, #{e.message}"
        end
      rescue Exception => e
        puts "Fail to copy baseline file: #{e.class}, #{e.message}"
      end

      return !result.empty?
    end
  end

  def get_js_error_feedback()
    jserror_descriptions = ""
    begin
      puts "Checking JS error"
      jserrors = @driver.execute_script("return window.JSErrorCollector_errors.pump()")
      jserrors.each do |jserror|
        puts "ERROR: JS error detected:\n#{jserror["errorMessage"]} (#{jserror["sourceName"]}:#{jserror
        ["lineNumber"]})"
        jserror_descriptions += "JS error detected: #{jserror["errorMessage"]} (#{jserror
        ["sourceName"]}:#{jserror["lineNumber"]})"
      end
    rescue Exception => e
      puts "Checking for JS errors failed with: #{e.message}"
    end
    jserror_descriptions
  end
end
