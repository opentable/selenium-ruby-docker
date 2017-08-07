# Encoding: utf-8
And /^I get the number of tables from the results title$/ do
  $g_page = Opentables_newdesign.new($driver)
  $RUNTIME_STORAGE['results_tables'] = $g_page.get_results_table_count
  puts "Results_tables=>#{$RUNTIME_STORAGE['results_tables']}"
end

Then /^I check search filter checkbox "([^"]*)"$/ do | search_filter_name |
  search_filter_name.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  $g_page = Opentables_newdesign.new($driver)
  $g_page.set_checkbox(search_filter_name)
end

Then /^I uncheck search filter checkbox "([^"]*)"$/ do | search_filter_name |
  search_filter_name.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  $g_page = Opentables_newdesign.new($driver)
  $g_page.uncheck_checkbox(search_filter_name)
  $RUNTIME_STORAGE['results_tables'] = $g_page.get_results_table_count
  puts "Results_tables=>#{$RUNTIME_STORAGE['results_tables']}"
end

Then /^I should see the number of tables decreased$/ do
  $g_page = Opentables_newdesign.new($driver)
  $g_page.compare_table_results()
end