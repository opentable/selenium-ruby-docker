Then /^I go to start page with query string "([^"]*)"$/ do |query_str|

  if query_str.scan(/([a-z]+=\d+)/).length != 0
    h_query = Hash.new
    query_str.scan(/([a-z]+=\d+)/).each { |item| h_query[item[0].to_s.split('=')[0]] = item[0].to_s.split('=')[1] }
    $metro_id = h_query['m']
    $macro_id = h_query['mn']
  elsif query_str.is_a? Numeric
    $metro_id = query_str
  else
    raise ArgumentError, "invalid query string! #{query_str}"
  end

  $g_page = Start.new($driver, $domain.www_domain_selector, $metro_id)
  $g_page.domain = $domain.www_domain_selector
  $g_page.go_to()
end
