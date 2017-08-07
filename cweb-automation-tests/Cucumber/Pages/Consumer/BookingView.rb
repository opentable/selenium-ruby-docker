# encoding: UTF-8
class BookingView < ConsumerBasePage

  def self.page_name
    "BookingView"
  end

  def self.page_url_match?(url)
    url.include?("/book/view") || ((url.match /book\/..*\/view/) && (!url.match /book\/wait-list\/view/))
  end

  attr_accessor :driver, :resid
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)

    $RESERVATION["conf_number"] = conf_number
    $RESERVATION["resid_encrypted"] = resid_encrypted
    $RESTAURANT['name'] = restaurant_name
    $RESERVATION["points"]= points
    $RESERVATION["en-GB"]= en_gb
    $RESERVATION["isRestref"]= set_reso_type
  end

  def init_elements
    @page_elements = {
        "Cancel" => "element_css;#cancel-btn",
        "Modify" => "element_css;#modify-btn",
        "Confirmation Number" => "h5_id;confirmationNumber",
        "Reso Party Size" =>  "element_css;.reservation-block-li.party-size>h4",
        "Reso Date Medium" => "element_css;.show-for-medium-only",
        "Reso Date Large" => "element_css;.show-for-desktop-only",
        "Reso Date XLarge" => "element_css;.show-for-xldesktop-only",
        "Reso Time" => "h4_id;reso-time",
        "Exact Time Slot" => "element_css;.timeslot.exact.rest-row-times-btn",
        "Restaurant Name" => "element_xpath;//*[@id='reservation-info']/div[1]/ul/li[5]/h4/a",
        "Reso Points" => "element_css;.column.medium-4.padding-bottom>p",
        "Reservation Page Header" => "h1_class;page-header-title",
        "Email Guest" => "link_id;ctl05_ReservationModification_ctl00_linkEmailGuest",
    }
    @page_elements
  end

  protected :init_elements

  def cancel_reservation(*args)
    get_element("Cancel").click if get_element("Cancel",30).present?
    BookingCancel.new(@driver).cancel_reservation()
  end

  # return confirmation number
  def conf_number
    # The sign up for Opentable profile is a frame of view.aspx.  When this frame pops up, the confirmation number is not visible until
    # the "No, Thank you" link is clicked or the diner signs in.
    if !(get_element("Confirmation Number").nil?)
      return get_element("Confirmation Number").text[/\d+/].to_i
    end
    return 0
  end

  # return resid
  def resid_encrypted
    get_element("Cancel").attribute_value("href").scan(/&token=(.*)/)[0][0].to_s if get_element("Cancel").exists?
  end

  def restaurant_name
    if !(get_element("Restaurant Name",1).nil?)
      get_element("Restaurant Name").text
    end
  end

  def points #extracts points from hidden text.
    if @driver.span(:id, "ResoDetails_lblPoints").exists?
      if $domain.www_domain_selector == "www.opentable.com.mx"
        points= @driver.execute_script("return document.getElementById('ResoDetails_lblPoints').innerHTML").split(" Puntos")[0].to_s
      else
        points= @driver.execute_script("return document.getElementById('ResoDetails_lblPoints').innerHTML").split(" points")[0].to_s
      end
      puts points
      if points.include? ">"
        points= points.split(">")[1].to_s
        if points.include? " puntos"
          points = points.split(" puntos")[0].to_s
        end
      end
    else
      points="0"
    end
    puts points
    points
  end

  def en_gb
    @driver.url.include? "en-GB"
  end

  def set_reso_type
    #verify first time cookies to set the resotype  is restref
    # ftc=@driver.driver.manage.cookie_named("ftc")
    cookies=@driver.driver.manage.all_cookies
    isWhitelabel=false
    cookies.each { |c|
      if (c[:value].include? "restref")
        isWhitelabel=true
      end
    }
    isWhitelabel
  end

  def click_modify_link
    if get_element("Modify",5).present?
      get_element("Modify").click
    else
      raise Exception, "Unable to find webElement: #{get_element("Modify").class}"
    end
    @driver.wait_until(30, "not able to navigate to change page") { (@driver.url.include? "/book/view") or (@driver.url.match /book\/..*\/view/) }
  end

  def click_cancel_link
    if get_element("Cancel",5).exists?
      get_element("Cancel").click
    else
      raise Exception, "Unable to find webElement #{get_element("Cancel").class}"
    end
    @driver.wait_until(30, "not able to navigate to change page") { @driver.url.include? "Cancel" }
  end

  def click_time_slot
    @driver.wait_until(90, "Spinner is still spinning after 90 secs"){!@driver.div(:class,"spinner").present?}
    begin
      @driver.div(:class,"buttons-panel").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
      #This function failed in TeamCity with a StaleElementReferenceError.  So putting a try/catch to capture it
      @driver.wait_until(60, "Unable to find timeslot to click") {get_element("Exact Time Slot").present?}
    rescue Exception => e
      raise Exception, "Failed to click => #{e}"
    # rescue Exception::StaleElementReferenceError
    #   @driver.refresh
    #   puts "Caught a StaleElementReferenceError accessing #{get_element('Exact Time Slot')}"
    end

    get_element("Exact Time Slot").click
    @driver.wait_until(60, "Expecting /book/details page but found #{@driver.url} instead") { (@driver.url.include? "/book/details") || (@driver.url.match /book\/..*\/details/) }
  end

  def verify_reservation_details(object)
    verify_reservation_date($RESERVATION["date_searched"])
    verify_reservation_time($RESERVATION["time_searched"])
    verify_reservation_party_size($RESERVATION["party_size_searched"])
  end

  def verify_reservation_date(date)
    displayed_date = ""
    searched_date = ""

    @driver.wait_until(20,"Can't find Reservation date: #{date}") {get_element("Reso Date Large").present? ||
        get_element("Reso Date XLarge").present? || get_element("Reso Date Medium").present?}

    browser_width = @driver.execute_script("return window.innerWidth")

    if (get_element("Reso Date Large").present?) && (browser_width >= $large_lower_width && browser_width <= $large_upper_width)
    displayed_date = get_element("Reso Date Large").text
    searched_date = large_date_format(date)
    elsif get_element("Reso Date XLarge").present? && browser_width >= $xlarge_lower_width
      displayed_date = get_element("Reso Date XLarge").text
      searched_date   = long_date_format(date)
    elsif get_element("Reso Date Medium").present? && (browser_width >= $medium_lower_width && browser_width < $large_lower_width)
      displayed_date = get_element("Reso Date Medium").text
      searched_date = medium_date_format(date)
    else
      raise Exception, "Reservation date not found in Views page"
    end

    # There are a lot of inconsistencies on how dates are displayed with periods so just remove them before comparison
    displayed_date.gsub!(/\./,'') if displayed_date.include? "."
    searched_date.gsub!(/\./,'') if searched_date.include? "."


    if !displayed_date.downcase.include? searched_date.downcase
      raise Exception, "Wrong Reservation date #{displayed_date} is displayed on view page instead of #{searched_date}!"
    end
  end

  def verify_reservation_time(time)
    @driver.wait_until(20,"Can't find Reservation time: #{time}") {get_element("Reso Time").exists?}
    if get_element("Reso Time").text != ""
      displayed_time = get_element("Reso Time").text
    else
      raise Exception, "Reservation time not found in Views Page"
    end

    ##JP/en-US uses 24hr time format to select the time but displays 12hr format
    time = Time.parse(time).strftime("%l:%M %P") if (($domain.www_domain_selector.downcase.include? "jp/en-") || ($domain.www_domain_selector.downcase.include? "com.au"))

    #fr-ca needs HH:MM in the start page dropdown selection but displays in the view page as H:MM
    time = time.sub(/^0/,'') unless !($domain.www_domain_selector.downcase.include? "fr-ca") && !($domain.www_domain_selector.include? "ie") && !($domain.www_domain_selector.include? "co.uk") && !($domain.www_domain_selector.include? "de") && !($domain.www_domain_selector.include? ".com") && !($domain.www_domain_selector.include? ".jp")

    #This is a workaround for .com.mx where time is represented as upper case in the dropdown when
    #making a reso and lowercase with periods p.m. in the view page
    if !displayed_time.downcase.gsub(/\./,'').include? time.strip.downcase
      raise Exception, %{Wrong Reservation Time #{displayed_time} is displayed on view page instead of #{time}!}
    end
  end

  def verify_reservation_party_size(ps=2)
    if ps.nil?
      ps = 2
    end
    # party_size = format_party_size(ps, "for ps")
    @driver.wait_until(20,"Can't find Reservation party size: #{ps}") {get_element("Reso Party Size").exists? }
    if get_element("Reso Party Size").text != ""
      displayed_party_size = get_element("Reso Party Size").text
    else
      raise Exception, "Party size not found in Views Page"
    end

    people_format = format_party_size(ps, "people")
    party_of_format = format_party_size(ps,"Party of")

    if !((displayed_party_size.downcase.include? people_format.downcase) || (displayed_party_size.downcase.include? party_of_format.downcase) ||(displayed_party_size.downcase.include? ps) )
      raise Exception, "Wrong Reservation party size #{displayed_party_size} is displayed on view page instead of #{people_format} or #{party_of_format}!"
    end
  end

  def convert_user
    @driver.wait_until(90, "Spinner is still spinning after 60 secs"){!@driver.div(:class,"spinner").present?}

    convertuser_frame = @driver.div(:class, "modal-content-body").frame
    @driver.wait_until(30,"Convert User pop up not found"){convertuser_frame.input(:id, "Password").present?}
    convertuser_frame.input(:id, "Password").send_keys("password")
    convertuser_frame.input(:id, "Password2").send_keys("password")
    raise Exception, "Continue Button not visible" unless convertuser_frame.button(:class, "button").present?
    convertuser_frame.button(:class, "button").click

  end

  def get_ccard_last_4numbers
    isIEAU = $domain.domain
    if(isIEAU.eql?"IE" or isIEAU.eql?"COM.AU" )
      puts "Credit card number NOT VISIBLE..May be it is an Irish/Aussie thing..  "
    end
    #     if !(get_element("Credit Card 4Digits").present?)then
    #    puts "Credit card number NOT VISIBLE..May be it is an Irish/Aussie thing..  "
    # end
  end

  def verify_credit_card_number(cc_num)
    raise Exception, "Credit card number is missing" unless get_element("Credit Card 4Digits").exists?
    raise Exception, "Last 4 digits of Credit Card number not matching on the view page.  Actual CC: #{get_element("Credit Card 4Digits").text.last(4)} Expected CC: #{cc_num.last(4)}" unless get_element("Credit Card 4Digits").text.last(4) == cc_num.last(4)
  end

  def verify_user_name (fname, lname)
    conf_text = get_element("Reservation Page Header").text
    raise Exception, "user name is not present in the conf text" unless conf_text.downcase.include? fname.downcase or conf_text.downcase.include? lname.downcase
  end

  def verify_points (points)
    #verify expected points
    if (!get_element("Reso Points").nil?)
      actual_msg = get_element("Reso Points").text
      puts "Reso Points mesg: #{actual_msg}"
      raise Exception, "Expected message #{points} Actual message: #{actual_msg}" unless (points.force_encoding('UTF-8')).gsub(' ', '').include? actual_msg.gsub(' ','')
    else
      puts "No Reservation points message element in Booking/View page"
    end
  end
end