# -*- coding: utf-8 -*-
# encoding: utf-8
class BookingDetails < ConsumerBasePage

  def self.page_name
    "BookingDetails"
  end

  def self.page_url_match? (url)
    url.include? ("/book/details")  || ((url.match /book\/..*\/details/) && (!url.match /book\/wait-list\/details/))

  end

  attr_accessor :driver
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    $RESTAURANT['RID'] = restaurant_id
    @elements = {} unless @elements
    @elements = init_elements.merge(@elements)
    super(@driver, @elements)
  end

  def init_elements
    @page_elements = {
        "Complete Reservation" => "button_id;btn-complete",
        "Cancel" => "a_id;cancel-btn",
        "Modify" => "button_id;modify-btn",
        "Phone" => "element_css;input[name='phoneNumber']",
        "Email" => "element_css;input[name='email']",
        "Edit Diner List" => "a_id;manage-diners",
        "Select Diner List" => "select_list_id;dinerId",
        "Diner First Name" => "element_css;#firstName",
        "Diner Last Name" => "element_css;#lastName",
        "Kanji First" =>  "element_css;#firstName",
        "Kanji Last" =>  "element_css;#lastName",
        "Kana First" => "element_css;#katakanaFirstName",
        "Kana Last" =>  "element_css;#katakanaLastName",
        "Name on CC" => "element_css;input[data-credit-card='name-on-card']",
        "Credit Card #" => "element_css;input[data-credit-card='number']",
        "CC_Exp_Month" => "select_list_name;exp-month",
        "CC_Exp_Year" => "select_list_name;exp-year",
        "CVV" =>"element_css;input[data-credit-card='cvc']",
        "Exp. Date Month" => "select_list_id;cboExpMonth",
        "Exp. Date Year" => "select_list_id;cboExpYear",
        "Sign In Link" => {
            "1" => "link_id;ReservationChangeUserLink", #Link next to Already a member in bookingflow details page
            "2" =>"link_id;global_nav_sign_in" #Sign in from menu bar
        },
        "Special Request Notes" => "element_css;textarea[name='specialRequests']",
      }
    @page_elements
  end

  protected :init_elements

  def click_sign_in_link
    get_element("Sign In Link").click
  end

  def login_registered_user
    @driver.wait_until(60, "Waited 60 secs for page to complete") { @driver.execute_script("return window.document.readyState") == "complete" }
    @driver.wait_until(10, "Unable to find Login contents") {@driver.div(:class, "modal-content").exists?}

    if $browser_type == "chrome"
      login_frame = @driver.div(:class, "modal-content-body").frame(:id, "login-iframe")
    elsif $browser_type == "ff"
      login_frame = @driver.div(:class, "modal-content-body").iframe(:id, "login-iframe")
    end

    @driver.wait_until(30,"Login pop up not found"){login_frame.input(:id, "Email").present?}

    ##This is equivalent of Switchto default window
    if get_element("Complete Reservation").exists?
      @driver.execute_script("document.getElementById('login-iframe').contentWindow.document.getElementById('Email').value = \'#{$USER['email']}\'")
      @driver.execute_script("document.getElementById('login-iframe').contentWindow.document.getElementById('Password').value = \'#{$USER['password']}\'")
    end
    login_frame.element(:css, ".button.expand").click

    @driver.wait_until(60, "Waited 60 secs for page to complete") { @driver.execute_script("return window.document.readyState") == "complete" }
  end

  def click_add_diner
    get_element("Edit Diner List").click
  end

  def complete_reservation
    # get_element("Complete Reservation", 15).click
    @driver.wait_until(30, "Complete Reservation button not visible after 30 secs wait") {get_element("Complete Reservation").present?}
    get_element("Complete Reservation").click
    wait_for_spinner_to_complete()
#    @driver.wait_until(90, "Spinner is still spinning after 60 secs"){!@driver.p(:class,"spinner-caption").present?}
    @driver.wait_until(60, "it is not expected page") { (@driver.url.include?("/book/view")) || (@driver.url.include?("convert")) || (!@driver.url.match(/book\/..*\/view/).nil?) }
  end

  def restaurant_id
    url = @driver.url
    rid = url.split("rid=")[1].split("&")[0]
    return rid
  end

  def set_cc_details (cc_no,cc_exp_mm, cc_exp_yy)
    if !get_element("Credit Card #").nil?
      if get_element("Credit Card #").present?
        y_position = self.get_element("Credit Card #").wd.location[:y]
        puts y_position
        #scrolling down to set the cc card
        @driver.execute_script("scroll(0, #{y_position-100})");
        set("Credit Card #", cc_no)

        @driver.execute_script("scroll(0, #{y_position-50})");
        set_exp_month(cc_exp_mm)
        @driver.execute_script("scroll(0, #{y_position-100})");
        set_exp_year(cc_exp_yy)
      else
        raise Exception("Unable to find Credit Card #element")
      end
    else
      puts "Credit Card fields not found"
    end
  end


  def set_cc_detailsCVV (cc_no, cvv, cc_exp_mm, cc_exp_yy)
    get_element("Credit Card #", 5).click
    get_element("Credit Card #", 5).send_keys(cc_no)
    puts "the CC no is #{cc_no}"
    set_exp_month(cc_exp_mm)
    set_exp_year(cc_exp_yy)
    set_CVV(cvv)
  end

  def set_CVV(cvv)
    if(get_element("CVV").present?)then
      get_element("CVV").send_keys(cvv)
    else
      puts "CVV NOT VISIBLE..May be Braintree Restaurant  "
    end
  end

  def set_exp_month (cc_exp_month)
    get_element("CC_Exp_Month").select cc_exp_month.to_i
    #sleep 1
    puts "setting up CC Exp Month: #{cc_exp_month}"
  end

  def set_exp_year (cc_exp_year)
    #sleep 1
    puts "setting up CC Exp Year: #{cc_exp_year}"
    get_element("CC_Exp_Year").select cc_exp_year
  end

  def fill_anonymous_user_info
    set("Diner First Name", "Automation")
    set("Diner Last Name", "Tester")
    set("Email", "#{self.random_email}")
    set("Phone", "4157897485")
  end

  def select_diner_list(fname, lname)
    fullname = "#{fname} #{lname}"
    fullname = "#{lname} #{fname}" if $domain.www_domain_selector == "www.opentable.jp"
    get_element("Select Diner List").option(:text => (fullname)).select
  end

  def fill_details_page_info(isConcierge, fname, lname, email, isSignin, spl_req = nil, firsttime = nil, erb_mail = nil)
    if (!isSignin) && ($USER['IsRegister'] || isConcierge)
      #login on details page
      login(email, "password")
    end
    if !$USER['IsRegister']
      set("Diner First Name", fname)
      set("Diner Last Name", lname)
    end
    if !isConcierge && !$USER['IsRegister']
      set("Email", email)
    end
    set("Phone", "4157897485")
    if (firsttime == 'yes')
      get_element("First Time Diner Yes", 1).click
    end
    if (firsttime == 'no')
      get_element("First Time Diner No", 1).click
    end
    if (erb_mail == 'yes')
      get_element("Rest Event Mail", 1).click
    end
    set("Special Request Notes", spl_req)
  end
end
