Then /^I should see exact search time selected$/ do
  $g_page.verify_time
end

Then /^I should see confirmation message$/ do
  $g_page.verify_msg
end

Then /^I set conciergeadd page for foreign guests when I am in Japan$/ do
  $g_page = ConciergeAdd.new($driver, $domain.www_domain_selector)
end