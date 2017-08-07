# require 'minitest/autorun'
# require 'minitest/unit'
class Search
  require 'thread'
  include OTServiceBase
  #include MinitestWorld
  # include MiniTest::Assertions

  attr_accessor :rid, :offer_ids, :response, :domain, :postdata, :search_result_json, :host, :port, :unparsed_response
  cattr_accessor :response_array

  @@response_array = Array.new() { Hash.new }

  def initialize(rid,domain )
     @rid = rid
     @domain = domain
     #--- consider initializing this thru teamcity env variable --
     #ENV['ServiceHost'] =  'sc-na-isvc-01.otsql.opentable.com'
     if ENV['ServiceHost'].nil?
       @host = @domain.internal_services
       @port = nil
     else
       @host = ENV['ServiceHost']
       @port = @domain.availServer_site_port
     end
    end

  def self.call_concurrent_search(thread_no, post_data_1, post_data_2)
    post_ws = "/availability/search"
    req = Net::HTTP::Post.new(post_ws, initheader = {'Content-Type' =>'application/json'})
    if ( thread_no.to_i.odd?)
       req.body = post_data_2
    else
       req.body = post_data_1
    end
    response = Net::HTTP.new("int-na-svc", nil).start { |http| http.request(req) }
    @@response_array << {"thread No: " => thread_no, "search_response :" => response }
  end

  def self.check_search_response(response)
     if (response["search_response :"].code != '200')
        raise Exception, "search response code is :#{response["search_response :"].code} in thread No #{response["thread No: "]} "
     end
     result_hash = JSON.parse(response["search_response :"].body)
     #puts "Search Response :: Thread No: #{response["thread No: "]},  RID #{result_hash["Available"][0]["RIDSet"][0]["RID"]} , SearchDate = #{result_hash["LocalStartDate"]} , Time #{result_hash["LocalExactTime"]}"
     avail_array =  result_hash["Available"][0]["RIDSet"][0]["Results"]
     return avail_array
  end

  def call_Get_lbStatus()
      uri = "http://#{@host}:#{@port}/availability/lbstatus"
      puts uri
      @response = http_client.get(uri)
      response_code_check('200')
  end

  def call_Qualified_Search()
      reqbody_for_post = @postdata
      svc_uri_fragment = "/availability/search"
      #--- preprod server ---
      puts "HTTP post url:  http://#{@host}:#{@port}/availability/search"
      puts "reqbody_for_post: #{reqbody_for_post}"
      @response = http_client.post_json(@host,@port,svc_uri_fragment,reqbody_for_post, HEADER )
      response_code_check('200')
  end

  def call_Slot_Status(ps, dt)
    uri = "http://#{@host}:#{@port}/availability/v1/slot-status?restaurantId=#{@rid}&partySize=#{ps}&reservationDateTime=#{dt}"
    puts uri
    @response = http_client.get(uri)
    response_code_check('200')
  end

  def call_AvailService_recache(content_ctgy = nil)
      #--- get list of servers ---
	  puts "call_AvailService_recache"
      server_list = getActiveServers()
      threads = []
      server_list.each do |host|
        threads << Thread.new(host) do |host|
          call_request(host,@domain.availServer_site_port, "/availability/recache" )
        end
      end
      threads.each do |t|
        t.join
      end
  end

  def call_request(host, port, uri)
      puts "#{host}:#{port}#{uri}"
      res = http_client.get_call(host, port,uri, HEADER)
      response_code_check('200')
    end

  def getActiveServers()
    db = OTDBAction.new(@domain.db_server_address, @domain.db_name, $db_user_name, $db_password)
    sitetypeid =   @domain.availServer_sitetype_id
    sql = "SELECT S.IPAddress FROM ServerSite SS INNER JOIN Server S on SS.ServerID = s.serverid  WHERE SS.SiteTypeID = #{sitetypeid} and S.AcceptsTraffic =1 "
    result_set = db.runquery_return_resultset(sql)
    ip_array = Array.new()
    result_set.each { |i|
            ip_array << i[0]
    }
    return ip_array
  end

  def get_single_search_single_day_Availability(day_index = 0)
    result_hash = JSON.parse(@response.body)
    puts result_hash
    return result_hash["Available"][day_index]["RIDSet"][0]["Results"]
  end

  def get_single_search_single_day_AllowNextAvail(day_index = 0)
    result_hash = JSON.parse(@response.body)
    puts result_hash
    return result_hash["Available"][day_index]["RIDSet"][0]["AllowNextAvail"]
  end

  def get_single_search_single_day_no_times_reasons()
    result_hash = JSON.parse(@response.body)
    return result_hash["Available"][0]["RIDSet"][0]["NoTimesReasons"]
  end

  def get_single_search_single_day_no_times_constrain_value(const_name)
    result_hash = JSON.parse(@response.body)
    return result_hash["Available"][0]["RIDSet"][0][const_name]
  end

  def get_Availability_data_for_date_time(rid,sdate,stime)
    result_hash = JSON.parse(@response.body)
    day_offset = DateTime.strptime(sdate, "%Y-%m-%d") -  DateTime.strptime(result_hash['LocalStartDate'], "%Y-%m-%d")
    #---get availability data for check date and rid  --
    returned_times = []
    result_hash["Available"].each { |day_avail|
       if (day_avail["DayOffset"] == day_offset)
          day_avail["RIDSet"].each { | rid_avail|
            if (rid_avail["RID"] == rid.to_i )
               returned_times =  rid_avail["Results"]
               puts "Search avail for the rid: rid_avail[\"Results\"]: #{rid_avail["Results"].inspect}"
             break
            end
          }
       break
    end
    }
    search_time_data = {}
    search_time_data["time_available"]  = false
    returned_times.each { |avail_time_rec|
      #---using exact-time and timeOffset get absoloute time ---
      availTime = DateTime.strptime(result_hash["LocalExactTime"], "%H:%M") + (avail_time_rec['TimeOffsetMinutes']/1440.0)
      if  (availTime.strftime("%H:%M") == stime)
        search_time_data = avail_time_rec
        search_time_data["absolute_time"]  = stime
        search_time_data["time_available"]  = true
        break
      end
    }
    return search_time_data
  end


  def change_ps(search_ps)
      @postdata["PartySize"]  = search_ps.to_i
  end

  def change_rids(rids_array)
    @postdata["RIDs"]  = rids_array
  end

  def change_OmitNoTime(no_time_flag)
      @postdata["OmitNoTimesRestaurants"]  = no_time_flag
  end

  def change_Offset(offset)
      @postdata["Offset"]  = offset
  end

  def change_fwd_mins(fwd_mins)
    @postdata["ForwardMinutes"]= fwd_mins.to_i
  end

  def change_backward_mins(backward_mins)
    @postdata["BackwardMinutes"]= backward_mins.to_i
  end

  def change_limit(limit)
      @postdata["Limit"]  = limit
  end

  def change_start_date_forward(fwd_days)
    search_date = DateTime.now + Integer(fwd_days)
    @postdata["LocalStartDate"]  = search_date.strftime("%Y-%m-%d")
  end

  def change_search_date(search_date)
      @postdata["LocalStartDate"]  = search_date
  end

  def change_forward_days(fwd_days)
    @postdata["ForwardDays"]  = fwd_days.to_i
  end

  def change_search_time(search_time)
      @postdata["LocalExactTime"]  = search_time
  end

  def change_allow_pop(allowPOP)
      @postdata["AllowPOP"]  = allowPOP
  end

  def change_IncludeOffer(offer_flag)
    @postdata["IncludeOffers"]  = offer_flag
  end

  def disable_direct_erb_search(search_erb)
    @postdata["ProhibitDirectSearch"] = search_erb
  end

  def set_default_data_single_search(rid = @rid)
      # single day single RID search, 7:30 PM tomorrow, 2.5 hr symmetric window around exact time
      search_postdata =  {}
      rid_array = Array.new
      rid_array[0] = rid
      search_date = DateTime.now + 1
      search_postdata["RIDs"]= rid_array
      search_postdata["LocalStartDate"] = search_date.strftime("%Y-%m-%d")
      search_postdata["ForwardDays"] = 0
      search_postdata["LocalExactTime"] = "19:00"
      search_postdata["ForwardMinutes"]= 150
      search_postdata["BackwardMinutes"]= 150
      search_postdata["PartySize"]  = 2
      @postdata = search_postdata
  end

  def set_restref(rid)
    attribution_data = {}
    attribution_data["RestRefID"] = rid
    attribution_data["PartnerID"] = 1
    attribution_data["ReferrerID"] = 0
    @postdata["Attribution"] = attribution_data
  end

  def set_config_values(rid,enable,pref,audit)
    erb_cacheServerId = get_ERB_cacheServer_id(rid)
    app_setting = {}

    if (enable == true)
      app_setting["EnableAvailabilityStoreWhitelist"] = "E,G"
    else
      app_setting["EnableAvailabilityStoreWhitelist"] = ""
    end

    app_setting["AvailabilityStoreCSWhitelist"] = erb_cacheServerId

    if (pref == true)
      app_setting["AvailabilityStoreHasPrecedenceWhiteList"] = "E,G"
    else
      app_setting["AvailabilityStoreHasPrecedenceWhiteList"] = ""
    end

    if (audit == true)
      app_setting["AuditAvailabilityStoreWhitelist"] = "E,G"
    else
      app_setting["AuditAvailabilityStoreWhitelist"] = ""
    end

    @postdata["AppSettings"] = app_setting
  end

    def verify_echo_back_in_QualifiedSearch_response()
      puts @postdata
      puts @response.body
      result_hash = JSON.parse(@response.body)
      #-	Verify Echo back of start date, exact time, party size
       assert_equal result_hash["LocalStartDate"],  @postdata["LocalStartDate"], " StartDate Echo back doesn\'t match in response"
      # assert(result_hash["LocalExactTime"] == @postdata["LocalExactTime"], " ExactTime Echo back doesn\'t match in response")
      # assert(result_hash["PartySize"] == @postdata["PartySize"], " PartySize Echo back doesn't match in response")
      # assert(result_hash["ForwardDays"] == @postdata["ForwardDays"], " ForwardDays Echo back doesn't match in response'")
      # assert(result_hash["ForwardMinutes"] == @postdata["ForwardMinutes"], " ForwardMinutes Echo back doesn't match in response'")
      # assert(result_hash["BackwardMinutes"] == @postdata["BackwardMinutes"], " BackwardMinutes Echo back doesn't match in response'")
  end

  def verify_echo_back_exactTime_response(exp_time)
      result_hash = JSON.parse(@response.body)
      assert(result_hash["LocalExactTime"] == exp_time, " ExactTime Echo back doesn't match as expected ")
  end

  def convert_avail_slot_in_abs_time(sdate)
    result_hash = JSON.parse(@response.body)
    day_offset = DateTime.strptime(sdate, "%Y-%m-%d") -  DateTime.strptime(result_hash['LocalStartDate'], "%Y-%m-%d")
    #---get availability data for check date and rid  --
    returned_times = []
    result_hash["Available"].each { |day_avail|
       if (day_avail["DayOffset"] == day_offset)
          day_avail["RIDSet"].each { | rid_avail|
            if (rid_avail["RID"] == rid.to_i )
               returned_times =  rid_avail["Results"]
             break
            end
          }
       break
    end
    }
    result_time = []
    returned_times.each { |avail_time_rec|
      search_date_time =  "#{sdate}T#{result_hash["LocalExactTime"]}"
      search_date_time =  DateTime.strptime(search_date_time, "%Y-%m-%dT%H:%M")
      puts search_date_time
      #availTime = DateTime.strptime(result_hash["LocalExactTime"], "%H:%M") + (avail_time_rec['TimeOffsetMinutes']/1440.0)
      availTime = search_date_time + (avail_time_rec['TimeOffsetMinutes']/1440.0)
      #time_slot = availTime.strftime("%H:%M")
      #s = sdate + 'T'  + time_slot
      #s = DateTime.strptime(s, "%Y-%m-%dT%H:%M")
      s = availTime
      puts s
      result_time << s
    }
    return result_time
  end


  def verify_searched_RIDs_in_availability_response(rid)
    result_hash = JSON.parse(@response.body)
    puts result_hash
    rid_exist = false
    result_hash["Available"][0]["RIDSet"].each { |rids|
      if (rids["RID"] == rid.to_i )
         rid_exist = true
         break
      end
    }
    return rid_exist
  end

  def check_total_restaurants_in_response()
    result_hash = JSON.parse(@response.body)
    puts result_hash
    total_rests = result_hash["Available"][0]["RIDSet"].length
    return total_rests
  end

  def get_rests_list_in_response()
      result_hash = JSON.parse(@response.body)
      puts result_hash
      rids_in_response = []
      result_hash["Available"][0]["RIDSet"].each { |rids|
        rids_in_response << rids["RID"]
      }
      return rids_in_response
  end

  def get_last_value_in_response()
    result_hash = JSON.parse(@response.body)
    return result_hash["Last"]
  end

  def get_rests_with_noavailability_in_response()
    result_hash = JSON.parse(@response.body)
    puts result_hash
    rids_with_no_time = []
    result_hash["Available"][0]["RIDSet"].each { |rids|
      puts rids["NoTimesReasons"]
      if (rids["NoTimesReasons"].length > 0 )
         rids_with_no_time << rids["RID"]
      end
    }
    return rids_with_no_time
  end

  def response_code_check(exp_value)
        http_client.response_code_check(exp_value)
  end

  def get_ERB_cacheServer_id(rid)
    db = OTDBAction.new(@domain.db_server_address, @domain.db_name, $db_user_name, $db_password)
    sql = "select CG.CacheServerID from ERBRestaurant E
         inner join CacheServerERBGroup CG
         on E.CacheServerERBGroupID = CG.CacheServerERBGroupID
         where RID = #{rid}"
    result = db.runquery_return_resultset(sql)
    puts result[0][0]
    return result[0][0]
  end

  def build_date_string(days)
    s_date = day_fwd_based_on_locale(days).to_date
    sdate = "#{s_date.strftime('%Y-%m-%d')}"
    return sdate
  end

  def build_24_hour_time(time)
    time_stg = DateTime.parse("#{time}").strftime("%H:%M")
    return time_stg
  end

  def get_rest_avail (rid, search_days, time, ps, fwd_days, points_type = "standard")
    self.get_available_response(rid, search_days, time, ps, fwd_days)
    if points_type == "POP"
       return check_pop_avail_days
    else
      return check_avail_days
    end
  end

  def get_available_response (rid, search_days, time, ps, fwd_days)
    if $TEST_ENVIRONMENT.eql? "Prod"
      $domain.int_services = $domain.prod_int_services
    end
    puts $domain.int_services
    body =  set_restaurant_availability_search_data(rid, search_days, time, ps, fwd_days)
    url = "http://#{$domain.internal_services}/availability/search"
    uri = URI.parse(url)
    puts "HTTP post url: #{url}"
    @unparsed_response = http_client.post_json(uri.host, nil, uri.path, body, HEADER )
    @response = parse_response(@unparsed_response)
  end

  def set_restaurant_availability_search_data (rid, search_days = 1, time = "19:00", ps = 2, fwd_days = 2, fwd_min = 30, bkw_min = 30, includeOffers = false, disableErbsearch = false, includeNotimes = false  )

      body = {
           :RIDs => rid,
           :LocalStartDate => build_date_string(search_days) ,
           :LocalExactTime => build_24_hour_time(time),
           :PartySize => ps,
           :ForwardDays => fwd_days,
           :ForwardMinutes => fwd_min,
           :BackwardMinutes => bkw_min,
           :AllowPOP => true,
           :Attribution => {:RestRedID => "", :ReferrerlID => "", :PartnerID => ""},
           :SessionID => "",
           :IncludeOffers => includeOffers,
           :DisableDirectErbSearch => disableErbsearch,
           :OmitNoTimesRestaurants => includeNotimes,
       }
      return body
  end

  def parse_response (response)
    puts "API response: #{response}"
    raise RuntimeError, "HTTP response code #{response.code}, response body #{response}" unless (response.code.to_i == 200 )
    raise RuntimeError, "#{response}" if response.body.include?("Forbidden")
    begin
      parsed_res = JSON.parse(response.body)
    rescue JSON::ParserError
      puts "error happened during JSON parsing "
      raise RuntimeError, "Request has failed due #{response}"
    end
    return parsed_res['Available']
  end

  def check_avail_days
    availability = Array.new
     @response.each do |days|
       search_results = Hash.new
        days['RIDSet'].each do |rid|
          if rid['NoTimesReasons'].empty?
             rid['Results'].each do |time|
               if time['TimeOffsetMinutes'].to_i == 0
                  search_results['DayOffset'] = days['DayOffset'].to_i
                  search_results['RID'] = rid['RID'].to_i
                end
             end
          end
        end
         availability << search_results unless search_results.empty?
     end
    puts availability
     return availability
  end

  def check_pop_avail_days
    availability = Array.new
    @response.each do |days|
      search_results = Hash.new
      days['RIDSet'].each do |rid|
        if rid['NoTimesReasons'].empty?
          rid['Results'].each do |time|
            if time['TimeOffsetMinutes'].to_i == 0  and time['PointsType']== 'POP'
              search_results['DayOffset'] = days['DayOffset'].to_i
              search_results['RID'] = rid['RID'].to_i
            end
          end
        end
      end
      availability << search_results unless search_results.empty?
    end
    puts availability
    return availability
  end

  def get_slot_status_no_times_reasons()
    result_hash = JSON.parse(@response.body)
    puts result_hash
    return result_hash["NoTimesReasons"]
  end

end