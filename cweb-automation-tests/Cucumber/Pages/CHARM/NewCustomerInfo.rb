class NewCustomerInfo < CHARMBasePage

  def self.page_name
    "ops_tools/NewCustomerInfo.asp"
  end

  def self.page_url_match? (url)
    super(url) or url.match /#{product_name}\..*\/NewCustomerInfo2.aspx/i
  end

# @ToDo: make driver read/write
  attr_reader :driver, :page_elements

  def initialize(browser)
    @driver = browser
    init_elements
    super(@driver, @page_elements)
  end

  def init_elements
    @page_elements = {
        "Email" => "text_field_name;email",
        "Submit" => "button_id;submit1",
        "De-activated" => "font_text;De-activated",
        "Active" => "font_text;Active",
        "Reset Password Attempts" => "font_text;Reset Password Attempts",
        "Customer Information Table" => "table_class;data tableborder",
        "Points Adjustment Reason" => "select_list_id;drpPointsAdjustmentReason",
        "Manage Hotels/Concierges" => "link_text;Manage Hotels/Concierges",
        "Points To Add" => "text_field_id;txtPointToAdd",
        "Add Points" => "button_id;btnAddPoints",
        "Change Email" => "button_id;btnChangeEmail",
        "Adjust Points" => "font_text;Adjust Points",
        "New Customer Search" => "button_value;New Customer Search",
        "Delete Facebook linking" => "link_text;Delete",
        "User Info" => "link_text;User Info",
    }
  end

  protected :init_elements

  def add_points(points)
    max_wait_in_seconds = 30

    # Click Adjust Points
    get_element("Adjust Points", max_wait_in_seconds).click

    # Wait for page to load
    @driver.wait_until { @driver.url.include? "/ops_tools/newCustomerInfo2.aspx" }

    # Select 'user Testing Points' from Point Adjustment Reason
    if get_element("Points Adjustment Reason").nil?
      raise Exception, "Point Adjustment Reason: drop down not found!"
    end

    select("Points Adjustment Reason", "User Testing Points")

    # Select points
    points = points.to_i
    if points != 500 && points != 100 && points != 900
      raise Exception, "invalid points amount!"
    end

    @driver.wait_until { @driver.button(:name, "btn#{points}").exists? && @driver.button(:name, "btn#{points}").enabled? }
    @driver.button(:name, "btn#{points}").click
  end

  def click(friendly_name)

    wait_timeout = 30

    # "De-activated" and "Activate" links often found but cannot be clicked for some strange reason.
    if friendly_name.eql? "De-activated" or friendly_name.eql? "Activate"
      @driver.goto(@driver.link(:xpath, "//a[contains(@href,'newCustomerInfo.asp?action=7')]").href)
    else
      super(friendly_name)
    end

    if friendly_name.eql? "Submit"
      if !WaitHelper.wait_until_url_present(@driver, "/ops_tools/newCustomerInfo.asp", wait_timeout)
        raise Exception, "Failed to search for user in CHARM NewCustomerInfo.asp page."
      end
    elsif friendly_name.eql? "Active"
      if !WaitHelper.wait_until_exists(@driver.font(:text, "De-activated"), wait_timeout)
        raise Exception, "Failed to find Active lin after reactivating user in CHARM NewCustomerInfo.asp page."
      end
    elsif friendly_name.eql? "De-activated"
      if !WaitHelper.wait_until_exists(@driver.font(:text, "Active"), wait_timeout)
        raise Exception, "Failed to find De-activated lin after reactivating user in CHARM NewCustomerInfo.asp page."
      end
    end
  end

  def search_users_by_email(email)
    get_element("Email", 120).set(email)
    click("Submit")
    1.upto(60) do
      begin
        self.text.include? "Information for customer(s) which met your criteria" or self.text.include? "There was 0 customer which met your search criteria"
        break
      rescue
        sleep 0.5
        retry
      end
    end
    return self
  end

  def user_exists?(search_terms)
    if is_on_user_search_page? == false
      self.click_on_userinfo
    end
    search_users_by_email(search_terms[:email])
    if self.text.include? "Information for customer(s) which met your criteria"
      return true
    elsif self.text.include? "There was 0 customer which met your search criteria"
      return false
    else
      raise RuntimeError, "Unable to search for user #{search_terms}"
    end
  end

#currently dependent on already being on the user page.
  def change_email(new_email)
    click("Change Email")
    @driver.window(:title, "Change Diner Email").use do
      @driver.text_field(:name, "txtNewEmail").set(new_email)
      @driver.button(:name, 'Submit').click
    end
    return self
  end

  def delete_facebook_account_link
    click("Delete Facebook linking")
  end

  def delete_google_account_link(email)
    find_uid_sql = "Select sc.UID from Customer c inner join SocialCustomer sc on c.CustID = sc.CustID where Email = \'#{email}\'"
    uid = $g_db.runquery_return_resultset(find_uid_sql)
    if !(uid.count == 0)
      for i in 0..uid.count - 1
        delete_user_sql = "Delete from SocialCustomer where UID = #{uid[i][0]}"
        $g_db.runquery_no_result_set(delete_user_sql)
      end
    end
  end

  def is_on_user_search_page?
    @driver.button(:id, "submit1").exists?
  end

  def click_on_userinfo
    sleep 2
    get_element("User Info").click
  end

end