class ConciergeLogin < ConsumerBasePage

  def self.page_name 
 "my/concierge"
 end

  attr_accessor :driver, :username, :password, :domain
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "User Name" => "element_css;#Email",
        "Password" => "element_css;#Password",
        "Sign In" => "element_css;.button.expand",
        "Forgot Password" => "element_css;.secondary",
        "Error" => "div_id;ValidationSummary1"
    }
    @page_elements
  end

  protected :init_elements

  def goto_login()
    visit("http://#{@domain}/#{self.class.page_name}")
  end

  def login(username, password)
    $driver.wait_until(5,"Unable to find Sign In button") {get_element("Sign In").present?}
    set("User Name", "#{username}")
    set("Password", "#{password}")
    get_element("Sign In").click
  end

  def sign_out
    click("Sign Out")
  end

end


