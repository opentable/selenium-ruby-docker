Given /^I setup test restaurant "([^"]*)"$/ do |rid|
  #--- access db and change MinOnlineOptionID as 2 ---
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  @search_obj.call_AvailService_recache()
end

Given /^I setup test restaurant "([^"]*)" Min PartySize value "([^"]*)"$/ do |rid, minPS|
  #--- access db and change MinOnlineOptionID as 2 ---
  $domain = Domain.new('.com')
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).change_restaurant_data('MinPartySize', minPS)
  @search_obj.call_AvailService_recache()
end

And /^I recache AvailService$/ do
  @search_obj.call_AvailService_recache()
end

When /^I call Search API using PS "([^"]*)"$/ do |search_ps|
  @search_obj.set_default_data_single_search()
  @search_obj.change_ps(search_ps)
  @search_obj.call_Qualified_Search()
end

When /^I call Search API using default values$/ do
  @search_obj.set_default_data_single_search()
  @search_obj.call_Qualified_Search()
end

When /^I call Search API passing searchdate "([^"]*)" days forward$/ do |fwd_days|
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(fwd_days)
  @search_obj.call_Qualified_Search()
end

When /^I call Search API passing searchdate "([^"]*)" days forward, search_days "([^"]*)"$/ do |fwd_days, search_multi_days|
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(fwd_days)
  @search_obj.change_forward_days(search_multi_days)
  @search_obj.call_Qualified_Search()
end

When /^I call Search API for restaurant "([^"]*)" passing searchdate "([^"]*)" days forward, Time "([^"]*)"$/ do |rid, searchStart, time|
  @search_obj.set_default_data_single_search(rid)
  @search_obj.change_start_date_forward(searchStart)
  @search_obj.change_search_time(time)
  @search_obj.call_Qualified_Search()
end

When /^I call Search API for restaurant "([^"]*)" passing searchdate "([^"]*)" days forward, Time "([^"]*)", PartySize "([^"]*)"$/ do |rid, searchStart, time, ps|
  @search_obj.set_default_data_single_search(rid)
  @search_obj.change_start_date_forward(searchStart)
  @search_obj.change_search_time(time)
  @search_obj.change_ps(ps)
  @search_obj.call_Qualified_Search()
end

When /^I call Search API for exact time only for restaurant "([^"]*)" passing searchdate "([^"]*)" days forward, Time "([^"]*)", PartySize "([^"]*)"$/ do |rid, searchStart, time, ps|
  @search_obj.set_default_data_single_search(rid)
  @search_obj.change_start_date_forward(searchStart)
  @search_obj.change_search_time(time)
  @search_obj.change_ps(ps)
  @search_obj.change_backward_mins(0)
  @search_obj.change_fwd_mins(0)
  @search_obj.call_Qualified_Search()
end

Then /^I verify search brings No Availability and NoAvailability Reason as "([^"]*)" on search date$/ do |expected_noAvail_reason|
  avail_array = @search_obj.get_single_search_single_day_Availability()
  assert_equal(avail_array.length, 0)
  no_times_reasons = @search_obj.get_single_search_single_day_no_times_reasons()
  assert_equal(no_times_reasons[0], expected_noAvail_reason)
end

Then /^I verify search brings No Availability on first day but brings availability all other days$/ do
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"].each { |day_avail|
    day = day_avail["DayOffset"].to_i
    results = day_avail["RIDSet"][0]["Results"]
    if (day == 0)
      assert(results.length == 0)
    else
      assert(results.length > 0)
    end
  }
end

Then /^I verify search brings No Availability on blocked day "([^"]*)" relative to start day "([^"]*)" but brings availability all other days$/ do |blockedStart, searchStart|
  blocked_offset = blockedStart.to_i - searchStart.to_i
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"].each { |day_avail|
    day = day_avail["DayOffset"].to_i
    results = day_avail["RIDSet"][0]["Results"]
    if (day == blocked_offset)
      assert(results.length == 0)
    else
      assert(results.length > 0)
    end
  }
end

Then /^I verify search brings (Availability|No-Availability)$/ do |avail_expected|
  avail_array = @search_obj.get_single_search_single_day_Availability()
  puts avail_array.length
  if (avail_expected == "Availability")
    assert(avail_array.length > 0, "search should bring availability but it returns No availability")
  else
    assert(avail_array.length == 0, "search should not bring availability but it returns availability")
  end
end

Given /^I setup test rid "([^"]*)" for search$/ do |rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
end

Given /^I setup test restaurant "([^"]*)" with Restaurant status as "([^"]*)"$/ do |rid, rstate|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).change_restaurant_data('RestStateID', rstate)
  @search_obj.call_AvailService_recache()
end


Given /^I setup test restaurant "([^"]*)" as Active but non Reachable$/ do |rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).change_to_active_but_not_reachable()
  @search_obj.call_AvailService_recache()
end

Given /^I setup test restaurant "([^"]*)" Max PartySize value "([^"]*)"$/ do |rid, max_ps|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).change_restaurant_data('MaxPartySize', max_ps)
  @search_obj.call_AvailService_recache()
end

Given /^I block a day for "([^"]*)" days from today for test restaurant "([^"]*)"$/ do |fwd_days, rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).add_blocked_day(rid, fwd_days)
  @search_obj.call_AvailService_recache()
end

Given /^I unblock all block days for test restaurant "([^"]*)"$/ do |rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).unblock_all_days(rid)
  @search_obj.call_AvailService_recache()
end

Given /^I setup test restaurant "([^"]*)" with AdvanceBooking limit "([^"]*)"$/ do |rid, max_advance_option_id|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).change_restaurant_data('AdvanceBookingOption', max_advance_option_id)
  @search_obj.call_AvailService_recache()
end

Given /^I setup test rid "([^"]*)" same day cutoff as (PAST|FUTURE) local time for dinner shift$/ do |rid, cutoff_time|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  if (cutoff_time == "PAST")
    #cutoff_time_delta = "-30"
    cutoff_time = "00:00" #--- 12:00 AM limit
  else
    #cutoff_time_delta = "+30"
    cutoff_time = "23:45" #--- 11:45 PM limit
  end
  #cutoff_time = cutoff_time_delta.to_i.minutes.from_now
  #cutoff_time = cutoff_time.strftime("%H:%M")
  Restaurant.new(rid, $domain).set_same_day_cutoff(rid, cutoff_time)
  @search_obj.call_AvailService_recache()
end

Given /^I remove same day cutoff restriction for test rid "([^"]*)"$/ do |rid|
  $domain = Domain.new(".com")
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).remove_same_day_cutoff(rid)
  @search_obj.call_AvailService_recache()
end

Given /^I setup test rid "([^"]*)" days cutoff limit "([^"]*)" days$/ do |rid, cut_off_days|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).set_early_cutoff(rid, cut_off_days)
  @search_obj.call_AvailService_recache()
end

Given /^I set test restaurant "([^"]*)" Credit card required Min Party Size "([^"]*)" limit$/ do |rid, cc_PartySize_limit|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).set_credit_card_party_size_threshold(rid, cc_PartySize_limit)
  @search_obj.call_AvailService_recache()
end

Then /^I verify search brings Availability with CreditCardRequired flag "([^"]*)"$/ do |expectedCCFlag|
  # for a single-day, single-RID search, all the results have the expected CC flag
  expectedCCFlag = expectedCCFlag.downcase
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"][0]["RIDSet"][0]["Results"].each { |result|
    ccFlag = result["CreditCardRequired"].to_s.downcase
    assert(ccFlag == expectedCCFlag)
  }
end

Given /^I set CC day for "([^"]*)" days from today for test restaurant "([^"]*)"$/ do |cc_day_offset, rid|
  $domain = Domain.new(".com")
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).delete_cc_days(rid)
  Restaurant.new(rid, $domain).set_cc_day(rid, cc_day_offset)
  @search_obj.call_AvailService_recache()
end

When /^I call Search API for search day "([^"]*)" days from today$/ do |fwd_days|
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(fwd_days)
  @search_obj.call_Qualified_Search()
end

Given /^I set test "([^"]*)" CC day for "([^"]*)" days ahead time window "([^"]*)", "([^"]*)" for PartySize above "([^"]*)"$/ do |rid, ccDateOffset, cc_start_time, cc_end_time, cc_ps|
  $domain = Domain.new(".com")
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).delete_cc_days(rid)
  Restaurant.new(rid, $domain).set_cc_day_time_ps(rid, ccDateOffset, cc_start_time, cc_end_time, cc_ps)
  @search_obj.call_AvailService_recache()
end

When /^I call Search API for searchdate "([^"]*)" days forward, Time "([^"]*)", partsize "([^"]*)"$/ do |search_day_offset, search_time, search_ps|
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(search_day_offset)
  @search_obj.change_search_time(search_time)
  @search_obj.change_ps(search_ps)
  @search_obj.call_Qualified_Search()
end

Then /^I verify search brings Availability with CreditCardRequired flag "([^"]*)" for time "([^"]*)" relative to exact time "([^"]*)"$/ do |expectedCCFlag, avail_time, exact_time|
  # single-day, single-rid search with multiple results.
  # verify that the avail_time is present in the results and has the expected CC flag
  expectedCCFlag = expectedCCFlag.downcase
  availTimeFound = false
  avail_time = "2000-01-01T#{avail_time}"
  avail_time = avail_time.to_time
  exact_time = "2000-01-01T#{exact_time}"
  exact_time = exact_time.to_time
  checkedOffsetMinutes = ((avail_time - exact_time)/60).to_i
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"][0]["RIDSet"][0]["Results"].each { |result|
    if (result["TimeOffsetMinutes"] == checkedOffsetMinutes)
      ccFlag = result["CreditCardRequired"].to_s.downcase
      assert(ccFlag == expectedCCFlag)
      availTimeFound = true
    end
  }
  assert (availTimeFound)
end

Given /^I use test restaurant "([^"]*)"$/ do |rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  #--- remove restaurant association with any promo --
  Restaurant.new(rid, $domain).remove_restaurant_link_to_all_promos(rid)
  #--- remove if any same day cutoff exist ---
  Restaurant.new(rid, $domain).remove_same_day_cutoff(rid)
  @search_obj.call_AvailService_recache()
end

Given /^I cleared promo and same day cutoff and set advanced reservation to one year on the test restaurant "([^"]*)"$/ do |rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  #--- remove restaurant association with any promo --
  restaurant = Restaurant.new(rid, $domain)
  restaurant.remove_restaurant_link_to_all_promos(rid)
  #--- remove if any same day cutoff exist ---
  restaurant.remove_same_day_cutoff(rid)
  #-- update the advanced booking to one year.  The ID for one year is '6'
  restaurant.change_restaurant_data('AdvanceBookingOption', '6')
  @search_obj.call_AvailService_recache()
end

Then /^I verify PointsType "([^"]*)", PointsValue "([^"]*)" for time slot "([^"]*)"$/ do |point_type, point_value, search_time|
  check_date = @search_obj.postdata["LocalStartDate"]
  rid = @search_obj.rid
  avail_time_data = @search_obj.get_Availability_data_for_date_time(rid, check_date, search_time)
  puts avail_time_data
  assert_equal(true, avail_time_data["time_available"])
  assert_equal(point_type, avail_time_data["PointsType"])
  assert_equal(point_value.to_i, avail_time_data["PointsValue"])
end

Given /^I Add suppress POP date "([^"]*)" days from today for Test restaurant "([^"]*)"$/ do |suppressDay_offset, rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['suppressDay_offset'] = suppressDay_offset
  Restaurant.new(rid, $domain).createPOPSuppressDay(suppressDay_offset)
  @search_obj = Search.new(rid, $domain)
  #--- remove restaurant association with any promo --
  Restaurant.new(rid, $domain).remove_restaurant_link_to_all_promos(rid)
  #--- remove if any same day cutoff exist ---
  Restaurant.new(rid, $domain).remove_same_day_cutoff(rid)
  @search_obj.call_AvailService_recache()
end

Given /^I remove suppress POP date "([^"]*)" days from today for Test restaurant "([^"]*)"$/ do |suppressDay_offset, rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['suppressDay_offset'] = suppressDay_offset
  Restaurant.new(rid, $domain).removePOPSuppressday(suppressDay_offset)
  @search_obj = Search.new(rid, $domain)
  #--- remove restaurant association with any promo --
  Restaurant.new(rid, $domain).remove_restaurant_link_to_all_promos(rid)
  #--- remove if any same day cutoff exist ---
  Restaurant.new(rid, $domain).remove_same_day_cutoff(rid)
  @search_obj.call_AvailService_recache()
end

def set_search_offset_based_on_holiday (day_offset)
  holiDay_Date = DateTime.now + day_offset.to_i
  holiDay_Date = holiDay_Date.strftime("%Y-%m-%d")
  $RUNTIME_STORAGE['search_day_offset'] = day_offset
  sql = "select DateID from HolidaySchedule where HolidayDate = '#{holiDay_Date}' and countryid in ('US', 'All')"
  g_db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  unless g_db.runquery_return_resultset(sql).empty?
    $RUNTIME_STORAGE['search_day_offset'] = day_offset.to_i + 1
  end
end
def set_holiday (holiDay_offset, rid)
  @search_obj = Search.new(rid, $domain)
  $RUNTIME_STORAGE['search_rid'] = rid
  set_search_offset_based_on_holiday(holiDay_offset)
  holiDay_Date = DateTime.now + $RUNTIME_STORAGE['search_day_offset'].to_i
  holiDay_Date = holiDay_Date.strftime("%Y-%m-%d")
  suppress_POP = 1
  $RUNTIME_STORAGE['holiday_name'] = "Availability Test Holiday"
  g_db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  sql = "select HolidayId from HolidaysLocal where HolidayName = '#{$RUNTIME_STORAGE['holiday_name']}'"
  result_set = g_db.runquery_return_resultset(sql)
  if (result_set.length == 0)
    Restaurant.new(rid, $domain).createHoliday(holiDay_Date, $RUNTIME_STORAGE['holiday_name'], suppress_POP)
  end
end


Given /^I Add a POP Suppress holiday for date "([^"]*)" days from today for Test restaurant "([^"]*)"$/ do |holiDay_offset, rid|
  set_holiday(holiDay_offset, rid)
  @search_obj.call_AvailService_recache()
end

def delete_holiday (rid)
  @search_obj = Search.new(rid, $domain)
  g_db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['holiday_name'] = "Availability Test Holiday"
  sql = "select h.holidayID, HS.Holidaydate from HolidaysLocal H
inner join HolidaySchedule HS
on H.HolidayID = HS.HolidayID
where H.HolidayName = '#{$RUNTIME_STORAGE['holiday_name']}'"
  results = g_db.runquery_return_resultset(sql)
  unless results.empty?
    h_date = g_db.runquery_return_resultset(sql)[0][1]
    $RUNTIME_STORAGE['search_day_offset'] = (h_date.to_date - DateTime.strptime(DateTime.now.to_s, "%Y-%m-%d")).to_i
    Restaurant.new(rid, $domain).removeHoliday(results[0][0])
  end

end
Given /^I Remove POP Suppress holiday for date "([^"]*)" days from today for Test restaurant "([^"]*)"$/ do |holiDay_offset, rid|
  delete_holiday(rid)
  @search_obj.call_AvailService_recache()
end

Given /^I (Add|Remove) test restaurant "([^"]*)" with a Active( NON)? POP Suppress Promo "([^"]*)"$/ do |function, rid, pop_suppress_no, pid|
  promo_active = 1
  pop_suppress = 1
  if (pop_suppress_no)
    pop_suppress = 0
  end
  rest_obj = Restaurant.new(rid, $domain)
  rest_obj.change_promo_data(pid, promo_active, pop_suppress)
  rest_add = 0
  if (function == 'Add')
    rest_add = 1
  end
  rest_obj.add_remove_restaurant_to_promo(rid, pid, rest_add)
  @search_obj = Search.new(rid, $domain)
  @search_obj.call_AvailService_recache()
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['pid'] = pid
end

When /^I call search API using search day "([^"]*)" days from today, search time "([^"]*)" minutes from now$/ do |searchStartDayOffset, searchTimeOffsetMinutes|
  @search_obj.set_default_data_single_search()
  search_date = DateTime.now + searchStartDayOffset.to_i
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  searchTime = searchTimeOffsetMinutes.to_i.minutes.from_now
  searchTime = searchTime.strftime("%H:%M")
  @search_obj.change_search_time(searchTime)
  @search_obj.call_Qualified_Search()
end

When /^I call search API using search day "([^"]*)" days from today, search time "([^"]*)", AllowPop "([^"]*)"$/ do |search_day_offset, search_time, allowPOP|
  @search_obj.set_default_data_single_search()
  search_date = DateTime.now + search_day_offset.to_i
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(search_time)
  if !(allowPOP.empty?)
    @search_obj.change_allow_pop(allowPOP)
  end
  @search_obj.call_Qualified_Search()
end

When /^I call search API using search day "([^"]*)" days from today, search time "([^"]*)"$/ do |search_day_offset, search_time|
  @search_obj.set_default_data_single_search()
  search_date = DateTime.now + search_day_offset.to_i
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(search_time)
  @search_obj.call_Qualified_Search()
end

Given /^I remove same-Day POP schedule for RID "([^"]*)"$/ do |rid|
  @search_obj = Search.new(rid, $domain)
  Restaurant.new(rid, $domain).remove_same_day_pop_threshhold(rid)
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj.call_AvailService_recache()
end

Given /^I add same-Day POP schedule for RID "([^"]*)", ThresholdTime as (PAST|FUTURE) time, for DIP StartTime "([^"]*)", EndTime "([^"]*)"$/ do |rid, threashhold_time_flag, pop_start_time, pop_end_time|
  @search_obj = Search.new(rid, $domain)
  $RUNTIME_STORAGE['search_rid'] = rid
  if (threashhold_time_flag == "PAST")
    pop_threshHoldTime = "00:15"
  else
    pop_threshHoldTime = "23:45"
  end
  Restaurant.new(rid, $domain).add_same_day_pop_threshhold(rid, pop_threshHoldTime, pop_start_time, pop_end_time)
  Restaurant.new(rid, $domain).remove_restaurant_link_to_all_promos(rid)
  Restaurant.new(rid, $domain).remove_same_day_cutoff(rid)
  @search_obj.call_AvailService_recache()
end


When /^I call Search API passing searchdate "([^"]*)" days forward, search_days "([^"]*)", search time "([^"]*)"$/ do |search_day_offset, search_multi_days, search_time|
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(search_day_offset)
  @search_obj.change_forward_days(search_multi_days)
  @search_obj.change_search_time(search_time)
  @search_obj.change_allow_pop('true')
  @search_obj.call_Qualified_Search()
end

Given /^I Add test restaurant "([^"]*)" with a Active POP Suppress Promo "([^"]*)" that expires in "([^"]*)" days forward$/ do |rid, pid, pop_expire_days_offset|
  promo_active = 1
  pop_suppress = 1
  expiry_date = DateTime.now + pop_expire_days_offset.to_i
  expiry_date = expiry_date.strftime("%Y-%m-%d 00:00:00.000")
  rest_obj = Restaurant.new(rid, $domain)
  rest_obj.change_promo_data(pid, promo_active, pop_suppress, expiry_date)
  rest_add = 1
  rest_obj.add_remove_restaurant_to_promo(rid, pid, rest_add)
  @search_obj = Search.new(rid, $domain)
  @search_obj.call_AvailService_recache()
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['pid'] = pid
end

Then /^I verify search brings No POP time for next "([^"]*)" days and shows POP times after that for search time "([^"]*)"$/ do |expiry_days_from_today, s_time|
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"].each { |day_avail|
    day = day_avail["DayOffset"].to_i
    check_date = (DateTime.now + day).strftime("%Y-%m-%d")
    avail_time_data = @search_obj.get_Availability_data_for_date_time($RUNTIME_STORAGE['search_rid'], check_date, s_time)
    if (day <= expiry_days_from_today.to_i)
      assert(avail_time_data['PointsType'] == 'Standard')
      assert(avail_time_data['PointsValue'] == 100)
    else
      assert(avail_time_data['PointsType'] == 'POP')
      assert(avail_time_data['PointsValue'] == 1000)
    end
  }
end


Given /^I Add test restaurant "([^"]*)" to a Active POP suppress Promo pid "([^"]*)" having POP suppression excluded For (Lunch|Dinner) Only$/ do |rid, pid, shift|
  rest_obj = Restaurant.new(rid, $domain)
  rest_obj.change_promo_data(pid, 1, 1) #--setting active non expiry POP suppress promo
  rest_add = 1
  rest_obj.add_remove_restaurant_to_promo(rid, pid, rest_add)
  lunch_pop_exclusion = 1
  dinner_pop_exclusion = 0
  if (shift == 'Lunch')
    lunch_pop_exclusion = 0
    dinner_pop_exclusion = 1
  end
  rest_obj.setting_partial_promo_DIP_supress_exclusion(pid, rid, lunch_pop_exclusion, dinner_pop_exclusion)
  @search_obj = Search.new(rid, $domain)
  @search_obj.call_AvailService_recache()
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['pid'] = pid
end

Given /^I Add test restaurant "([^"]*)" Active POP Suppress Promo "([^"]*)" having exclusion date as "([^"]*)" from today$/ do |rid, pid, excl_date|
  rest_obj = Restaurant.new(rid, $domain)
  rest_obj.change_promo_data(pid, 1, 1)
  exclusion_date = DateTime.now + excl_date.to_i
  exclusion_date = exclusion_date.strftime("%Y-%m-%d 00:00:00.000")
  rest_obj.change_promo_exclusion_date(pid, exclusion_date)
  rest_add = 1
  rest_obj.add_remove_restaurant_to_promo(rid, pid, rest_add)
  @search_obj = Search.new(rid, $domain)
  @search_obj.call_AvailService_recache()
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['pid'] = pid
end
Then /^I verify search brings POP time on exclusion date but NON POP all other days for search time "([^"]*)"$/ do |s_time|
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"].each { |day_avail|
    day = day_avail["DayOffset"].to_i
    check_date = (@search_obj.postdata["LocalStartDate"]).to_date + day
    check_date = check_date.strftime("%Y-%m-%d")
    avail_time_data = @search_obj.get_Availability_data_for_date_time($RUNTIME_STORAGE['search_rid'], check_date, s_time)
    if (day != 0)
      assert(avail_time_data['PointsType'] == 'Standard', "expected Points :Standard but actual #{avail_time_data['PointsType']}")
      assert(avail_time_data['PointsValue'] == 100)
    else
      assert(avail_time_data['PointsType'] == 'POP', "expected Points :POP but actual #{avail_time_data['PointsType']}")
      assert(avail_time_data['PointsValue'] == 1000)
    end
  }
end

Given /^I Add test restaurant "([^"]*)" to an Active( NON)? Lunch-Dinner POP Suppress Promo "([^"]*)" with promo (Enabled|Disabled) for lunch and (Enabled|Disabled) for dinner$/ do |rid, non_lunch_dinner_promo, pid, has_lunch, has_dinner|
  promo_active = 1
  pop_suppress = 1
  rest_obj = Restaurant.new(rid, $domain)

  # default to a "lunch/dinner" promo unless "NON"
  promo_type = 4
  if (non_lunch_dinner_promo)
    promo_type = 3
  end

  rest_obj.change_promo_data(pid, promo_active, pop_suppress, '9999-12-31 00:00:00.000', promo_type)
  rest_add = 1
  rest_obj.add_remove_restaurant_to_promo(rid, pid, rest_add)
  lunchBit = 0
  if (has_lunch == 'Enabled')
    lunchBit = 1
  end
  dinnerBit = 0
  if (has_dinner == 'Enabled')
    dinnerBit = 1
  end
  rest_obj.set_restaurant_promo_shifts(rid, pid, lunchBit, dinnerBit)

  @search_obj = Search.new(rid, $domain)
  @search_obj.call_AvailService_recache()
  $RUNTIME_STORAGE['search_rid'] = rid
  $RUNTIME_STORAGE['pid'] = pid
end

When /^I call AvailabilitySearch API "([^"]*)" three times$/ do |uri|
  #---- using single service instance for calls ---
  server_list = SearchLogging.new($domain).getActiveServers()
  $host = "int-na-svc" #--- will be used in case of just one server
  $port = nil
  server_list.each { |each_server|
    if (server_list.length > 1)
      $host = "#{each_server}"
      $port = "#{$domain.availServer_site_port}"
    end
  }
  puts $host
  $post_ws = uri
  for i in 1..3 do
    post
    response_code_check("code", '200')
  end
end

Then /^I verify restaurant "([^"]*)" status changed to (FRN|TempInactive)$/ do |rid, status|
  #--- connect to db -
  sleep(30)
  exp_rest_status = 7
  if (status == 'FRN')
    exp_rest_status = 16
  end
  db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  #--- check rest status --
  sql = "select RestStateID from Restaurant where RID = #{rid}"
  result = db.runquery_return_resultset(sql)
  rest_status = result[0][0]
  assert(rest_status == exp_rest_status, "restaurant status expected ;#{exp_rest_status} but found :#{rest_status}")
  $RUNTIME_STORAGE['search_rid'] = rid
end

Given /^I set test ERB "([^"]*)" password in webdb to a invalid value$/ do |rid|
  $RUNTIME_STORAGE['search_rid'] = rid
  db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
  sql = "update ERBRestaurant set ServerPwd = 'BADPWD' where RID = #{rid}"
  result = db.runquery_return_resultset(sql)
  Search.new(rid, $domain).call_AvailService_recache()
end

Then /^I verify echoback data in response$/ do
  @search_obj.verify_echo_back_in_QualifiedSearch_response()
end

Then /^I verify echoback Exact Time is response is "([^"]*)"$/ do |exp_exact_time|
  @search_obj.verify_echo_back_exactTime_response(exp_exact_time)
end

Then /^I verify search brings AllowNextAvailable as "([^"]*)"$/ do |exp_NextAvail_flag|
  allowNextAvail = @search_obj.get_single_search_single_day_AllowNextAvail
  assert(allowNextAvail.to_s == exp_NextAvail_flag.to_s, "Expected NextAvail #{exp_NextAvail_flag} but Actual value returned #{allowNextAvail}")
end

Then /^I verify search brings AllowNextAvailable as "([^"]*)" for rid "([^"]*)"$/ do |flag, rid|
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"][0]["RIDSet"].each { |rec|
    if (rec["RID"].to_i == rid.to_i)
      assert(rec["AllowNextAvail"].to_s == flag.to_s)
    end
  }
end
Given /^call Search API using Rids "([^"]*)" and PartySize "([^"]*)"$/ do |rid_list, ps|
  rids_array = rid_list.split(",")
  array = Array.new
  rids_array.each { |rid|
    array << rid.to_i
  }
  @search_obj = Search.new(array[0], $domain)
  @search_obj.set_default_data_single_search()
  @search_obj.change_rids(rids_array)
  @search_obj.change_ps(ps)
  @search_obj.call_Qualified_Search()
end

Then /^I verify search brings availability all days$/ do
  result_hash = JSON.parse(@search_obj.response.body)
  result_hash["Available"].each { |day_avail|
    results = day_avail["RIDSet"][0]["Results"]
    assert(results.length > 0, "No Availability on Day Offset  #{day_avail['DayOffset']} ")
  }
end

############################################################################################
#------------------------------------- REST API Searches -----------------------------
############################################################################################

When /^I perform REST API search using PS "([^"]*)"$/ do |ps|
  @soap_service = RestOauthAPI.new
  rid = @search_obj.rid
  @soap_service.single_search(rid, days= 1, time='19:30', ps, is_cc = 0)
end

Then /^I verify REST API search brings NoAvailability Reason as "([^"]*)" for restaurant "([^"]*)"$/ do |search_result_message, rest_name|
  puts @soap_service.response['ns:NoTimesMessage']
  assert(@soap_service.response['ns:NoTimesMessage'].include? search_result_message)
end

Then /^I verify REST API search brings Availability$/ do
  puts @soap_service.response
  rest_hash = Hash.new
  if !(@soap_service.response['ns:NoTimesMessage'].nil?)
    raise Exception, "returns NoTime Message : #{@soap_service.response['ns:NoTimesMessage']}"
  end
  #if @soap_service.response['ns:ErrorID'].to_i == 0 and @soap_service.response['ns:NoTimesMessage'].nil?
  #  ['ns:EarlyTime', 'ns:ExactTime', 'ns:LaterTime', 'ns:EarlySecurityID', 'ns:ExactSecurityID', 'ns:LaterSecurityID', 'ns:EarlyPoints', 'ns:ExactPoints', 'ns:laterPoints', 'ns:ResultsKey'].each do |key|
  #    rest_hash[key] = @soap_service.response[key] if @soap_service.response[key]
  #  end
  #end
  #puts rest_hash
end
When /^I perform REST API search using searchdate "([^"]*)" days forward$/ do |days_fwd|
  @soap_service = RestOauthAPI.new
  rid = @search_obj.rid
  @soap_service.single_search(rid, days = days_fwd, time='19:30', ps = 2, is_cc = 0)
end

Then /^I call RESTSearch API using search day "([^"]*)" days from today, search time "([^"]*)" minutes from now$/ do |searchStartDayOffset, searchTimeOffsetMinutes|
  searchTime = searchTimeOffsetMinutes.to_i.minutes.from_now
  searchTime = searchTime.strftime("%H:%M")
  @soap_service = RestOauthAPI.new
  rid = @search_obj.rid
  @soap_service.single_search(rid, days= searchStartDayOffset, time = searchTime, ps = 2, is_cc = 0)
end

When /^I call REST API Search API for restaurant "([^"]*)" passing searchdate "([^"]*)" days forward, Time "([^"]*)"$/ do |rid, fwd_days, s_time|
  @soap_service = RestOauthAPI.new
  rid = @search_obj.rid
  @soap_service.single_search(rid, days = fwd_days, time = s_time, ps = 2, is_cc = 0)
end

Then /^I verify REST API returns "([^"]*)" for time slot "([^"]*)"$/ do |points, slot_time|
  rest_hash = Hash.new
  if !(@soap_service.response['ns:NoTimesMessage'].nil?)
    raise Exception, "returns NoTime Message : #{@soap_service.response['ns:NoTimesMessage']}"
  end
  if @soap_service.response['ns:ErrorID'].to_i == 0 and @soap_service.response['ns:NoTimesMessage'].nil?
    ['ns:EarlyTime', 'ns:ExactTime', 'ns:LaterTime', 'ns:EarlySecurityID', 'ns:ExactSecurityID', 'ns:LaterSecurityID', 'ns:EarlyPoints', 'ns:ExactPoints', 'ns:laterPoints', 'ns:ResultsKey'].each do |key|
      rest_hash[key] = @soap_service.response[key] if @soap_service.response[key]
    end
  end
  puts rest_hash["ns:#{slot_time}"]
  assert(rest_hash["ns:#{slot_time}"].to_i == points.to_i, "Expected points : #{points} don't match with actual points : #{rest_hash["ns:#{slot_time}"]}}")
end
When /^I call REST API multi search$/ do
  @soap_service = RestOauthAPI.new
  @soap_service.multi_search(metro_id = 4, region_id = 5, fwd_days = 1, time = '22:00', ps = 2, is_cc = 1)
end
\
Then /^I verify REST API brings Points "([^"]*)" slot "([^"]*)" for restaurant "([^"]*)"$/ do |points, slot_time, rid|
  #puts @soap_service.response
  @soap_service.response["SearchResults"].each { |rest_result|
    if (rest_result["ns:RestaurantID"].to_i == rid.to_i)
      puts rest_result
      case slot_time
        when "Exact"
          puts rest_result["ns:ExactPoints"]
          assert(rest_result["ns:ExactPoints"].to_i == points.to_i)
        when "Early"
          puts rest_result["ns:EarlyPoints"]
          assert(rest_result["ns:EarlyPoints"].to_i == points.to_i)
        else
          puts rest_result["ns:LaterPoints"]
          assert(rest_result["ns:LaterPoints"].to_i == points.to_i)
      end
    end
  }
end

When /^I call REST API multi search for metro "([^"]*)", region "([^"]*)" ,search day "([^"]*)", time "([^"]*)", partysize "([^"]*)"$/ do |mid, reg_id, days_fwd, s_time, ps|
  @soap_service = RestOauthAPI.new
  @soap_service.multi_search(mid.to_i, reg_id.to_i, days_fwd, s_time, ps, is_cc = 1)
end

Then /^I verify search brings no slot in Past time$/ do
  sdate = @search_obj.postdata["LocalStartDate"]
  result_in_abs_time = @search_obj.convert_avail_slot_in_abs_time(sdate)
  currentTime_plus5 = (Time.now + 5).strftime("%H:%M")
  slot_boundary_time = DateTime.strptime(currentTime_plus5, "%H:%M")
  result_in_abs_time.each { |slot_time|
    if (slot_time < slot_boundary_time)
      raise Exception, "PAST TIME Slot #{slot_time} not expected, slot boundary time #{slot_boundary_time}"
    end
  }
end

When /^I verify search brings "([^"]*)" of slots in backward window$/ do |slot_count|
  sdate = @search_obj.postdata["LocalStartDate"]
  result_in_abs_time = @search_obj.convert_avail_slot_in_abs_time(sdate)
  #--- get localExactTime in response ---
  result_hash = JSON.parse(@search_obj.response.body)
  s_time = result_hash["LocalExactTime"]
  exact_time = DateTime.strptime(s_time, "%H:%M")
  back_window_slot_count = 0
  result_in_abs_time.each { |slot_time|
    if (slot_time < exact_time)
      back_window_slot_count = back_window_slot_count + 1
    end
  }
  puts back_window_slot_count
  assert(back_window_slot_count >= slot_count.to_i, "Minimum Slots expected in backward window #{slot_count}, and got :#{back_window_slot_count}")
end
When /^I verify TimeSlot clipping not applied to next day$/ do
  #---search response - check avail slos for next day --
  sdate = DateTime.now + 1
  sdate = sdate.strftime("%Y-%m-%d")
  result_in_abs_time = @search_obj.convert_avail_slot_in_abs_time(sdate)
  currentTime_plus5 = (Time.now + 5).strftime("%H:%M")
  today_slot_boundary_time = DateTime.strptime(currentTime_plus5, "%H:%M") + 1
  next_day_slots_past_time = 0
  result_in_abs_time.each { |slot_time|
    if (slot_time < today_slot_boundary_time)
      next_day_slots_past_time = next_day_slots_past_time + 1
    end
  }
  puts next_day_slots_past_time
  assert(next_day_slots_past_time > 0, "No slots present for tomorrow before #{today_slot_boundary_time}")
end
When /^I call Search API using search day "([^"]*)", search days "([^"]*)" search time "([^"]*)" from now$/ do |fwd_days, multi_day, time_from_now|
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(fwd_days)
  @search_obj.change_forward_days(multi_day)
  searchTime = time_from_now.to_i.minutes.from_now
  searchTime = searchTime.strftime("%H:%M")
  @search_obj.change_search_time(searchTime)
  @search_obj.call_Qualified_Search()
end

When /^I verify search (does not bring|brings) availability for date "([^"]*)" at time "([^"]*)" with points "([^"]*)"$/ do |does, days_fwd, time, points|
  check_date = DateTime.now + days_fwd.to_i
  check_date = check_date.strftime("%Y-%m-%d")
  avail_time_data = @search_obj.get_Availability_data_for_date_time(@search_obj.rid, check_date, time)
  if does.include? 'not'
    assert_equal(false, avail_time_data["time_available"])
  else
    assert_equal(true, avail_time_data["time_available"], 'If you are checking the next holiday avail, check the restaurant advanced cutoff day.')
    assert_equal(points.to_i, avail_time_data["PointsValue"])
  end
end

When /^I call serach API using search time as past local time for restaurant "([^"]*)"$/ do |rid|
  local_date_time = Restaurant.new(rid, $domain).get_restaurant_localDateTime(rid)
  local_date_time = DateTime.parse(local_date_time.to_s)
  #---subtract 15 min from local time ---
  local_date_time = local_date_time - (15/1440.0)
  @search_obj.set_default_data_single_search()
  search_date = local_date_time.strftime("%Y-%m-%d")
  search_time = local_date_time.strftime("%H:%M")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(search_time)
  @search_obj.change_allow_pop(true)
  @search_obj.call_Qualified_Search()
end
When /^I call search API for today searchTime "([^"]*)" minutes from current Restaurant Time$/ do |time_offset_from_currentTime|
  local_date_time = Restaurant.new(@search_obj.rid, $domain).get_restaurant_localDateTime(@search_obj.rid)
  local_date_time = DateTime.parse(local_date_time.to_s)
  puts local_date_time
  #---adding 60 min in Rest local time ---
  local_date_time = local_date_time + (60/1440.0)
  @search_obj.set_default_data_single_search()
  search_date = local_date_time.strftime("%Y-%m-%d")
  search_time = local_date_time.strftime("%H:%M")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(search_time)
  @search_obj.call_Qualified_Search()
end
Then /^I verify search brings no slot in Local restaurant Past time$/ do
  sdate = @search_obj.postdata["LocalStartDate"]
  result_in_abs_time = @search_obj.convert_avail_slot_in_abs_time(sdate)
  local_date_time = Restaurant.new(@search_obj.rid, $domain).get_restaurant_localDateTime(@search_obj.rid)
  local_date_time = DateTime.parse(local_date_time.to_s)
  #---add 5 min in local time  ---
  currentTime_plus5 = (local_date_time + (5/1440.0)).strftime("%Y-%m-%dT%H:%M")
  slot_boundary_time = DateTime.strptime(currentTime_plus5, "%Y-%m-%dT%H:%M")
  result_in_abs_time.each { |slot_time|
    if (slot_time < slot_boundary_time)
      raise Exception, "PAST TIME Slot #{slot_time} not expected, slot boundary time #{slot_boundary_time}"
    end
  }
end

When /^I verify search brings minimum "([^"]*)" slots in backward window of search time$/ do |slot_count|
  sdate = @search_obj.postdata["LocalStartDate"]
  result_in_abs_time = @search_obj.convert_avail_slot_in_abs_time(sdate)
  #--- get localExactTime in response ---
  result_hash = JSON.parse(@search_obj.response.body)
  s_time = result_hash["LocalExactTime"]
  search_date_time = "#{sdate}T#{s_time}"
  exact_time = DateTime.strptime(search_date_time, "%Y-%m-%dT%H:%M")
  back_window_slot_count = 0
  result_in_abs_time.each { |slot_time|
    puts "#{slot_time} and searchtime #{exact_time}"
    if (slot_time < exact_time)
      back_window_slot_count = back_window_slot_count + 1
    end
  }
  assert(back_window_slot_count >= slot_count.to_i, "Minimum Slots expected in backward window #{slot_count}, and got :#{back_window_slot_count}")
end

Then /^I verify search brings No Availability$/ do
  avail_array = @search_obj.get_single_search_single_day_Availability()
  assert(avail_array.length == 0, "search should not bring availability but it returns availability")
end

When /^I call concurrent searches using umami rids "([^"]*)" for tomorrow, search time "([^"]*)"$/ do |rid_list, s_time|
  rids_array = rid_list.split(",")
  #---- post data body with rid 1  ----
  @search_obj.set_default_data_single_search()
  rid_array = Array.new
  rid_array[0] = rids_array[0]
  @search_obj.change_rids(rid_array)
  search_date = DateTime.now + 1
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(s_time)
  post_data = @search_obj.postdata
  post_data_json = post_data.to_json
  #---- post data body with rid 2  ----
  rid_array[0] = rids_array[1]
  @search_obj.change_rids(rid_array)
  search_date = DateTime.now + 2
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  post_data_2 = @search_obj.postdata
  post_data_json_2 = post_data_2.to_json
  threads = []
  for i in 0..8
    threads << Thread.new(i) do |i|
      Search.call_concurrent_search(i, post_data_json, post_data_json_2)
    end
  end
  threads.each do |t|
    t.join
  end
end

Then /^I verify each request returns availability$/ do
  #puts Search.response_array.length
  Search.response_array.each do |resp|
    avail_array = Search.check_search_response(resp)
    assert(avail_array.length > 0, " Search returns No Availability for tomorrow")
  end
end
When /^I verify search brings constrain "([^"]*)" for constrain name "([^"]*)"$/ do |c_value, c_name|
  c_value_actual = @search_obj.get_single_search_single_day_no_times_constrain_value(c_name)
  assert(c_value.to_i == c_value_actual.to_i, "Expected : #{c_value} actual value : #{c_value_actual}")
end

Given /^I call concurrent searches$/ do
  url = "http://www.opentable.com/opentables.aspx?m=4&p=1&d=8/30/2013%207:00:00%20PM&rid=2182&t=single&scpref=0"
  threads = []
  for i in 0..60
    threads << Thread.new(i) do |i|
      call(i, url)
    end
  end
  threads.each do |t|
    t.join
  end
end

def call(i, url)
  puts " i = #{i}"
  response = OTHttpClient.new().get(url)
end

When /^I call multi search API using rid_list "([^"]*)", OmitNotimeRest "([^"]*)", Offset "([^"]*)", limit "([^"]*)", time "([^"]*)"$/ do |rid_list, no_time_flag, offset, limit, time|
  rids_array = rid_list.split(",")
  array = Array.new
  rids_array.each { |rid|
    array << rid.to_i
  }
  @search_obj = Search.new(rids_array[0], $domain)
  @search_obj.set_default_data_single_search()
  @search_obj.change_rids(rids_array)
  @search_obj.change_fwd_mins(0)
  @search_obj.change_backward_mins(0)
  @search_obj.change_OmitNoTime(no_time_flag)
  @search_obj.change_search_time(time)
  @search_obj.change_Offset(offset)
  @search_obj.change_limit(limit)
  @search_obj.call_Qualified_Search()
end

Then /^I verify search response brings all restaurants in response$/ do
  @search_obj.postdata["RIDs"].each { |rid|
    rid_found = @search_obj.verify_searched_RIDs_in_availability_response(rid)
    assert(rid_found == true, "Search response doesn't include rid #{rid}")
  }
end

Then /^I verify search response omits restaurants with no availability$/ do
  rids_with_no_time = @search_obj.get_rests_with_noavailability_in_response()
  assert(rids_with_no_time.length == 0, "Search response include rids with noTimes  #{rids_with_no_time}")

end
Then /^I verify search brings restaurants starting offset "([^"]*)" and result limit "([^"]*)"$/ do |offset, limit|
  total_rests = @search_obj.check_total_restaurants_in_response()
  assert(total_rests.to_i == limit.to_i, " Expected paging limit #{limit} , but search returns total #{total_rests} restaurants")
  rest_list = @search_obj.get_rests_list_in_response()
  offset_rid = @search_obj.postdata["RIDs"][offset.to_i]
  assert(offset_rid.to_i == rest_list[0].to_i, " First restaurant doesn't match with Offset'")
end

When /^I verify search response last value is "([^"]*)"$/ do |last_value|
  actual_last = @search_obj.get_last_value_in_response()
  assert(actual_last.to_i == last_value.to_i, "Expected last value #{last_value}, actual last value #{actual_last}")
end

Then /^I verify search brings restaurants starting offset "([^"]*)" and OmitNotimeRest "([^"]*)"$/ do |offset, omit_no_time|
  rest_list = @search_obj.get_rests_list_in_response()
  first_rest_in_response = rest_list[0]
  rest_found_after_offset = false
  @search_obj.postdata["RIDs"][offset.to_i..3].each { |rid|
    if (rid.to_i == first_rest_in_response.to_i)
      rest_found_after_offset = true
    end
  }
  assert(rest_found_after_offset == true, "Search response first rid #{first_rest_in_response} not present in request body after offset #{offset}")
end

When /^I verify search brings total restaurant "([^"]*)"$/ do |limit|
  total_rests = @search_obj.check_total_restaurants_in_response()
  assert(total_rests.to_i == limit.to_i, " Expected paging limit #{limit} , but search returns total #{total_rests} restaurants")
end

When /^I call Search API using rid "([^"]*)", "([^"]*)" days from today, search time "([^"]*)"$/ do |rid, search_day_offset, search_time|
  $RUNTIME_STORAGE['search_rid'] = rid
  @search_obj = Search.new(rid, $domain)
  @search_obj.set_default_data_single_search()
  search_date = DateTime.now + search_day_offset.to_i
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(search_time)
  @search_obj.call_Qualified_Search()
end

When /^I call Search API for rid "([^"]*)" searchdate "([^"]*)" days forward, Time "([^"]*)", partsize "([^"]*)" and config switch "([^"]*)"$/ do |rid, search_day_offset, search_time, ps, config_values|
  @search_obj = Search.new(rid, $domain)
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(search_day_offset)
  @search_obj.change_search_time(search_time)
  @search_obj.change_ps(ps)
  #--- set config switch values
  @search_obj.set_config_values(config_values)
  #----
  @search_obj.call_Qualified_Search()
end

#When /^I get errorlog highwatermark$/ do
#  CacheTool.get_Errorlog_highwatermark()
#end
#
#When /^I verify Audit failure is (reported|Not reported) in weblogdb$/ do |audit_report_flag|
#  sleep(60)
#  auth_bit_webdb = @cs_tool.webdb_errorlog_Auditfailure_check()
#  if (audit_report_flag == "reported")
#    assert(auth_bit_webdb > 0, "Expected Errorlog entry for Audit failure but no entry found")
#  else
#    assert(auth_bit_webdb == 0, "Expected No Errorlog entry for Audit failure but entry found")
#  end
#end

When /^I call Search API for rid "([^"]*)" date "([^"]*)" days-fwd Time "([^"]*)", party "([^"]*)" config AvailStore Enabled "([^"]*)" Preference "([^"]*)" Audit "([^"]*)"$/ do |rid, search_day_offset, search_time, ps, enable, pref, audit|
  @search_obj = Search.new(rid, $domain)
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(search_day_offset)
  @search_obj.change_search_time(search_time)
  @search_obj.change_ps(ps)
  @search_obj.change_fwd_mins(0)
  @search_obj.change_backward_mins(0)
  @search_obj.set_config_values(rid, enable, pref, audit)
  @search_obj.call_Qualified_Search()
end

When /^I call Search for "([^"]*)", "([^"]*)" daysfwd, "([^"]*)", party "([^"]*)" "([^"]*)","([^"]*)" config values Enabled "([^"]*)" Preference "([^"]*)" Audit "([^"]*)"$/ do |rid, search_day_offset, search_time, ps, fwd_min, back_mins, enable, pref, audit|
  @search_obj = Search.new(rid, $domain)
  @search_obj.set_default_data_single_search()
  @search_obj.change_start_date_forward(search_day_offset)
  @search_obj.change_search_time(search_time)
  @search_obj.change_ps(ps)
  @search_obj.change_fwd_mins(fwd_min)
  @search_obj.change_backward_mins(back_mins)
  @search_obj.set_config_values(rid, enable, pref, audit)
  @search_obj.call_Qualified_Search()
end

Then /^I verify search brings maximum "(.*) Available slots$/ do |total_no|
  avail_array = @search_obj.get_single_search_single_day_Availability()
  assert(avail_array.length > 0, "search should bring availability but it returns No availability")
  assert(avail_array.length < 4, "search should bring maximum 3 slots , search returns total slots #{avail_array.length}")
end
When /^I call Search API lbstatus$/ do
  @search_obj = Search.new(1, $domain)
  @search_obj.call_Get_lbStatus()
end

Then /^I verify response returns "([^"]*)"$/ do |exp_status|
  if !ENV['LBStatus'].nil?
    # if teamcity passes value of expected LBStatus use that value othrewise use value passed thru feature file
    exp_status = ENV['LBStatus']
  end
  puts exp_status
  puts @search_obj.response.body
  assert(exp_status == @search_obj.response.body.gsub(/["]/, "").strip, "Expected response #{exp_status} Actual response : #{@search_obj.response.body} ")
end


When(/^I call search API on (suppress holiday|non holiday) date for time "([^"]*)", with AllowPop bit "([^"]*)"$/) do |veri_text, time, allow_pop_bit|
  @search_obj.set_default_data_single_search()
  search_date = DateTime.now + $RUNTIME_STORAGE['search_day_offset'].to_i
  unless veri_text == "suppress holiday"
    set_search_offset_based_on_holiday($RUNTIME_STORAGE['search_day_offset'].to_i + 1)
    search_date = DateTime.now + $RUNTIME_STORAGE['search_day_offset'].to_i
  end
  search_date = search_date.strftime("%Y-%m-%d")
  @search_obj.change_search_date(search_date)
  @search_obj.change_search_time(time)
  if !(allow_pop_bit.empty?)
    @search_obj.change_allow_pop(allow_pop_bit)
  end
  @search_obj.call_Qualified_Search()
end

When /^I call Slot-Status API using PS "([^"]*)"$/ do |ps|
  # use default date: tomorrow night at 7PM
  search_date = DateTime.now + 1
  search_date = search_date.strftime("%Y-%m-%d")
  search_date = search_date + "T19:00"
  @search_obj.call_Slot_Status(ps, search_date)
end

When /^I call Slot-Status API passing searchdate "([^"]*)" days forward$/ do |fwd_days|
  search_date = DateTime.now + Integer(fwd_days)
  search_date = search_date.strftime("%Y-%m-%d")
  search_date = search_date + "T19:00"
  @search_obj.call_Slot_Status(2, search_date)
end

When /^I call Slot-Status API passing searchdate "([^"]*)" days forward, Time "([^"]*)"$/ do |fwd_days, time|
  search_date = DateTime.now + Integer(fwd_days)
  search_date = search_date.strftime("%Y-%m-%d")
  search_date = search_date + "T" + time
  @search_obj.call_Slot_Status(2, search_date)
end

Then /^I verify slot-status returns NoTimesReasons as "([^"]*)"$/ do |expected_noAvail_reason|
  no_times_reasons = @search_obj.get_slot_status_no_times_reasons()
  assert_equal(no_times_reasons.length, 1)
  assert_equal(no_times_reasons[0], expected_noAvail_reason)
end

Then /^I verify slot-status returns empty NoTimesReasons$/ do
  no_times_reasons = @search_obj.get_slot_status_no_times_reasons()
  assert_equal(no_times_reasons.length, 0)
end