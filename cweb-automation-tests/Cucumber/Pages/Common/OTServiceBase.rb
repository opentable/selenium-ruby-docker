module OTServiceBase

  if !defined?(HEADER)
    HEADER = {'Content-Type' =>'application/json'}
  end

  attr_reader :http_client

  def http_client()
    @http_client ||= OTHttpClient.new()
  end
end