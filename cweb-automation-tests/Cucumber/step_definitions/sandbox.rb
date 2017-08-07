Then /^I verify number of seated reservations matches number of row in Reservation Details table$/ do
  number = $g_page.get_number_of_reservations
  step %{I should see "#{number}" rows in "Reservation Details Table" table}
end

####3 Added by Aparna for Add Article
When /^I select radio button with value "([^"]*)"$/ do |value|
  $driver.radio(:value, value).set
end

When /^I see drop down Select Publisher is not active$/ do
  if !($driver.select_list(:name, "pubid").selected? "No Publisher (Press Release)")
    raise Exception, "Select Publisher drop down is active"
  end
end