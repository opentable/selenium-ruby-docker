class UserAPI
  include OTServiceBase
  include MiniTest::Assertions

  attr_accessor :global_personID, :response, :domain, :email, :host, :port, :parsed_response,  :result_set, :siteUser_id

  def initialize(domain = $domain, email = nil, gpid = nil)
    @domain = domain
    @email = email
    @global_personID = gpid
    @host = @domain.user_api_host
    @port = nil
    super()
    set_port()
  end

  def set_port()
    @port = nil
  end

  def GetGPIdByEmail()
    uri = "http://#{@host}:#{@port}/user/v1/users?email=#{@email}"
    puts uri
    @response = http_client.get(uri)
    puts @response.code
    @global_personID = @response.body.to_i if @response.code.to_i == 201 or 200
  end

  def GetUserInfoByEmail(email)
    #gsub done below b/c 'auto_email' address is manipulated in global transformation step
    #and we don't want that here.
    #email_address = email.gsub!('z', 'a')
    uri = "http://#{@host}:#{@port}/user/v1/users?email=#{email}"
    @response = http_client.get(uri)
    uri = "http://#{@host}:#{@port}/user/v1/users/#{@response.body}"
    @response = http_client.get(uri)
    puts "Http response code from #{uri} is: " + @response.code
    parsed_res = JSON.parse(@response.body)
    raise Exception, "#{email_address} email expected and not found in response!" unless parsed_res["Email"].include? "#{email}"
  end

  def GetUserInfoByGPID(gpid)
    uri = "http://#{@host}:#{@port}/user/v1/users/#{gpid}"
    @response = http_client.get(uri)
    puts "Http response code from #{uri} is: " + @response.code
    parsed_res = JSON.parse(@response.body)
    raise Exception, "#{gpid} GPID expected and not found in response!" unless parsed_res['GlobalPersonId'] == gpid
  end

  def GetDinerInfoByUserEmail(email_address, diner_name)
    found_diner = 0
    uri = "http://#{@host}:#{@port}/user/v1/users?email=#{email_address}"
    @response = http_client.get(uri)
    uri = "http://#{@host}:#{@port}/user/v1/users/#{@response.body}/diners"
    @response = http_client.get(uri)
    puts "Http response code from #{uri} is: " + @response.code
    parsed_res = JSON.parse(@response.body)
    parsed_res.each { |user|
      if user["FirstName"].eql? diner_name
        found_diner = 1
      end
    }
    if found_diner == 0
      raise Exception, "diner '#{diner_name}' not found in response!"
    end
  end

  def Get_UserLogin(email, password)
    uri = "http://#{@host}:#{@port}/user/userlogin?email=#{email}&password=#{password}"
    puts uri
    @response = http_client.get(uri)
    puts @response.code
    @parsed_response = parse_response(@response) unless @response.code.to_i == 404 or @response.code.to_i == 204
  end

  def POST_GPIdByEmail(mid=nil)
    reqbody_for_post = nil
    uri = "/user/v1/users?email=#{@email}"
    puts uri
    @response = http_client.post_json(@host, @port, uri, reqbody_for_post, HEADER)
    puts @response.code
    return @response
  end

  def GetGPIdBylogin()
    uri = "http://#{@host}:#{@port}/user/v1/users?login=#{@email}"
    puts uri
    @response = http_client.get(uri)
    puts @response.code
  end

  def getUserDetailsBySocial(siteuser_id, provider = "facebook")
    uri = "http://#{@host}/user/v1/users/#{siteuser_id}/provider/#{provider}"
    @response = http_client.get(uri)
    puts @response.code
    @parsed_response = parse_response(@response) unless @response.code.to_i == 404 or @response.code.to_i == 204
  end

  def parse_response (response)
    puts "API response: #{response}"
    raise RuntimeError, "HTTP response code #{response.code}, response body #{response}" unless (user_service_return_codes.include? response.code.to_i)
    raise RuntimeError, "#{response}" if response.body.include?("Forbidden")
    begin
      parsed_res = JSON.parse(response.body)
    rescue JSON::ParserError
      puts "error happened during JSON parsing "
      raise RuntimeError, "Request has failed due #{response}"
    end
    return parsed_res
  end

  def user_service_return_codes
    [200, 201, 404, 204]
  end

  def connect_db_run_sql (sql, update = false, db_server = $domain.db_server_address, db_name = $domain.db_name)
    db = OTDBAction.new(db_server, db_name, $domain.db_user_name, $domain.db_password)
    if update
      db.runquery_no_result_set(sql)
    else
      result_set = db.runquery_return_resultset(sql)
      return result_set
    end
  end


  def update_social_caller_cust_table(id, is_admin)
    sql = "update SocialCustomer set custid = #{id}  where siteUserID = (select Top 1 SiteUserID  from SocialCustomer)"
    if is_admin
      sql = "update SocialCaller set CallerID = #{id}  where siteUserID = (select Top 1 SiteUserID  from SocialCaller)"
    end
    #update the table with newly created user info
    self.connect_db_run_sql(sql, true)
  end

  def get_user_social_id (id, is_admin)
    sql = "select Top 1 SiteUserID  from SocialCustomer where custid = #{id}"
    if is_admin
      sql = "select Top 1 SiteUserID  from SocialCaller Where callerid = #{id}"
    end
    #update the table with newly created user info
    result_set = self.connect_db_run_sql(sql, false )
    @siteUser_id = result_set[0][0]
  end


  def get_user_info_from_web_db(email, cust_type)
    #customer info
    sql = "select G.GlobalPersonID, C.CustID, C.Active, CT.ConsumerTypeID,C.Email,C.Email,C.FName,C.LName,C.Points,C.MetroAreaID,C.Country,SC.SiteUserID,SC.SocialTypeID from Customer C inner join GlobalPerson G on C.CustID = G.CustID inner join SocialCustomer SC on C.CustID = SC.CustID inner join ConsumerTypes CT on CT.ConsumerTypeID = C.ConsumerType Where Email = '#{email}'"
    #caller info
    if cust_type
      sql = "select G.GlobalPersonID,C.CallerID,C.CallerStatusID,CT.ConsumerTypeID,C.LoginName,C.Email,C.FName,C.LName,C.Points,C.MetroAreaID,C.Country,SC.SiteUserID,SC.SocialTypeID from Caller C inner join GlobalPerson G on C.CallerID = G.CallerID inner join SocialCaller SC on C.CallerID = SC.CallerID inner join ConsumerTypes CT on CT.ConsumerTypeID = C.ConsumerType Where LoginName = '#{email}'"
    end
    @webdb_user_details = self.connect_db_run_sql(sql)

  end

  def validate_data
    assert(@webdb_user_details[0] == @parsed_response["GlobalPersonId"],
           "mismatch user Global Person id: expecting #{@webdb_user_details[0]}; found #{@parsed_response["GlobalPersonId"]}")
    assert(@webdb_user_details[1] == @parsed_response["UserID"],
           "mismatch userID: expecting #{@webdb_user_details[1]}; found #{@parsed_response["UserID"]}")
    assert(@webdb_user_details[2] == @parsed_response["UserStatus"],
           "mismatch UserStatus: expecting #{@webdb_user_details[2]}; found #{@parsed_response["UserStatus"]}")
    assert(@webdb_user_details[3] == @parsed_response["LoginName"],
           "mismatch LoginName: expecting #{@webdb_user_details[3]}; found #{@parsed_response["LoginName"]}")
    assert(@webdb_user_details[4] == @parsed_response["Email"],
           "mismatch Email: expecting #{@webdb_user_details[4]}; found #{@parsed_response["Email"]}")
    assert(@webdb_user_details[5] == @parsed_response["FirstName"],
           "mismatch FirstName: expecting #{@webdb_user_details[5]}; found #{@parsed_response["FirstName"]}")
    assert(@webdb_user_details[6] == @parsed_response["LastName"],
           "mismatch lastName: expecting #{@webdb_user_details[6]}; found #{@parsed_response["LastName"]}")
    assert(@webdb_user_details[7] == @parsed_response["Points"],
           "mismatch Points: expecting #{@webdb_user_details[7]}; found #{@parsed_response["Points"]}")
    assert(@webdb_user_details[8] == @parsed_response["PointsAllowed"],
           "mismatch PointsAllowed: expecting #{@webdb_user_details[8]}; found #{@parsed_response["PointsAllowed"]}")
    assert(@webdb_user_details[9] == @parsed_response["MetroId"],
           "mismatch MetroId: expecting #{@webdb_user_details[9]}; found #{@parsed_response["MetroId"]}")
    assert(@webdb_user_details[10] == @parsed_response["CountryID"],
           "mismatch CountryID: expecting #{@webdb_user_details[10]}; found #{@parsed_response["CountryID"]}")
    assert(@webdb_user_details[11] == @parsed_response["SocialInfos"][0]['SocialUid'],
           "mismatch SocialUserId: expecting #{@webdb_user_details[11]}; found #{@parsed_response["SocialInfos"][0]['SocialUid']}")
    assert(@webdb_user_details[12] == @parsed_response["SocialInfos"][0]['SocialType'],
           "mismatch SocialType: expecting #{@webdb_user_details[12]}; found #{@parsed_response["SocialInfos"][0]['SocialType']}")


  end

  def  connect_mongo_db (db_name)
    mongo_db = MongoDBAction.new("mongo-db-primary", db_name, 'UserSvcUser','0pentab1e')
    return mongo_db
  end


  def remove_user_doc (db_name, collection, find_key, value)
    self.get_record_from_mongo(db_name, collection, find_key, value)
    connect_mongo_db(db_name).remove_document(collection, @result_set) unless @result_set.nil?
  end

  def init_page(page_class)
    @browser = BrowserUtilities.open_browser("ff") if @browser.nil?
    page = page_class.new(@browser)
    page.go_to()
    page
  end

  def login_to_facebook (username, password)
    #login using start page, which creates new record in social table
    sleep 3
    start_page=init_page(Login)
    start_page.login_via_facebook(username, password)
    sleep 1
    #close browser after login
    self.close_page
  end

  def close_page
    @browser.close if @browser
    @browser=nil
  end

  def get_record_from_mongo (db_name, collection, find_key, value)
      @result_set = connect_mongo_db(db_name).return_single_result_set(collection, find_key, value)
    return @result_set
  end

  def update_user_doc (dbname, collection, find_key, value, doc)
    self.get_record_from_mongo(dbname, collection, find_key, value)
    connect_mongo_db(dbname).update_document('collection',@result_set, doc)
  end

  def getUserEmail
     sql = "select top 1 Email  from Customer where Email not like '%@QuarterBehind.com' order by CustId Asc"
    record_set = self.connect_db_run_sql(sql, false)
    @email = record_set[0][0]
  end

  def getCallerDiner
    sql = "select top 1 C.email, CC.Fname from Caller C inner join CallerCustomer CC on C.callerid = CC.callerid  inner join globalperson gp on gp.CallerID = c.CallerID where CC.FName <> 'Opentable' and CC.LName <> 'User' and CC.Callerid <> 5 and cc.active = 1 and c.email = c.loginname"
    record_set  = self.connect_db_run_sql(sql, false)
    @email = record_set[0][0]
    diner_name = record_set[0][1]
    return diner_name
  end




end