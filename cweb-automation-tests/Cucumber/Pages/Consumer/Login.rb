class Login < ConsumerBasePage

  attr_accessor :driver, :username, :password, :domain
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Email" => {
            "1" => "element_css;#Email",
            "2" => "input_id;txtUserEmail",
        },
        "Password" => {
          "1" => "element_css;#Password",
          "2" => "input_id;txtUserPassword",
        },
        "Sign In" =>  {
            "1" => "element_css;.button.expand",
            "2" => "element_css;#btnMember",
        },
        "Forgot Password" => "element_css,.secondary",
        "Create Account" => "element_css,.column.medium-8.large-6>a",
        "Sign up with Facebook" => "element_css;.button.with-icon.button-facebook.icon-facebook.expand",
        "Sign in with Google" => "element_css;.button.with-icon.button-google.icon-google-plus.expand",
    }
    @page_elements
  end

  protected :init_elements

  def self.page_name
    # "/my/loginpopup"
    "loginpopup"
  end

  def self.page_url_match? (url)
    super(url) and !url.include? "webmodule" and !url.include? "/irp"
  end

  def go_to()
    # strip sub domain info and go to login page
    # example: www.opentable.com/fr-CA becomes www.opentable.com
    # but make sure this also works for plain www.opentable.com too
    base_domain = @domain
    base_domain = base_domain.slice(0..(base_domain.index('/') - 1)) unless base_domain.index('/').nil?
    login_path = "my/loginpopup"
    login_path = "login.aspx" if ENV['TEST_ENVIRONMENT'].downcase == 'prod' && ((base_domain.eql? "www.opentable.com") || (base_domain.eql? "www.opentable.com.mx") || (base_domain.eql? "www.opentable.jp")) && (!base_domain.eql? "www.opentable.com.au")
    @driver.goto("http://#{base_domain}/#{login_path}")
  end

  def login(username, password, timeout=nil)
    if timeout.nil?
      timeout = 15
      timeout = 0 if ENV['TEST_ENVIRONMENT'].downcase == 'prod'
    end
    @username, @password = username, password
    go_to() #Go to www.opentable.<domain>/my/loginpopup

    @driver.wait_until(10, "Password field not visible in login page"){get_element("Password").present?}
    get_element("Email").send_keys(@username)
    sleep(0.5)
    get_element("Password").send_keys(@password)
    # Tests are sometimes failing here because password is not properly set when the Sign In button is clicked
    sleep(timeout)
    click("Sign In")

    begin
      @driver.wait_until(20, "User name not found"){get_element("User Name").present?}
      puts "User Name: #{get_element("User Name").text}"
      return true
    rescue
      if @driver.url.include? "loginpopup"
        #Fail the test immediately when diner can't login as test will fail down steam away from the root cause
        raise Exception,"Login failed! #{@driver.div(:id, "valSummary").text}"
      end
      false
    end
  end

  def login_frame(username, password, timeout=nil)
    if timeout.nil?
      timeout = 15
    end

    idx = 0
      login_frame = @driver.frame(:index => idx).form(:id => "loginForm")
      while ((!login_frame.present?) && (idx <= 5))
        idx = idx+1
        puts "idx ==> #{idx}"
        raise Exception, "Can't find Login frame" if !login_frame.present? && idx == 5
      end

      @driver.wait_until(60,"Login pop up not found"){login_frame.text_field(:id => "Email").present?}
      login_frame.text_field(:id => "Email").set  username
      login_frame.text_field(:id => "Password").set password
      sleep(timeout)

      login_frame.button(:class => "button expand").click
      raise Exception,"Login failed!" unless !login_frame.button(:class => "button expand").present?
  end

  def sign_out
    if get_element("Sign Out").methods.include? "exists"
      click("Sign Out")
    else
      puts "already signed out!"
    end
  end

end


