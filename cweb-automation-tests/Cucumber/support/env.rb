require 'rubygems'
require "bundler/setup"
require 'net/imap'
#require 'soap/wsdldriver'
require 'uri'
#require 'Resolv'
require 'ipaddr'
require 'socket'
require 'mongo'
require 'selenium/webdriver'
require 'test/unit/assertions'
require 'active_support/time'

include Mongo

Bundler.require(:default)


#The newer webdrivers do not like worldly declarations
World(Test::Unit::Assertions)  ##This definition works for db.rb line 60
##To-do...Tired various definitions to get assert to work in AvailabilityService_Search.rb - verify_echo_back_in_QualifiedSearch_response method to work lines 275 - 280
#World(Test::Unit::TestCase)
# World(Minitest::Test)
# require 'minitest/autorun'
#
# class MinitestWorld < MiniTest::Test
#   attr_accessor :assertions
#
#   def initialize
#     self.assertions = 0
#   end
# end
#
# World do
#   MinitestWorld.new
# end


# add library paths to Ruby search path


#$: << File.join(File.expand_path(File.dirname(__FILE__)), '/step_definitions')

Dir["*"].each { |path| $: << File.expand_path(path.to_s) }
Dir["step_definitions/**/*.rb"].each { |page| load page.to_s }

require_relative '../Pages/Common/open_table_site'
include OpenTableSite::PageAccessors
require_relative "../Pages/Common/WebBasePage"
require_relative "../Pages/Common/ConsumerBasePage"
require_relative "../Pages/Common/CHARMBasePage"
require_relative "../Pages/Common/OTServiceBase"


Dir["Pages/**/*.rb"].each { |file| load file }
Dir["Utilities/**/*.rb"].each { |file| load file }
Dir["Translations/**/*.rb"].each { |file| load file }
Dir["lib/**/*.rb"].each { |file| load file }

require 'win32/screenshot' if Kernel.is_windows?
require 'win32ole' if Kernel.is_windows?

#Global Test Environment

if ENV['TEST_ENVIRONMENT'].nil?
  $TEST_ENVIRONMENT = "PreProd"
  #This global variable is used in TMS so let's set it
  ENV['TEST_ENVIRONMENT'] = "PreProd"
else
  $TEST_ENVIRONMENT = ENV['TEST_ENVIRONMENT']
end

OT_YML_TO_LOAD= YAML.load_file("./test_data/OT_#{$TEST_ENVIRONMENT}/TestData.yml")

# close browser on start
BrowserUtilities.close_all_browsers

# delete old error screenshots on start
Dir["*.png"].each { |f| File.delete(f) }

#Checking if host file is pointing to Production
#Do Not Comment this out

if !(ENV['TEST_ENVIRONMENT'].downcase == "prod")
  domains_pointing_prod_hash_values = Utilities.domains_pointing_prod_env
  if !domains_pointing_prod_hash_values.nil?
     Cucumber.wants_to_quit = true
     raise Exception, "Aborting Cucumber Execution due to ENV(s) Potentially Pointing to Production. \n Correct your Host File entries for following \n  #{domains_pointing_prod_hash_values}"
  end
end
# globals
# browser settings
$driver = nil
$default_browser = "firefox"
$default_browser = "chrome"
$browser_type = $default_browser
$charm_default_browser = "firefox"

# Responsive Browser Settings.  Note these settings are for the window.innerWidth ie does not include browser scrollbar
$xlarge_lower_width = 1441
$xlarge_upper_width = 1920
$large_lower_width = 1025
$large_upper_width = 1440
$medium_lower_width = 641
$medium_upper_width = 1024

# QC reporting
$current_feature_file = nil
$scenario_index_in_feature = nil

if !ENV['BROWSER_TYPE'].nil?
  $browser_type = ENV['BROWSER_TYPE']
end

$g_page = nil
# runtime store
$RUNTIME_STORAGE = {}
$RUNTIME_STORAGE['WaitListDiner'] = 0

# Test restaurant
$RESTAURANT = {}

# Reservation object
$RESERVATION = {}


#database settings
$db_user_name = "automation"
$db_password = "aut0m8er"


# Mail server
$MAIL_CHILKAT_LC = "GRNMNTIMAPMAILQ_LnaxzeCm6I3E"
$MAIL_SERVER_ADDRESS = "qa.otmail.com"
$MAIL_USER = "auto_user"
$MAIL_PWD = "opentable"

$qc_description = "No description available"

$browser_language = 'en-US'
# run code after tests complete running
at_exit do
  # clean up, close browsers
  BrowserUtilities.close_all_browsers
end


#set CA cert file by monkey patching Net::HTTP.
#only required for windows.
require 'net/https'
if Kernel.is_windows?
  class Net::HTTP
    alias_method :old_initialize, :initialize

    def initialize(*args)
      old_initialize(*args)
      @verify_mode = OpenSSL::SSL::VERIFY_PEER
      @ca_file = File.join(File.dirname(__FILE__), '/../test_data/cacert.pem')
      ENV['SSL_CERT_FILE'] = File.join(File.dirname(__FILE__), '/../test_data/cacert.pem')
    end
  end
end

Utilities.add_self_to_partner_ips

