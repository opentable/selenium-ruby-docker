require 'httparty'
require 'json'
require 'domain'
#require 'utilities'



class NewUserAPI
  include OTServiceBase
  # HOST =  'int-na-svc-pp.otenv.com' #'services.opentable.com'
  # attr_accessor :resid, :conf_number, :rid, :party_size, :reso_time, :reso_date, :reso_state
  attr_accessor :email, :is_register,:is_admin, :first_name, :last_name, :city, :password, :id, :phone, :sortable_first_name, :sortable_last_name, :gpid, :diner_full_name, :kana_fname, :kana_lname , :special_request
  attr_reader :response, :raw_response, :uri, :port

  def initialize (port = nil,uri ='/user/v1/users', init_hash )      #uri = '/resoupdate/resoupdate', init_hash)

    current_domain = $domain.domain
    puts "current Domain IS  : #{current_domain}"
    @host =  $domain.user_api_host
    puts "I AM IN DOMAIN #{current_domain} AND I WILL BE GOING TO THE HOST #{@host} "
    @port = port
    @uri = uri #/user/v1/users
    arg_hash = defaults.merge(init_hash)
    arg_hash.each do |key, value|
      instance_variable_set("@#{key}".to_sym, value)
    end
  end

  def defaults
    {
        :email => "Auto_Gen_#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}@opentable.com",#@email, #"test999@opentable.com",
        :password => 'password',
        :first_name => "#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}",
        :last_name => "#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}",
    }
  end

  def set_body()

    body = {
        :FirstName => @first_name,
        :LastName => @last_name,
        :UserType => 1,
        :Email => @email,#"Auto_Gen_#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}@opentable.com",#@email, #"test999@opentable.com",
        :password => @password, #'password',
        :CountryId => $domain.primary_country_id, #This is now needed for Points redemption.
        :MetroId => $domain.primary_metro_id,
        :phone => "#{rand(899) + 100}555#{rand(8999) + 1000}",
        :mobile_phone => "#{rand(899) + 100}555#{rand(8999) + 1000}",

        #required for using the api with japanese characters
        # :sortable_first_name => '',
        # :sortable_last_name => '',
        # :kana_lname => "ヤマダ",
        # :kana_fname => "ハナコ",
    }
    return body

  end

  def set_anonymous_body()

    body = {
        :FirstName => @first_name,
        :LastName => @last_name,
        :UserType => 8,
        :Email => @email,#"Auto_Gen_#{(1..9).map { |_| ('a'..'z').to_a[rand(26)] }.join}@opentable.com",#@email, #"test999@opentable.com",
        :password => @password, #'password',
        :CountryId => $domain.primary_country_id, #This is now needed for Points redemption.
        :MetroId => $domain.primary_metro_id,
        :phone => "#{rand(899) + 100}555#{rand(8999) + 1000}",
        :mobile_phone => "#{rand(899) + 100}555#{rand(8999) + 1000}",

        #required for using the api with japanese characters
        # :sortable_first_name => '',
        # :sortable_last_name => '',
        # :kana_lname => "ヤマダ",
        # :kana_fname => "ハナコ",
    }
    return body

  end


def patch_user_make_admin(gpid)

  patch_body =  {
    :GlobalPersonID => gpid ,
    :Usertype => 3
  }
  header = {'Content-Type' =>'application/json'}
  @response = http_client.patch_json(@host,@port,@uri, patch_body, header,gpid)
  puts @response
end


  def Register_using_new_API ()

    @post_body = set_body()
    header = {'Content-Type' =>'application/json'}
   # @response = http_client.post_json(HOST,@port,@uri, @post_body, header)
    @response = http_client.post_json(@host,@port,@uri, @post_body, header)
    parse_response(@response)
    $USER['email'] = @email

  end

  def Anonymous_user_new_API ()

    @post_body = set_body()
    header = {'Content-Type' =>'application/json'}
    # @response = http_client.post_json(HOST,@port,@uri, @post_body, header)
    @response = http_client.post_json(@host,@port,@uri, @post_body, header)
    parse_response(@response)
    $USER['email'] = @email

  end

  def get_user_gpid_by_login (loginname)
    url = "http://#{$domain.user_api_host}/user/v1/users?login=#{loginname}"
    response = http_client.get(url)
    return @gpid = response.body
  end

  def get_user_gpid (email = @email)
    url = "http://#{$domain.user_api_host}/user/v1/users?email=#{email}"
    response = http_client.get(url)
    return @gpid = response.body
  end

   def check_response_code(code)
    @response.code.eql? code
  end

  def parse_response (response)
    puts "API response: #{response.body}"
    raise RuntimeError, "HTTP response code #{response.code}, response body #{response}" unless (accepted_return_code.include? response.code.to_i)
    begin
      parsed_res = JSON.parse(response.body)
    rescue JSON::ParserError
      raise RuntimeError, "Request has failed due #{response}"
    end
  end

  def accepted_return_code

    [200, 204, 409, 201, 401]

  end



end