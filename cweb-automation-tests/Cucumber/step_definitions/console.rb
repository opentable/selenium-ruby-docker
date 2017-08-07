And /^I set test user first name "([^"]*)"$/ do |fname|
  $USER['fname'] = fname
end

And /^I set test user last name "([^"]*)"$/ do |lname|
  $USER['lname'] = lname
end
