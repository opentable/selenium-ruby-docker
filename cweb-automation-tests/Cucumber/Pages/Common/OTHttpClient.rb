require 'timeout'

class OTHttpClient

  def get(uri)
    uri = URI.escape(uri)
    @response = Net::HTTP.get_response(URI.parse(uri))
  end

  def https_get(uri)
    try = 0
    begin
      #uri = URI.parse(uri)
      uri_tmp = uri.strip if uri.is_a? String
      uri_tmp = URI.parse(URI.encode(uri_tmp))
      http = Net::HTTP.new(uri_tmp.host, uri_tmp.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.read_timeout = 120
      request = Net::HTTP::Get.new(uri_tmp.request_uri)
      @response = http.request(request)
    rescue StandardError => error
      try += 1
      retry if try < 5
      raise Exception, "HTTP get failed: error: #{error}. uri: #{uri}"
    end

  end

  def get_call(host, port = nil, uri, header)
    post_ws = URI.escape(uri)
    req = Net::HTTP::Get.new(post_ws, initheader = header)
    httpObj = Net::HTTP.new(host, port)
    httpObj.open_timeout = 120
    httpObj.read_timeout = 120
    puts "HTTP get url: " + post_ws.to_s
    puts "Header: " + header.to_s
    @response = httpObj.start { |http| http.request(req) }
  end

  def post_json(host, port = nil, post_ws, reqbody_for_post, header)
    post_ws = URI.escape(post_ws)
    puts "HTTP post url: " + post_ws.to_s
    puts "Header: " + header.to_s
    req = Net::HTTP::Post.new(post_ws, initheader = header)
    req.body = reqbody_for_post.to_json
    puts "request body: " + req.body.to_s
    @response = Net::HTTP.new(host, port).start { |http| http.request(req) }
  end
  def patch_json(host, port = nil, patch_ws, reqbody_for_patch, header,gpid)
    pv = "/"+gpid
    patch_ws = URI.escape(patch_ws)+pv
    puts "HTTP post url: " + patch_ws.to_s
    puts "Header: " + header.to_s
    req = Net::HTTP::Patch.new(patch_ws, initheader = header)
    req.body = reqbody_for_patch.to_json
    puts "request body: " + req.body.to_s
    @response = Net::HTTP.new(host, port).start { |http| http.request(req) }
  end

  def post(host, port = nil, post_ws, reqbody_for_post, header)
    req = Net::HTTP::Post.new(post_ws, initheader = header)
    req.body = reqbody_for_post
    puts "HTTP post url: " + post_ws.to_s
    puts "Header: " + header.to_s
    puts "post body: " + req.body
    @response = Net::HTTP.new(host, port).start { |http| http.request(req) }
  end

  def https_post(uri, header, request_body = "")
    try = 0
    begin
     # uri = URI.parse(uri)
      uri_tmp = uri.strip if uri.is_a? String
      uri_tmp = URI.parse(URI.encode(uri_tmp))
      http = Net::HTTP.new(uri_tmp.host, uri_tmp.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.read_timeout = 120
      request = Net::HTTP::Post.new(uri_tmp.request_uri, initheader = header)
      request.body = request_body
      @response = http.request(request)
    rescue StandardError => error
      try += 1
      retry if try < 5
      raise Exception, "HTTP post failed: error: #{error}. uri: #{uri}, request body: #{request_body}"
    end

  end

  def delete(host, port = nil, post_ws, header)
    post_ws = URI.escape(post_ws)
    req = Net::HTTP::Delete.new(post_ws, initheader = header)
    #  @response = Net::HTTP.new(host, port).start { |http| http.request(req) }

    httpObj = Net::HTTP.new(host, port)
    httpObj.read_timeout = 90
    puts "HTTP delete url: " + post_ws.to_s
    puts "Header: " + header.to_s
    @response = httpObj.start { |http| http.request(req) }
  end

  def https_delete(uri, header, request_body = nil, https_off = false)
    try = 0
    begin
      #uri = URI.parse(uri)
      uri_tmp = uri.strip if uri.is_a? String
      uri_tmp = URI.parse(URI.encode(uri_tmp))
      http = Net::HTTP.new(uri_tmp.host, uri_tmp.port)
      unless https_off
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.read_timeout = 120
      request = Net::HTTP::Delete.new(uri_tmp.request_uri, initheader = header)
      request.body = request_body
      @response = http.request(request)
    rescue StandardError => error
      try += 1
      sleep 3
      retry if try < 10
      raise Exception, "HTTP delete failed: error: #{error}. uri: #{uri}, request body: #{request_body}"
    end
  end

  def put(host, port = nil, put_ws, reqbody_for_put, header)
    req = Net::HTTP::Put.new(put_ws, initheader = header)
    req.body = reqbody_for_put
    puts "HTTP put url: " + put_ws.to_s
    puts "Header: " + header.to_s
    puts "put body: " + req.body.to_s
    http = Net::HTTP.new(host, port)
    http.read_timeout = 120
    @response = http.start { |http| http.request(req) }
  end

  def https_put(uri, header, request_body, https_off = false)
    try = 0
    begin
      #uri = URI.parse(uri)
      uri_tmp = uri.strip if uri.is_a? String
      uri_tmp = URI.parse(URI.encode(uri_tmp))
      http = Net::HTTP.new(uri_tmp.host, uri_tmp.port)
      unless https_off
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.read_timeout = 120
      request = Net::HTTP::Put.new(uri_tmp.request_uri, initheader = header)
      request.body = request_body
      @response = http.request(request)

    rescue StandardError => error
      try += 1
      retry if try < 5
      raise Exception, "HTTP put failed: error: #{error}. uri: #{uri}, request body: #{request_body}"
    end

  end

  def response_code_check(exp_value)
    if !(@response.code == exp_value)
      raise Exception, "Expected response code to be #{exp_value}, but it was #{@response.code}"
    end
  end

end
