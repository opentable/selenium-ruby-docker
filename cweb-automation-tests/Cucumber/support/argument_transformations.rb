Transform /auto_(register_user|admin_user|user)@opentable.com/ do |email|
  if (!$_OT_AUTO_TEST_EMAIL.nil?)&&(!$_OT_AUTO_TEST_EMAIL_PWD.nil?) && !($driver.url.include? "otconnect")
    $USER['password'] = $_OT_AUTO_TEST_EMAIL_PWD
    if ((email == "register_user") && (!$_OT_AUTO_REGISTER_TEST_EMAIL.nil?))
      $USER['email'] = $_OT_AUTO_REGISTER_TEST_EMAIL
    elsif ((email == "admin_user") && (!$_OT_AUTO_ADMIN_TEST_EMAIL.nil?))
      $USER['email'] = $_OT_AUTO_ADMIN_TEST_EMAIL
    else
      $USER['email'] = $_OT_AUTO_TEST_EMAIL
    end
  else
    $USER['email'] = email
  end
end


Transform /auto_mobile@opentable.com/ do |email|
  if (!$_OT_AUTO_TEST_EMAIL.nil?) && (!$_OT_AUTO_TEST_EMAIL_PWD.nil?)
    $USER['password'] = $_OT_AUTO_TEST_EMAIL_PWD
    $USER['email'] = $_OT_AUTO_TEST_EMAIL
  else
    $USER['email'] = email
  end
end

Transform /\[[\w ]+\]/ do |str|
  puts "Input string: #{str}"

  # str = str.gsub("[resid_encrypted]", $RESERVATION["resid_encrypted"].to_s)
  # str = str.gsub("[resid]", $RESERVATION["resid"].to_s)
  str = str.gsub("[partial_email]", $USER["email"].to_s.split("@")[0].to_s)
  str = str.gsub("[email]", $USER["email"].to_s)
  str = str.gsub("[fname]", $USER["fname"].to_s)
  str = str.gsub("[lname]", $USER["lname"].to_s)
  str = str.gsub("[phone]", $USER["phone"].to_s)
  str = str.gsub("[password]", $USER["password"].to_s)
  str = str.gsub("[first_name]", $USER["fname"].to_s)
  str = str.gsub("[last_name]", $USER["lname"].to_s)
  str = str.gsub("[rid]", $RESTAURANT["rid"].to_s)
  str = str.gsub("[restaurant_name]", $RESTAURANT["name"].to_s)
  str = str.gsub("[RestaurantName]", $RESTAURANT["name"].to_s)
  str = str.gsub("[date_searched]", $RESERVATION["date_searched"].to_s)
  str = str.gsub("[conf_number]", $RESERVATION["conf_number"].to_s)
  str = str.gsub("[ResID]", $RESERVATION["ResID"].to_s)
  str = str.gsub("[RID2]", $RESTAURANT['RID2'].to_s)
  str = str.gsub("[RID]", $RESTAURANT['RID'].to_s)
  str = str.gsub("[RNAME]", $RESTAURANT['RNAME'].to_s)
  str = str.gsub("[RNAME_PARTIAL]", $RESTAURANT['RNAME'].to_s[0..15] )
  str = str.gsub("[RNAME_NURL]", $RESTAURANT["RNAME_NURL"].to_s)
  str = str.gsub("[RNAME_NURL_SINGLE]", $RESTAURANT["RNAME_NURL_SINGLE"].to_s)
  str = str.gsub("[RNAME2]", $RESTAURANT["RNAME2"].to_s)
  str = str.gsub("[RNAME2_NURL]", $RESTAURANT["RNAME2_NURL"].to_s)
  str = str.gsub("[RNAME2_NURL_SINGLE]", $RESTAURANT["RNAME2_NURL_SINGLE"].to_s)
  str = str.gsub("[RMETRO]", $RESTAURANT["RMETRO"].to_s)
  str = str.gsub("[RMETRO_NURL]", $RESTAURANT["RMETRO_NURL"].to_s)
  str = str.gsub("[gpid]", $RUNTIME_STORAGE["gpid"].to_i.to_s)
  str = str.gsub("[custid]", $RUNTIME_STORAGE["custid"].to_i.to_s)

  if (str.include? "[event36_if_pop]")
    if ($RESERVATION["points"].to_s == "1000" ||$RESERVATION["points"].to_s == "1,000")
      str = str.gsub("[event36_if_pop]", ((str.starts_with? '[event36_if_pop]') ? "event36" : ",event36"))
    else
      str = str.gsub("[event36_if_pop]", "")
    end
  end

  if (str.include? "[any_rid]" or str.include? "[any_rname]" or str.include? "[any_rname_nurl]")
    get_restaurants(RestReservation.new({}).get_available_rest_list, $domain.primary_metro_id)
    str = str.gsub("[any_rid]", $RESTAURANT["RID"])
    str = str.gsub("[any_rname]", $RESTAURANT["RNAME"])
    str = str.gsub("[any_rname_nurl]", $RESTAURANT["RNAME_NURL"].to_s)
  end

  #other entries in $RUNTIME_STORAGE
  str.scan(/\[(.*)\]/).each { |key|
    if ($RUNTIME_STORAGE.has_key? key[0])
      str = str.gsub("[#{key[0]}]", $RUNTIME_STORAGE[key[0]].to_s)
    end
  }
  if (str.match(/\[(.*)\]/))
    warn "Warning! [#{str.scan(/\[(.*)\]/) * "], ["}] is/are not defined in any hash."
  end

  puts "Output string: #{str}"
  str
end

Transform /<[\w ]+>/ do |str|
  warn "Warning! Step argument '#{str}' could be referencing a column that does not exist in current scenario"
  str
end

Transform /.*\(.*\)/ do |stgr|
  if OT_YML_TO_LOAD.nil?
    OT_YML_TO_LOAD=""
    OT_YML_TO_LOAD =YAML.load_file("./test_data/OT_#{$TEST_ENVIRONMENT}/TestData.yml")
  end
  # if there is a match in the pattern then go inside the loop else don't do any tranformation
  if (stgr.match(/\((COM|FRCA|DE|MX|JP|COUK|IE|AU|NL)-(.*?)-(.*?)\)/))
    stgr.scan(/\((COM|FRCA|DE|MX|JP|COUK|IE|AU|NL)-(.*?)-(.*?)\)/).each { |value|
      rest_domain = value[0].to_s
      rest_purpose = value[1].to_s
      rest_attribute = value[2].to_s
      puts "#{rest_domain}"+"#{rest_purpose}"+"#{rest_attribute}"
      if !OT_YML_TO_LOAD["#{rest_domain}"]["#{rest_purpose}"]["#{rest_attribute}"].to_s.eql? ""
        #converting array as a string
        value="(#{value.join("-")})"
        stgr=stgr.gsub("#{value}", OT_YML_TO_LOAD["#{rest_domain}"]["#{rest_purpose}"]["#{rest_attribute}"].to_s)

        #keep empty value
        stgr="" if stgr.eql? "(Empty)"
      end
    }
    stgr
  end
  puts "output str = #{stgr}"
  stgr
end


Transform /\(\s*\[RID\]\s*,/ do |stgr|
    puts "transforming RID used in an 'Insert' statement (ie Insert into mytable values ([RID]...)"
    stgr=stgr.gsub("[RID]", $RESTAURANT['RID'].to_s)
end
