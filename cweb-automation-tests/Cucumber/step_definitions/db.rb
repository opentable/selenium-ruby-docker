#
#Put DB functions here
#
# rename to $g_result_set
#$result_set = nil

# @ToDo add verification here to me sure connection works
Then /^I connect to database "([^"]*)" as "([^"]*)"$/ do |db_address, username_pwd|
  if !(ENV['TEST_ENVIRONMENT'].downcase.eql? "prod")
    case db_address.to_s.strip
      when "webdb-na-primary"
        db_name = "webdb"
      when "webdb-asia-primary"
        db_name = "webdb_asia"
      when "weblogdb-asia-primary"
        db_name = "weblogdb_asia"
      when "webdb-eu-primary"
        db_name = "webdb_eu"
      when "webdb-na-primary-dev"
        db_name = "webdb"
      when "webdb-na-primary-qa"
        db_name = "webdb"
      when "weblogdb-na-primary"
        db_name = "weblogdb"
      when "weblogdb-na-primary-dev"
        db_name = "weblogdb"
      when "weblogdb-na-primary-qa"
        db_name = "weblogdb"
      when "Auto-US-ERB10", "Auto-EU-CC-UK-1", "Auto-JP-FRN-ERB", "Auto-JP-ERB10", "VM-Production-US1", "Auto-Rest-10304", "VM-Stage-US-3"
        db_name = "opentable"
      when "sfr12devdb1"
        db_name = "PerfTests"
      else
        raise Exception, "invalid input. expected webdb-na-primary, etc."
    end

  # @ToDo encrypt passwords, so that feature files do not have password
    $domain.db_server_address = db_address
    $db_user_name, $db_password = username_pwd.split('/')[0].strip, username_pwd.split('/')[1].strip
    if ($domain.db_server_address == "sfr12devdb1" and $db_user_name == "sa")
      $db_password = "Iblyd2"
    end
    $g_db = OTDBAction.new($domain.db_server_address, db_name, $db_user_name, $db_password)
  end
end

Then /^I execute Update SQL "([^"]*)"$/ do |sql|
  $g_db.runquery_no_result_set(sql)
end

Then /^I verify Attribution "([^"]*)" equal to "([^"]*)"$/ do |columnname, value|
  if !(ENV['TEST_ENVIRONMENT'].downcase.eql? "prod")
    if (!$RESTAURANT["RID"].nil? and !$RESERVATION["conf_number"].nil?)
      sql = "select " + columnname + " from ReservationVW where rid =#{$RESTAURANT["RID"]} and confnumber =#{$RESERVATION["conf_number"]}"
    else
      sql = "select " + columnname + " from ReservationVW where resid =#{$RESERVATION["resid"]} "
    end
    puts sql
    $result_set = $g_db.runquery_return_resultset(sql)
    assert_equal($result_set[0][0].to_s.strip, value.to_s.strip, "SQL output compare failed. Searched for \"" + value.to_s.strip + "\", found \"" + $result_set[0][0].to_s.strip + "\"")
  else
    @reservation ||= ReservationServiceV2.new()
    @response = @reservation.reso_retrieve('all')
    if columnname.downcase.eql? "respoints"
      value = 0   ## Points should be 0 in Production for test restaurants
      puts "Excepted Points: #{value} Actual is set to #{@response['data']['points']}"
      raise Exception, "Excepted Points: #{value} Actual is set to #{@response['data']['points']}" if !@response['data']['points'].eql? value.to_i
    elsif columnname.downcase.eql? "primarysourcetype"
      if value.downcase.eql? "restref"
        isRestRef=true
        puts "Excepted Restref: #{isRestRef} Actual is set to #{@response['data']['isRestRef']}"
        raise Exception, "Excepted Restref: #{isRestRef} Actual is set to #{@response['data']['isRestRef']}" if !@response['data']['isRestRef'].eql? isRestRef
      end
    elsif columnname.downcase.eql? "referrerid"
      puts "Excepted ReferrerID: #{value} Actual is set to #{@response['data']['referrerId']}"
      raise Exception, "Excepted ReferrerID: #{value} Actual is set to #{@response['data']['referrerId']}" if !@response['data']['referrerId'].eql? value.to_i
    end
  end
end

When /^I update the reservation status to (seated|NS) and move the reservation to past date$/ do |rstate|
  if rstate.downcase.include? "seated"
    rstate_ID = 2
  else
    rstate_ID = 4
  end
  sql = "UPDATE Reservation set ShiftDate=ShiftDate-5,DateMade=DateMade-5,RStateID=#{rstate_ID}  where ResID=#{$RESERVATION["resid"]}"
  puts sql
  $g_db.runquery_no_result_set(sql)
end
