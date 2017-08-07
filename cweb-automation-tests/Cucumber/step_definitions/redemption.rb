Then /^I select "([^"]*)" points from the redemption value$/ do |redeem_points|
  RedemptionGiftCard.new($driver).select_points(redeem_points)
end

Then /^I click "([^"]*)" in the Redemption page$/ do |friendly_name|
  RedemptionGiftCard.new($driver).click(friendly_name)
end

Then /^I should see points changed by "([^"]*)" amount in the Redemption page$/ do | redeem_points |
  RedemptionGiftCard.new($driver).check_redeem_value(redeem_points)
end

Then /^I should see points changed by "([^"]*)" amount in the Redemption Confirm page from "([^"]*)"$/ do |redeem_points, add_points|
  RedemptionConfirm.new($driver).check_remaining_points(redeem_points, add_points)
end

And /^I check the email address for the login user$/ do
  RedemptionConfirm.new($driver).check_email_address()
end

Then /^I click "([^"]*)" in the Redemption confirm page$/ do |friendly_name|
  RedemptionConfirm.new($driver).click(friendly_name)
end

And /^I have successfully redeemed my points the Redemption Complete page with banner "([^"]*)"$/ do |success_claims_msg |
  RedemptionComplete.new($driver).check_success_banner(success_claims_msg)
end