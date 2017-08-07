class ConciergeAdd < ConsumerBasePage

  def self.page_name 
 "conciergeadd.aspx" 
 end

  attr_accessor :driver, :metro_id, :domain
  attr_accessor :page_elements
  attr_accessor :page_name

  def initialize(*args)
    @driver, @metro_id = args
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "First Name" => "text_field_id;ucName_txtFirstName",
        "Last Name" => "text_field_id;ucName_txtLastName",
        "Login" => "text_field_id;tbLogin",
        "Password" => "text_field_id;tbPassword",
        "Re-type Password" => "text_field_id;tbPassword2",
        "Email Address" => "text_field_id;tbEmail",
        "Phone" => "text_field_id;PhoneEntry1_txtPhone1",
        "Add" => "button_id;btnAdd"
    }

    if ($domain.www_domain_selector.include? ".jp")
      if (@driver.link(:id, "linkForeign").visible?)
        @driver.link(:id, "linkForeign").click
      end

      @page_elements["Last Name"] = "text_field_id\;ucName_txtEngLastName"
      @page_elements["First Name"] = "text_field_id\;ucName_txtEngFirstName"
    end


    @page_elements
  end

  protected :init_elements

end