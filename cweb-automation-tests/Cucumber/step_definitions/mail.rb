# -*- coding: utf-8 -*-
# encoding: utf-8

Then /^I check email for "([^"]*)"$/ do |type|
     if ["prod", "preprod","stage", "staging"].include?(ENV['TEST_ENVIRONMENT'].to_s.downcase)
      check_email_via_charm(type)
     else
       check_email_via_db(type)
     end
end

def check_email_via_charm(type)
  subject=get_email_subject_to_find_via_charm(type)
  body_text =email_body_text["#{type}"]
  email =get_email_using_charm_tool(subject, body_text)
  if email.nil?
    raise Exception, "email with subject #{subject} not found for text #{body_text}"
  end
  $RESERVATION['email'] = email
end

def check_email_via_db(type)
  subject = get_email_subject_to_find(type, $domain.language_id)
  puts "Email subject: #{subject}"
  body_text =get_email_body_text_to_find(type)
  step %{I check email with subject "#{subject}" and body text "#{body_text}"}
end

def pull_emails_fromTMS(email)
  url = "http://10.21.6.124/v1/artifacts/?artifactToContains=#{email}"
  total_response = ""
  total_subject = ""
  total_body = ""
  http_client = OTHttpClient.new()
  response = http_client.get(url)
  obj = JSON.parse(response.body)["matches"]
  obj.each do |child|
    child_response = http_client.get(child["href"])
    body =  JSON.parse(child_response.body)["body"]
    subject = JSON.parse(child_response.body)["subject"]
    #see http://stackoverflow.com/questions/2982677/ruby-1-9-invalid-byte-sequence-in-utf-8 for details on below
    total_subject <<  subject.to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    total_body << body.to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
  end
  total_response << total_subject
  total_response << total_body
  $RUNTIME_STORAGE["TMS_subject"] = total_subject
  $RUNTIME_STORAGE["TMS_body"] = total_body
  $RUNTIME_STORAGE["TMS_total_response"] = total_response
end

def is_email_in_TMSBody(email_address, body_text = "")
  pull_emails_fromTMS(email_address)
  email_found = false
  email = $RUNTIME_STORAGE["TMS_body"].to_s.gsub('amp;', '')
  if email.include? body_text
    email_found = true
  end
  return email_found
end

Then /^I should not receive no-show email$/ do
  @tms = TMS.new("transaction-messaging.services.opentable.com")
  s_noshow_email_subject = @tms.get_email_subject_to_find_from_db("NS - Standard (Registered)")
  is_email_in_TMSBody($MAIL_USER,)
  if $RUNTIME_STORAGE["TMS_subject"].include? s_noshow_email_subject
    raise Exception, "No-show email was found when not expected"
  end
end

Then /^I click link in email to reset password$/ do
  email = $RESERVATION['email']

  start = email.index(/https/)
  email = email[start..email.length]
  link_end= email.index("\n")
  link = email[0..link_end]
  $driver.goto(link)
end