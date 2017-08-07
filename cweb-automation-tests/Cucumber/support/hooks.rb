require 'open3'

After do |scenario|
  # puts "After hook: Clear global hashes, capture screenshot"
  begin
    if scenario.failed? && $driver.span(:id, 'lblErrorMsg').exists?
      puts $driver.html
    end
  rescue
  end
  begin
    if scenario.failed? && ENV['TC_SUPPRESS_SCREENSHOTS'].nil?
      ObjectSpace.each_object Watir::Browser do |browser|
        begin
          WebBasePage.new(browser).create_timeline_for_ot_request_id()
          browser.windows.each do |window|
            begin
              browser.window(:url, window.url).use do
                time = Time.new
                win_file_safe_url = window.url.gsub(/[^\w-]/, "-")[0..100]
                screenshot = "#{time.year}-#{time.month}-#{time.day}-#{time.hour}#{time.min}#{time.sec}#{time.subsec.to_f}#{win_file_safe_url}.png"
                browser.driver.save_screenshot(screenshot)
                embed screenshot, 'image/png', 'screenshot_taken_when_issue_encountered'
              end
            rescue => e
              puts "failed screenshot at the window level: #{e.class}, #{e.message}, do not be alarmed, this will happen sometimes even when things are working"
            end
          end
        rescue => e
          puts "failed screenshot at the browser level: #{e.class}, #{e.message}, do not be alarmed, this will happen sometimes even when things are working"
        end
      end
      if Kernel.is_windows?
        time = Time.new
        screenshot = "#{time.year}-#{time.month}-#{time.day}-#{time.hour}#{time.min}#{time.sec}#{time.subsec.to_f}desktopshot.png"
        Win32::Screenshot::Take.of(:desktop).write(screenshot)
        puts "saved desktop screenshot #{screenshot}"
        embed screenshot, 'image/png', 'windows_level_screenshot_taken_when_issue_encountered'
      end
    end

    #Embed screen shots in cucumber report
    if ENV['TC_TAKE_SCREENSHOTS'] == "true"
      $screenshots_path.each do |screenshot_path, is_fail|
        puts "screenshot: #{screenshot_path},  --is_fail: #{is_fail}"
        ## remove Teamcity screenshot root from the screenshot path.
        screenshot = screenshot_path.gsub("#{ENV['TC_SCREENSHOTS_PROJECT_ROOT_DIR']}", '')
        screenshot_name = File.basename(screenshot)
        screenshot_sub_dir = File.dirname(screenshot)

        embed ".#{screenshot}", 'image/png', "Screenshot: #{screenshot_path}"

        if is_fail && !is_fail.downcase.include?('baseline image')
          begin
            if ENV['TC_COMPARE_SCREENSHOTS'] == "true"
              embed ".#{screenshot_sub_dir}/base_#{screenshot_name}", 'image/png', "Baseline Screenshot"
              if is_fail.downcase.include? 'dimensions do not match'
                embed ".#{screenshot_sub_dir}/diff_#{screenshot_name}", 'image/png', "Image dimensions do not match.  PDiff Screenshot was not generated!"
              else
                embed ".#{screenshot_sub_dir}/diff_#{screenshot_name}", 'image/png', "PDiff Screenshot"
              end
            end
          rescue Exception => e
            puts "failed to embed screen shots in cucumber report: #{e.class}, #{e.message}"
          end
        end
      end
    end

    #cancel reservations if not done so already
    if ($RUNTIME_STORAGE['WaitListDiner'].to_i > 0)
      dinerno = $RUNTIME_STORAGE['WaitListDiner'].to_i - 1
      for i in 0..dinerno
        if !($RUNTIME_STORAGE["wishlistdiner_#{i}"]['isCancelled'])
          $USER['email'] = $RUNTIME_STORAGE["wishlistdiner_#{i}"]['email']
          $RESERVATION['conf_number'] = $RUNTIME_STORAGE["wishlistdiner_#{i}"]['conf_number']
          $RESERVATION['securityToken'] = $RUNTIME_STORAGE["wishlistdiner_#{i}"]['securityToken']
          $RESTAURANT['RID'] = $RUNTIME_STORAGE["wishlistdiner_#{i}"]['rid']
          puts "Canceling reservation for email:#{$USER['email']}, conf_number:#{$RESERVATION["conf_number"]}, rid:#{$RESTAURANT["RID"]}"
          ReservationServiceV2.new().reso_cancel()
          $RUNTIME_STORAGE["wishlistdiner_#{i}"]['isCancelled'] = true
        end
      end
    else
      if !$RESERVATION["isCancelled"]
        puts "Canceling reservation for email:#{$USER['email']}, conf_number:#{$RESERVATION["conf_number"]}, rid:#{$RESTAURANT["RID"]}"
        ReservationServiceV2.new().reso_cancel()
      end
    end
    #clearing global hash variable after each scenario
    $RUNTIME_STORAGE = {}
    $RUNTIME_STORAGE['WaitListDiner'] = 0
    $USER = {}
    $RESERVATION = {}
    $RESTAURANT = {}
    $Anomalies = {}
    $API_RESPONSE = {}
    # $domain.umami_front_end_vars
    #clearing driver and page variable if not indiateam feature
    # if !$isindiaTeamFeature
      BrowserUtilities.clear_browsers_collection
      $driver = nil
      $g_page = nil
      $erb_res = nil
    # end
  rescue Exception => e
    warn "Warning: Failed to execute After Scenario Hooks for Scenario: #{e.message}\n#{e.backtrace}"
  end
end

#initializing user,reservation and runtime storage hash before the scenario
Before do |scenario|
  $RUNTIME_STORAGE.clear
  $USER = {}
  $RUNTIME_STORAGE = {}
  $RESERVATION = {}
  $Anomalies={}
  $RESERVATION["isRestref"]=false
  $RESERVATION["isCancelled"]=false
  $USER['city'] = "San Francisco Bay Area"
  $USER['lname'] = random_string(8)
  $USER['fname'] = random_string(8)
  $USER['phone'] = "4152223344"
  $USER['email'] = "#{random_string(8)}@opentable.com"
  $USER['username'] = "auto_user"
  $USER['password'] = "password"
  $USER['charm_username'] = "administrator"
  $USER['charm_password'] = "0pentab1e"
  $USER['IsRegister']= false
# Use date time for precision
  $USER['random'] = "#{random_string(8)}@opentable.com"
  $USER['admin'] = false
  $qc_description = "No description available"
  $erb_res = Array.new
  $API_RESPONSE = {}

  $scenario = scenario
  $screenshots_path = {}

end

AfterStep do |scenario|

  unless $driver.nil?
    if !($driver.url.include? ".xml")

      begin
        # $driver.execute_script("") is needed to avoid doc.body and doc.html errors
        $driver.execute_script("")
        $driver.wait_until { $driver.execute_script("return window.document.readyState") == "complete" }
      rescue Watir::Wait::TimeoutError => e
        puts "unable to get document.readyState #{e}"
      rescue Selenium::WebDriver::Error::JavascriptError => e
        puts "Rescued from \"Selenium::WebDriver::Error::JavascriptError #{e},\" retrying"
        retry
      end

      $driver.wait_until {
        !$driver.url.include? "interim.aspx"
      }

      url = $driver.driver.current_url.downcase

      if url != $driver.url.downcase
        puts "Different urls returned."
        puts "$driver.driver.current_url = #{$driver.driver.current_url}"
        puts "$driver.url = #{$driver.url}"
      end

      setup_g_page(url)
    end
  end
end

Before do
  if ENV['TC_SCREENSHOTS_PROJECT_ROOT_DIR'].nil?
    ENV['TC_SCREENSHOTS_PROJECT_ROOT_DIR'] = 'screenshots'
  end
  $image_directory = ENV['TC_SCREENSHOTS_PROJECT_ROOT_DIR']

  set_up_domain
end

def set_up_domain
  if ENV['TEST_DOMAIN'].nil?
    ENV['TEST_DOMAIN'] = '.com'
  end
  $domain = Domain.new(ENV['TEST_DOMAIN'])
end


def setup_g_page(url)
  $g_page = WebBasePage.set_g_page(url)
end

def setup_g_page_by_name(page_class)
  $g_page = WebBasePage.set_g_page_by_name(page_class)
end

def setup_new_page(page_class, *args)
  # avoid re-assigning the same page.
  if ($g_page == nil || $g_page.class != page_class)
    begin
      str= "#{page_class}.new($driver" + (args.length > 0 ? ", \""+ args*"," +"\"" : "") +")"
      #puts str
      # puts "Current url: #{$driver.driver.current_url}"
      eval(str)
    rescue Exception => e
      raise("Undefined page for class #{page_class}, and url #{$driver.driver.current_url} . Exception:#{e.message}")
    end
  else
    # puts "skipped g_page initialization for page #{$driver.driver.current_url}"
    # puts "Current g_page: #{$g_page.class}"
    $g_page
  end
end

Before ('@browserstack_test') do
  ENV['BROWSER_TYPE'] = "browserstack"
end

Before('@saucelabs_test', '@IE') do
  ENV['BROWSER_TYPE'] = "saucelabs"
  ENV['BROWSER_VENDOR'] = "IE"
  ENV['BROWSER_VERSION'] = "10.0"
end

Before('@saucelabs_test', '@FF') do
  ENV['BROWSER_TYPE'] = "saucelabs"
  ENV['BROWSER_VENDOR'] = "FF"
end

Before('@saucelabs_test', '@CHROME') do
  ENV['BROWSER_TYPE'] = "saucelabs"
  ENV['BROWSER_VENDOR'] = "CHROME"
end

at_exit do
  if !$driver.nil?
    $driver.quit
  end
end

# Before ('@SFDC_Functional') do
#
#   $SFDCtestDataReference=YMLUtility.new("Suite_SFDC_Functionality-TestData", '../test_data/SFDC/')
#   $SFDCObjectRepositoryReference=YMLUtility.new("SFDCObjectsConfiguration_DEVQASandBox", '../test_data/SFDC/ObjectRepository/')
#   $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
#
# end
#
# Before ('@Suite_SFDC_Sanity_Level1') do
#   $SFDCtestDataReference=YMLUtility.new("Suite_SFDC_Sanity-TestData", '../test_data/SFDC/')
#   $SFDCObjectRepositoryReference=YMLUtility.new("SFDCObjectsConfiguration_DEVQASandBox", '../test_data/SFDC/ObjectRepository/')
#   $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
#
# end
#
# Before ('@Suite_ROMS_Sanity_Level1') do
#   $ROMStestDataReference=YMLUtility.new("Suite_ROMS_Sanity-TestData", '../test_data/ROMS/')
#   $ROMSObjectRepositoryReference=YMLUtility.new("ROMSObjectsConfiguration", '../test_data/ROMS/ObjectRepository/')
#   $g_page = ROMSBasePage.new($driver, $ROMSObjectRepositoryReference.elements)
#
# end
#
# AfterStep ('@SFDC_Functional') do
#
#   $SFDCtestDataReference=YMLUtility.new("Suite_SFDC_Functionality-TestData", '../test_data/SFDC/')
#   $SFDCObjectRepositoryReference=YMLUtility.new("SFDCObjectsConfiguration_DEVQASandBox", '../test_data/SFDC/ObjectRepository/')
#   $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
#
# end
#
# AfterStep ('@Suite_SFDC_Sanity_Level1') do
#   $SFDCtestDataReference=YMLUtility.new("Suite_SFDC_Sanity-TestData", '../test_data/SFDC/')
#   $SFDCObjectRepositoryReference=YMLUtility.new("SFDCObjectsConfiguration_DEVQASandBox", '../test_data/SFDC/ObjectRepository/')
#   $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
#
# end
#
#
# AfterStep ('@Suite_ROMS_Sanity_Level1') do
#   $ROMStestDataReference=YMLUtility.new("Suite_ROMS_Sanity-TestData", '../test_data/ROMS/')
#   $ROMSObjectRepositoryReference=YMLUtility.new("ROMSObjectsConfiguration", '../test_data/ROMS/ObjectRepository/')
#   $g_page = ROMSBasePage.new($driver, $ROMSObjectRepositoryReference.elements)
#
# end
#
#
# #OTR Before and AfterSteps
# Before ('@Suite_OTRC_Functional') do
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Functionality-TestData", '../test_data/OTR/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# Before ('@Suite_OTRC_Sanity_Level1') do
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Sanity-TestData", '../test_data/OTR/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# Before ('@OTRC_PROD_AUTOMATION_TIER_0') do
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Prod_Sanity-TestData.yml", '../test_data/OTR/OTR_Prod/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRProdObjectsConfiguration", '../test_data/OTR/OTR_Prod/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
#
# AfterStep ('@Suite_OTRC_Functional') do
#
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Functionality-TestData", '../test_data/OTR/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# AfterStep ('@Suite_OTRC_Sanity_Level1') do
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Sanity-TestData", '../test_data/OTR/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# AfterStep ('@OTRC_PROD_AUTOMATION_TIER_0') do
#
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Prod_Sanity-TestData.yml", '../test_data/OTR/OTR_Prod/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRProdObjectsConfiguration", '../test_data/OTR/OTR_Prod/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# #India Team CHARM Before and After steps
# Before ('@Suite_IndiaTeam_CHARM_Functional') do
#   $CHARMtestDataReference=YMLUtility.new("Suite_CHARM_Functionality_TestData", '../test_data/INDIATEAM_CHARM/')
#   $CHARMObjectRepositoryReference=YMLUtility.new("CHARMObjectsConfiguration", '../test_data/INDIATEAM_CHARM/ObjectRepository/')
#   $g_page = IndiaTeam_CHARMBasePage.new($driver, $CHARMObjectRepositoryReference.elements)
# end
#
# AfterStep ('@Suite_IndiaTeam_CHARM_Functional') do
#   $CHARMtestDataReference=YMLUtility.new("Suite_CHARM_Functionality_TestData", '../test_data/INDIATEAM_CHARM/')
#   $CHARMObjectRepositoryReference=YMLUtility.new("CHARMObjectsConfiguration", '../test_data/INDIATEAM_CHARM/ObjectRepository/')
#   $g_page = IndiaTeam_CHARMBasePage.new($driver, $CHARMObjectRepositoryReference.elements)
# end
#
# Before ('@Suite_ROMS_Functional') do
#   $ROMStestDataReference=YMLUtility.new("Suite_ROMS_Functional-TestData", '../test_data/ROMS/')
#   $ROMSObjectRepositoryReference=YMLUtility.new("ROMSObjectsConfiguration", '../test_data/ROMS/ObjectRepository/')
#   $g_page = ROMSBasePage.new($driver, $ROMSObjectRepositoryReference.elements)
# end
#
# AfterStep ('@Suite_ROMS_Functional') do
#   $ROMStestDataReference=YMLUtility.new("Suite_ROMS_Functional-TestData", '../test_data/ROMS/')
#   $ROMSObjectRepositoryReference=YMLUtility.new("ROMSObjectsConfiguration", '../test_data/ROMS/ObjectRepository/')
#   $g_page = ROMSBasePage.new($driver, $ROMSObjectRepositoryReference.elements)
# end
#
# Before '@CHARM-bat-tier-0' do
#   $qc_test_set_prefix = 'CHARM BAT Tier 0'
# end
# Before '@CHARM-bat-tier-1' do
#   $qc_test_set_prefix = 'CHARM BAT Tier 1'
# end
# Before '@CHARM-bat-tier-2' do
#   $qc_test_set_prefix = 'CHARM BAT Tier 2'
# end
# Before '@Web-bat-tier-0' do
#   $qc_test_set_prefix = 'Consumer BAT Tier 0'
# end
# Before '@Web-bat-tier-1' do
#   $qc_test_set_prefix = 'Consumer BAT Tier 1'
# end
# Before '@Web-bat-tier-2' do
#   $qc_test_set_prefix = 'Consumer BAT Tier 2'
# end
# Before '@MobileWeb-bat-tier-0' do
#   $qc_test_set_prefix = 'Mobile Site BAT Tier 0'
# end
# Before '@MobileWeb-bat-tier-1' do
#   $qc_test_set_prefix = 'Mobile Site BAT Tier 1'
# end
# Before '@MobileWeb-bat-tier-2' do
#   $qc_test_set_prefix = 'Mobile Site BAT Tier 2'
# end
#
# def setIndiaTeam_Gpage(app)
#   case app.upcase
#     when "ROMS"
#       $g_page = ROMSBasePage.new($driver, $ROMSObjectRepositoryReference.elements)
#     when "SFDC"
#       $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
#     when "OTRC"
#       $g_page = OTRCBasePage.new($driver, $OTRObjectRepositoryReference.elements)
#     when "INDIA TEAM CHARM"
#       $g_page = IndiaTeam_CHARMBasePage.new($driver, $CHARMObjectRepositoryReference.elements)
#   end
# end
#
#
# Before ('@OTRC_Prod_Automation_Tier_0') do
#
#   $OTRCtestDataReference=YMLUtility.new("OTRC_Prod_Automation_Tier_0-TestData", '../test_data/OTR_Prod/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR_Prod/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# AfterStep ('@OTRC_Prod_Automation_Tier_0') do
#
#   $OTRCtestDataReference=YMLUtility.new("OTRC_Prod_Automation_Tier_0-TestData", '../test_data/OTR_Prod/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR_Prod/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# Before ('@Suite_OTRC_Custom_Groups_Functional') do
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Functionality_CustGroups-TestData", '../test_data/OTR/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
# AfterStep ('@Suite_OTRC_Custom_Groups_Functional') do
#
#   $OTRCtestDataReference=YMLUtility.new("Suite_OTR_Functionality_CustGroups-TestData", '../test_data/OTR/')
#
#   $OTRCObjectRepositoryReference=YMLUtility.new("OTRObjectsConfiguration", '../test_data/OTR/ObjectRepository/')
#   $g_page = OTRCBasePage.new($driver, $OTRCObjectRepositoryReference.elements)
#
# end
#
#
# Before ('@Tier-0_SFDC_Sanity') do
#   $SFDCtestDataReference=YMLUtility.new("Tier-0_Sanity-TestData", '../test_data/SFDC/')
#   $SFDCObjectRepositoryReference=YMLUtility.new("Common_SFDCObjectsConfig", '../test_data/SFDC/ObjectRepository/')
#   $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
# end
#
#
# AfterStep ('@Tier-0_SFDC_Sanity') do
#   $SFDCtestDataReference=YMLUtility.new("Tier-0_Sanity-TestData", '../test_data/SFDC/')
#   $SFDCObjectRepositoryReference=YMLUtility.new("Common_SFDCObjectsConfig", '../test_data/SFDC/ObjectRepository/')
#   $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
# end
#
# Before ('@UMAMI-showcase-1, @UMAMI-showcase-2, @UMAMI-showcase-3, @UMAMI') do
#   $SFDCtestDataReference=YMLUtility.new("umami_salseforce_test_data", "../test_data/OT_#{ENV['TEST_ENVIRONMENT']}/Umami")
#   $SFDCObjectRepositoryReference=YMLUtility.new("Common_SFDCObjectsConfig", '../test_data/SFDC/ObjectRepository/')
#   # $g_page = SFDCBasePage.new($driver, $SFDCObjectRepositoryReference.elements)
#   $umami_salseforce = {}
# end

AfterStep do
  # after each step check js error if using firefox
  if (!$g_page.nil?) && ($g_page.respond_to? :get_js_error_feedback )
     $g_page.get_js_error_feedback()
  end

end

