class ProfileInfo < ConsumerBasePage

  def self.page_name
    "profile/info" || "my/Profile"
  end

  def self.page_url_match? (url)
    url.include? page_name
  end


  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
    self.go_to()
  end

  def init_elements
    @page_elements = {
        "Account Details" => "element_xpath;//a[contains(@href,'/Profile/Edit')]",
        "Points" => "div_class;header-reservation-points ng-binding",
        "Dining History Table" => {
            "1" => "element_xpath;//*[@id='reservations-past']/div[5]/div[1]",
            "2" => "table_class;results-table table recentActivitytable", #Defined in Concierge my profile page
        },
        "No Upcoming Reso" => "div_class;reservation none",
        "Redeem Points" => "element_css;div.redeem > a",
        "Reservation History" => "element_css;li.reservationHistory > a",
        "Reso Info" => "element_css;.rest-row-info",
        "View" => "element_css;#rest-item- .rest-row-info .upcoming-res-link.secondary:nth-of-type(1)",
        "Modify" => "element_css;#rest-item- .rest-row-info .upcoming-res-link.secondary:nth-of-type(2)",
        "Cancel" => {
            "1" => "element_css;#rest-item- .rest-row-info .upcoming-res-link.secondary:nth-of-type(3)",
            "2" => "element_css;#rest-item- .rest-row-info .upcoming-res-link.secondary:nth-of-type(2)",
        },
        "Email Preferences" => "element_xpath;//a[contains(@href,'/Profile/EmailPreferences')]",
        "OT Gift Card" => "element_css;div[class|=left][data-ng-show|=hasGiftCard]", # Set for Dining Gifts
        "Amazon Gift Card" => "element_css;div[class|=left][data-ng-show|=hasAmazonCard]",
        "Get your Dining Cheque" => {
            "1" => "element_css;div[class|=left][data-ng-show|=hasAmazonDeCard]",
            "2" => "element_css;div[class|=left][data-ng-show|=hasDiningCheque]",
            "3" => "element_css;div[class|=left][data-ng-show|=hasVisaGiftCard]",
        },
        "Reservation Free Instant Confirmed tagline" => "element_xpath;//*[@id='global_header']/div[1]", #Currently defined in Concierge my profile page
        "View all reservations" => "element_css;.reservation>a"
    }
  end

  def go_to()
    if !@driver.url.include? self.class.page_name
      @driver.goto("http://my.#{$domain.charm_domain_selector}/#{self.class.page_name}")
    end
  end

  def total_user_points
    go_to()
    # ToDo: add to friendly name hash
    points_text = get_element("Points").text
    if points_text.include? ","
      points_text.gsub(/,/, '').to_i
    else
      points_text.gsub(".", '').to_i
    end

  end

  def click(giftType)
    if giftType.downcase.include? "giftcard"
      if ($domain.www_domain_selector.include? "fr-CA") || ($domain.www_domain_selector.include? "co.uk")
        #This is a workaround. The gift card button is defined differently for fr-CA and co.uk than it is for the other domains so there are two definitions.  Selenium is unable to pick
        #the second definition as it will pick the first element which is hidden and so it can't be clicked
        @driver.wait_until(30, "Unable to find Get your Dining Rewards Gift button") {@driver.element(:xpath, "//*[@id='reservation-points']/div[2]/div/div/div/div/div[1]/a[1]").present?}
        @driver.element(:xpath, "//*[@id='reservation-points']/div[2]/div/div/div/div/div[1]/a[1]").click
      else
        @driver.wait_until(30, "Unable to find Get your Dining Rewards Gift button") {get_element("OT Gift Card").present?}
        get_element("OT Gift Card").click
      end
      @driver.wait_until(30, "Unable to see Redemption/GiftCard page") {$driver.url.include? "/Redemption/GiftCard"}
    elsif giftType.downcase.include? "amazoncard"
      @driver.wait_until(30, "Unable to find Get your Amazon Card button") {get_element("Amazon Gift Card").present?}
      get_element("Amazon Gift Card").click
      @driver.wait_until(30, "Unable to see Redemption/AmazonCard page") {$driver.url.include? "/Redemption/AmazonCard"}
    elsif giftType.downcase.include? "get your dining cheque"
      @driver.wait_until(60, "Unable to find Get your Dining Cheque button") {get_element("Get your Dining Cheque").present?}
      get_element("Get your Dining Cheque").click
      @driver.wait_until(30, "Unable to see Redemption page") {($driver.url.include? "redeempoints.aspx") || ($driver.url.include? "\/redeem\/" )}
      puts "I am here"
    else
      raise Exception, "Gift Type not found: #{giftType}"
    end
  end

  def view_all_reservations
    get_element("View all reservations").click if get_element("View all reservations").present?
    @driver.wait_until(30, "Unable to see Upcoming Reso page") {$driver.url.include? "upcomingreso.aspx"}
  end

  def first_restaurant_transaction
    go_to()
    #New Design
    if get_element("Reservation Free Instant Confirmed tagline").nil?
      return get_element("Dining History Table").text if get_element("Dining History Table").visible?
    else
    #Old Design of my profile (Dining cheques)
      dining_history = get_element("Dining History Table") if get_element("Dining History Table").visible?
      row_one = dining_history.rows[1] if dining_history.rows.count > 1 and !dining_history.nil?
      return row_one.html
    end
  end

  def last_restaurant_transaction
    go_to()
    dining_history = get_element("Dining History Table") if get_element("Dining History Table").visible?
    row_count = dining_history.rows.count.to_i
    row_last = dining_history.rows[row_count - 1] if dining_history.rows.count > 1 and !dining_history.nil?
    return row_one.html
  end

  def get_view_link
    ele = @driver
    ele = get_element("Reso Info") unless get_element("Reso Info", 30).nil?
    view_link = ele.link(:href, /&ra=vw/) if @driver.link(:href, /&ra=vw/).exists?
    return view_link
  end


  def click_on_reso_view
    get_element("View").click
    @driver.wait_until(90, "not able to navigate to view page") { @driver.url.include? "view" }
  end


  def get_change_link
    ele = @driver
    ele = @driver.div(:class, 'rest-row-info') unless get_element("Reso Info", 35).nil?
    change_link = ele.link(:href, /&ra=cha/) if ele.link(:href, /&ra=cha/).exists?
    return change_link
  end

  def click_on_reso_modify
    unless no_existing_reservation?
      get_change_link.click
    end
    @driver.wait_until(90, "not able to navigate to change page") { @driver.url.include? "change" }
  end

  def click_on_reso_cancel
    get_element("Cancel").click
    @driver.wait_until(90, "not able to navigate to Cancel page") { @driver.url.include? "Cancel" }
  end

  def no_existing_reservation?
    @driver.div(:class, "reservation none").exists?
  end

  def get_account_details_link
  #   @driver.li(:id, 'accountDetails').link
  get_element("Account Details")
  end

  def get_email_preference_link
    @driver.li(:id, 'emailPreferences').link
  end

  def get_favorites_link
    @driver.li(:id, 'favorites').link
  end


end