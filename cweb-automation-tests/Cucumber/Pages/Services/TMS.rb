# -*- coding: utf-8 -*-
# encoding: utf-8
class TMS

  attr_accessor :response, :parsed_response, :email, :subject


  def initialize (tms_url)
    @tms_url = tms_url
   # @tms_url = $domain.tms_prod_url   if ENV['TEST_ENVIRONMENT'].downcase == 'prod'
  end

  def get_response (url)
    @response = OTHttpClient.new().get(url)
  end

  def get_email (email)
    url = "http://#{@tms_url}/v1/artifacts/?artifactToContains=#{email}"
    puts "tms url #{url}"
    res = get_response(url)
    obj = parsed_response(res)["matches"]
  end

  def get_each_email_artifact_match (obj)
    @email = Hash.new
    obj.each do |child|
      child_response = parsed_response(get_response(child["href"]))
      #see http://stackoverflow.com/questions/2982677/ruby-1-9-invalid-byte-sequence-in-utf-8 for details on below
      body = child_response["body"].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      subject = child_response["subject"].to_s.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      puts "email subject : #{subject}"
      @email[subject] = body
    end
  end

  def parsed_response (response)
    if response.code.to_i.eql? 200
      JSON.parse(response.body)
    else
      raise RuntimeError, "unexpected response from the service and response code is: #{response.code}"
    end
  end


  def get_email_subject_to_find_from_db(template_name, language_id = $domain.language_id)
    db = OTDBAction.new($domain.db_server_address, $domain.db_name, $domain.db_user_name, $domain.db_password)
    result_set = db.runquery_return_resultset(%{ Select Subject from EmailTemplates et inner join EmailTemplateDetails etd on et.EmailTemplateID = etd.EmailTemplateID where LanguageID = #{language_id} and TemplateName = '#{template_name}'})
    return result_set[0][0].encode
  end

  def get_email_subject (template_name, language_id = $domain.language_id)
    subject = self.get_email_subject_to_find_from_db(template_name, language_id = $domain.language_id) unless ["prod", "stage", "staging"].include?(ENV['TEST_ENVIRONMENT'].to_s.downcase)
    subject = email_subjects[".#{$domain.domain.downcase}"][template_name] if ["prod", "stage", "staging"].include?(ENV['TEST_ENVIRONMENT'].to_s.downcase)
    @subject = subject.gsub("[RestaurantName]", $RESTAURANT['name'])  unless $RESTAURANT['name'].nil?
    @subject = subject.gsub("[RestaurantName]", $RESTAURANT['RNAME']) unless  $RESTAURANT['RNAME'].nil?
  end


  def get_email_from_charm (email_id, fname, lname)
    email_id = @user.email unless @user.nil?
    user_name = user_name_for_charm_url(fname, lname)

    charm_url = "http://#{$domain.charm_address}/qawebtools/emails.aspx"
    charm_url = charm_url+"?name=#{user_name}&email=#{email_id}" unless (email_id.nil? and user_name.nil?)

    #opening in new browser to check email
    @browser = BrowserUtilities.open_browser($charm_default_browser, "WebDriver")

    email = Emails.new(@browser).get_email_body_using_email_subject(@subject, "", charm_url)
    @email[@subject] = email
    @browser.close
  end

  def user_name_for_charm_url (fname, lname)
    user_name="#{fname} #{lname}"
    #different domains has different name and email
    user_name="#{lname} #{lname}" if $domain.www_domain_selector.eql? "www.opentable.jp"
    user_name= fname if fname.eql? ""
    return user_name
  end

  def look_email_body_text (template_name)
    if @email[@subject].nil?
      self.get_email_from_charm(@email_id, @first_name, @last_name)
    end
    $RESERVATION['email'] = @email[@subject]
    raise Exception, "didn't find text in the email" unless @email[@subject].include? "#{email_body_text[template_name]}"
  end

  def verify_email (template_name, email_id, first_name, last_name )
    @first_name = first_name
    @last_name = last_name
    @email_id = email_id
    sleep 5
    get_email_subject(template_name, language_id = $domain.language_id)
    obj = get_email(email_id)
    if  obj.length > 0
      self.get_each_email_artifact_match(obj)
    else
      self.get_email_from_charm(@email_id, @first_name, @last_name)
    end
     self.look_email_body_text(template_name)
  end

end
