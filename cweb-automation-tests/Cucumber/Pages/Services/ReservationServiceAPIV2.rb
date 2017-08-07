class ReservationServiceV2
  require 'thread'
  include OTServiceBase
  include MiniTest::Assertions

  attr_accessor  :response

  def initialize(domain = $domain)
    @domain = domain
    @host =  $domain.reservation_service_host
    @uri = "/reservation/v2/restaurants"
    puts "ReservationServiceV2 DOMAIN -> #{$domain.domain}  uri: #{@uri} host: #{@host}"
  end

  def make_waitlist_body(gp_id, rid, ps=1, points=0)
    body = {
        :Gpid => gp_id.to_i,
        :ReservationType => "RemoteWaitlist",
        :DinerIsAccountHolder => true,
        :DinerInfo => {
            :Phone => {
                :PhoneType => "Mobile",
                :CountryCode => "US",
                :Number => "999#{rand(899) + 100}#{rand(8999) + 1000}",
                :Extension => "124",
            }
        },
        :RestaurantId =>  rid,
        :ReservationAttribute => "Default",
        :PartySize => ps,
        :PointsType => "None",
        :Points => points,
    }
    puts "Waitlist body=> #{body}"
    return body
  end

  def make_body(gp_id, days, time, resoType = "Standard", resoAttr = "Default", ps, isAdmin, pointsType)
    body = {
        :Gpid => gp_id.to_i,
        :ReservationDateTime => slot_lock_dt_format(days, time),
        :ReservationType => resoType,
        :ReservationAttribute => resoAttr,
        :PartySize => ps,
        :DinerIsAccountHolder => !(isAdmin),
        :PointsType => pointsType,
        }
    if isAdmin
      diner_body = {
          :DinerInfo =>{
            :FirstName => "#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}",
            :LastName => "#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}",
            :Phone  => {
              :Number => "#{rand(899) + 100}555#{rand(8999) + 1000}",
              :CountryCode  => "US",
              :PhoneType => "Mobile"
              }
            }
          }
      body = body.merge diner_body
    end
    return body
  end

  def reso_make (rid, make_body)
    puts "================ Making Reservation ================"
      @rid = rid
      header = {'Content-Type' =>'application/json'}
      uri = "#{@uri}/#{rid}/reservations"
      @response = http_client.post(@host, uri, make_body.to_json, header)
      @parsed_response = parse_response(@response) unless non_parsable_response_code.include? response.code.to_i
      unless non_parsable_response_code.include? response.code.to_i
        $RESERVATION['conf_number'] = @parsed_response['data']['confirmationNumber'] unless @parsed_response['data']['confirmationNumber'].to_i == 0
        $RESERVATION['securityToken'] = @parsed_response['data']['securityToken'] unless @parsed_response['data']['confirmationNumber'].to_i == 0
        raise Exception, "security token is not present " if $RESERVATION['securityToken'].nil? and @parsed_response['status'] == "Success"
        @lookup_url = "http://#{$domain.reservation_service}/reservation/v2/restaurants/#{rid}/confirmations/#{@confnum}" unless @parsed_response['data']['confirmationNumber'].to_i == 0
      end
      return $RESERVATION['conf_number']
  end

  def reso_update(make_body)
    puts "================ Modifying reservation ================"
    header = {'Content-Type' =>'application/json'}
    uri = "#{@uri}/#{$RESTAURANT['RID']}/confirmations/#{$RESERVATION['conf_number']}"
    securitytoken = {:SecurityToken => $RESERVATION['securityToken']}
    make_body = make_body.merge securitytoken
    @response = http_client.put(@host, uri, make_body.to_json, header)
    @parsed_response = parse_response(@response) unless non_parsable_response_code.include? response.code.to_i
  end

  def slot_lock_dt_format (days, time)
      unless days.class == Date
        days = day_fwd_based_on_locale(days).to_date.strftime("%F")
      end
      @time = DateTime.parse("#{time}").strftime("%H:%M")
      @date =  days
      @date_time = @date.to_s + "T" + @time
      return @date_time
  end

  def non_parsable_response_code
      [400, 404, 401]
  end

  def parse_response (response)
      puts "API response: #{response.body}"
      raise RuntimeError, "HTTP response code #{response.code}, response body #{response}" unless (accepted_return_code.include? response.code.to_i)
      begin
        parsed_res = JSON.parse(response.body)
      rescue JSON::ParserError
        raise RuntimeError, "Request has failed due #{response}"
      end
      return parsed_res
  end


  def accepted_return_code
      [200, 204, 409, 201, 401]
  end

  def reso_cancel
    puts "================ Canceling Reservation ================"
    $RESERVATION['isCancelled'] = false
    header = {'Content-Type' =>'application/json'}
    url = "#{@uri}/#{$RESTAURANT['RID']}/confirmations/#{$RESERVATION['conf_number']}/cancel"
    $RESERVATION['securityToken'] = self.reso_retrieve('securityToken') if $RESERVATION['securityToken'].nil?
    securitytoken = {:SecurityToken => $RESERVATION['securityToken']}
    @response = http_client.put(@host, url, securitytoken.to_json, header)
    puts "Cancel V2 API response: #{response.body}"
    @parsed_response = parse_response(@response)
    $RESERVATION['isCancelled'] = true if @parsed_response['status'] == "Success"
  end

  def reso_retrieve(attribute_name)
    header = {'Content-Type' =>'application/json'}
    url = "http://#{@host}#{@uri}/#{$RESTAURANT['RID']}/confirmations/#{$RESERVATION['conf_number']}"
    puts "ReservationServiceV2 Retrieve DOMAIN -> #{$domain.domain}  url: #{url}"
    @response = http_client.get(url)
    unless non_parsable_response_code.include? @response.code.to_i
      @parsed_response = parse_response(@response)
      if attribute_name.downcase.eql? "all"
        return @parsed_response
      else
        return @parsed_response['data'][attribute_name]
      end
    end
    raise Exception, "V2 Retrieve Reservation filed: #{url}\n#{@response.body}"
  end

end
