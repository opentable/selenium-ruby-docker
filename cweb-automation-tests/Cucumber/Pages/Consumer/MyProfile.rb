class MyProfile < ConsumerBasePage

  def self.page_name
    "myprofile"
  end

  # tab names
  TAB_RESERVATION_HISTORY = "Reservation History"
  TAB_ACCOUNT_DETAILS = "Account Details"
  TAB_FAVORITES = "Favorites"
  TAB_EMAIL_PREFERENCES = "Email Preferences"

  attr_accessor :driver, :domain
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Reservation History" => "element_id;TabNav$btnReservationHistory",
        "Favorites" => "element_id;TabNav_btnFavorites",
        "Account Details" => {
           1 => "element_xpath;div[2]/div/div[1]/nav/ul/li[3]/span/a",
           2 => "element_id;TabNav_btnAccountDetails"
        },
        "Email Preferences" => "element_id;TabNav_btnEmailPreferences",
        "Enter Email" => "text_field_id;UserLogin1_txtEmail",
        "Re-enter Email" => "text_field_id;UserLogin1_txtEmail2",
        "Update Profile" => "button_id;btnUpdateProfile",
        "Phone" => "text_field_id;PhoneEntry_Phone_txtPhone1",
        "Administrator" => "checkbox_name;chkIsAdmin",
        "Edit My Diners" => "button_id;btnEditMyDiners",
        "Redeem Points" => "link_id;hlUserLinkRedeemMyPoints",
        "Add New Concierge" => "link_href;conciergeadd.aspx",
        # reservation activity table id friendly name has given as search results to re-use the step def
        "Search Results" => "table_id;gridActivities",
        "Modify" => {
            1 => "image_src;/img/de-DE/btn_m.gif",
            2 => "image_src;/img/buttons/btn_m.gif",
            3 => "image_src;/img/ja-JP/btn_m.gif"
        },
        "Cancel" => {
            1 => "image_src;/img/de-DE/btn_c.gif",
            2 => "image_src;/img/buttons/btn_c.gif",
            3 => "image_src;/img/ja-JP/btn_c.gif"
        },

        "Favorites Restaurant 1" => {
            1 => "checkbox_id;gridPotentialFavoritesGrid_ctl02_checkboxSelectAdd",
            2 => "checkbox_id;gridFavoritesGrid_ctl02_checkboxSelect"
        },

        "Favorites Restaurant 2" => {
            1 => "checkbox_id;gridPotentialFavoritesGrid_ctl03_checkboxSelectAdd",
            2 => "checkbox_id;gridFavoritesGrid_ctl03_checkboxSelect"
        }

    }
    @page_elements
  end

  protected :init_elements

  def go_to()
    if !@driver.url.include? self.class.page_name
      @driver.goto("http://#{@domain}/start.aspx?m=1")
      @driver.link(:id, "TopNav_linkMyProfile").click
      @driver.wait_until(30, "My Profile page is not up") {$driver.url.downcase.include? "profile"}
    end
  end

  def click_tab(tab_name)
    click(tab_name)
  end

  def total_user_points
    go_to()
    # ToDo: add to friendly name hash
    points_text = @driver.span(:id, "conUserStateDetails_lblPointBalance").text
    if points_text.include? ","
      points_text.gsub(/,/, '').to_i
    else
      points_text.gsub(".", '').to_i
    end

  end

  def first_restaurant_transaction
    go_to()
    @driver.table(:id, "gridActivities").rows(:class, /Activity/).first.html
  end

  def last_restaurant_transaction
    go_to()
    @driver.table(:id, "gridActivities").rows(:class, /Activity/).last.html
  end


  def restaurant_transaction(res_number)
    go_to()
    @driver.link(:id, "DescriptionName_#{$RUNTIME_STORAGE["reso_resid_erbreso_#{res_number}"]}").parent.parent.html
  end

  def cancel_all_reservations(user_email, password)
    if !no_existing_reservation?
      until (@driver.imgs(:src, /btn_c\.gif/).length == 0) do
        @driver.imgs(:src, /btn_c\.gif/)[0].click
        if (@driver.url.to_s.include?("login.aspx")&& driver.ul(:id, "ResoDetails_ReservationInformation").exists?)
          @login = Login.new(@driver, @domain)
          @login.set("Email", user_email)
          @login.set("Password", password)
          @login.click("Sign In")
        end
        @driver.wait_until(90, "page on found") { @driver.url.include? "cancel.aspx" }
        @driver.button(:name, "btnCancelReso").click
        @driver.goto("http://#{@domain}/myprofile.aspx")
      end
    else
      puts "there are no existing reservation"
    end
  end

  def no_existing_reservation?
     @driver.div(:class, "UserReservations None").exist?
  end

  def get_view_link
    view_link = @driver.element(:css, "div.V > a") if @driver.element(:css, "div.V > a").exists?
    return view_link
  end


  def click_on_reso_view
    if !no_existing_reservation?
      get_view_link.click
    end
    @driver.wait_until(90, "not able to navigate to view page") { @driver.url.include? "view" }
  end


  def get_change_link
    change_link = @driver.element(:css, "div.M > a") if @driver.element(:css, "div.M > a").exists?
    return change_link
  end

  def click_on_reso_modify
    if !no_existing_reservation?
      get_change_link.click
    end
    @driver.wait_until(90, "not able to navigate to change page") { @driver.url.include? "change" }
  end

  def get_cancel_link
    cancel_link = @driver.element(:css, "div.C > a") if @driver.element(:css, "div.C > a").exists?
    return change_link
  end

  def click_on_reso_cancel
    if !no_existing_reservation?
      get_cancel_link.click
    end
    @driver.wait_until(90, "not able to navigate to Cancel page") { @driver.url.include? "Cancel" }

  end

  def get_account_details_link
    @driver.element("Account Details")
  end

  def get_email_preference_link
    @driver.element(:id, 'TabNav_btnEmailPreferences')
  end

  def get_favorites_link
    @driver.element(:id, 'TabNav_btnFavorites')
  end

end