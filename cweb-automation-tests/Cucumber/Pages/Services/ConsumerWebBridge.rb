class ConsumerWebBridge
  require 'thread'
  include OTServiceBase
  include MiniTest::Assertions

  attr_accessor  :response, :rid, :domain, :host, :port, :parsed_response

  def initialize(domain = $domain)
    @domain = domain
    @host = "consumerwebbridge-ci.otenv.com"
    @host = "consumerwebbridge-pp.otenv.com" if ENV['TEST_ENVIRONMENT'].downcase == 'preprod'
    @host = "consumerwebbridge-sc.otenv.com" if ENV['TEST_ENVIRONMENT'].downcase == 'prod'
    @uri = "/api"
    @port = nil
  end

  def enable_waitlist (rid, enabled)
      header = {'Content-Type' =>'application/json'}
      make_body = {:RID => rid, :IsOnlineWaitlistEnabled => enabled}
      uri = "#{@uri}/OnlineWaitlistChannelAdministration"
      @response = http_client.post(@host, uri, make_body.to_json, header)
      @parsed_response = parse_response(@response) unless non_parsable_response_code.include? response.code.to_i
      raise Exception, "IsOnlineWaitlistEnabled: #{enabled} for rid #{rid} failed" if non_parsable_response_code.include? response.code.to_i
      puts "Status for IsOnlineWaitlistEnabled: #{enabled} for rid #{rid} is #{response.code.to_i}"
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
end