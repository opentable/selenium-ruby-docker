class ForgotPassword < ConsumerBasePage

  def self.page_name 
 "my/ResetPassword"
 end

  attr_accessor :domain
  attr_reader :driver, :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Email Address" => "text_field_id;UserName",
        "User Name" => "text_field_id;UserName",
        "Reset Password" => "element_css;.button.margin-top"
    }
    @page_elements
  end

  protected :init_elements

end