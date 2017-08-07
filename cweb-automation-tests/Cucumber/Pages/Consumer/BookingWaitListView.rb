# Encoding: utf-8
class BookingWaitListView < ConsumerBasePage

  def self.page_name
    "BookingWaitListView"
  end

  def self.page_url_match?(url)
    url.include? ("/book/wait-list/view")
  end

  attr_accessor :driver, :resid
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)

    $RESERVATION["conf_number"] = conf_number
    $RESERVATION["securityToken"] = security_token
  end

  def init_elements
    @page_elements = {
        "Waitlist header" => "element_css;.page-header-title",
        "Confirmation Number" => "element_css;h5.color-light",
        "Sms alert message" => "element_css;.sms-alert.content-block>p",
        "Reso Party Size" =>  "element_css;.reservation-block-li.party-size>h4",
        "Reso Date" => "element_css;.reservation-block-li.date>h4",
        "Leave Waitlist" => "element_css;.cancel.button.type-2",
        "Exact Time Slot" => "element_css;.timeslot.exact.rest-row-times-btn",
        "Current User Position" => "element_css;.current-user>div",
        "Current User Name" => "element_css;.current-user>p>span.name",
        "Current User Party Size" => "element_css;.current-user>p>span.description",
    }
    @page_elements
  end

  protected :init_elements

  # return confirmation number
  def conf_number
    # The sign up for Opentable profile is a frame of view.aspx.  When this frame pops up, the confirmation number is not visible until
    # the "No, Thank you" link is clicked or the diner signs in.
    if !(get_element("Confirmation Number").nil?)
      return get_element("Confirmation Number").text[/\d+/].to_i
    end
    return 0
  end

  # return security_token
  def security_token
    securityToken = get_element("Leave Waitlist",10).attribute_value("href").scan(/&token=(.*)/)[0][0].to_s if get_element("Leave Waitlist").exists?
    securityToken.gsub!(/&restref=\d{3,}/,"")
    securityToken.gsub!(/&reso=\d{1,}/,"")
    puts "SecurityToken=>#{securityToken}"
  end

  def leave_waitlist(dinerno)
    if get_element("Leave Waitlist",5).present?
      get_element("Leave Waitlist").click
    else
      raise Exception, "Unable to find webElement #{get_element("Leave Waitlist").class}"
    end
    @driver.wait_until(30, "not able to navigate to change page") { @driver.url.include? "/book/wait-list/cancel" }
    BookingWaitListCancel.new(@driver).leave_reservation()
    $RUNTIME_STORAGE["wishlistdiner_#{dinerno.to_i - 1 }"]['isCancelled'] = true
  end

  def verify_reservation_details(object)
    puts "Waitlist verify_reservation_details"
    verify_waitlist_header_title
    verify_sms_msg
    verify_reservation_party_size($RESERVATION["party_size"])
    verify_reservation_date
    verify_waitlist_position
  end

  def verify_waitlist_header_title
    puts "Wishlist header: #{get_element("Waitlist header").text}"
    raise Exception, "Actual header title: #{get_element("Waitlist header").text}  Expected first name #{$USER['fname']} and Queue number: #{$RESERVATION['wait_list_queue']}}" if (!get_element("Waitlist header").text.downcase.include? $USER['fname'].downcase) || (!get_element("Waitlist header").text.downcase.include? $RESERVATION['wait_list_queue'].downcase)
  end

  def verify_sms_msg
    puts "SMS message header: #{get_element("Sms alert message").text}"
    phone_regex = /(\d{3})(\d{3})(\d{4})/
    m = phone_regex.match($USER['phone'])
    if m.nil?
      expected_phone = $USER['phone']
    else
      expected_phone = "(#{m.captures[0]}) #{m.captures[1]}-#{m.captures[2]}"
    end

    puts "Phone=> #{expected_phone}"
    raise Exception, "Actual sms title: #{get_element("Sms alert message").text}  Expected phone number: #{expected_phone}" if (!get_element("Sms alert message").text.downcase.include? expected_phone)
  end

  def verify_reservation_date
    @driver.wait_until(20,"Can't find Reservation date of Today") {get_element("Reso Date").present?}
    raise Exception, "Wrong Reservation date #{get_element("Reso Date").text} is displayed on Waitlist view page instead of Today!" if (!get_element("Reso Date").text.downcase.include? "today")
  end

  def verify_reservation_party_size(party_size)
      puts "Guests party size: #{get_element("Reso Party Size").text}"
      raise Exception, "Actual Guest is #{get_element("Reso Party Size").text}  Expected Waitlist Guest is #{party_size}" unless party_size.downcase.include? get_element("Reso Party Size").text.downcase
    end

  def verify_user_name (fname, lname)
    conf_text = get_element("Reservation Page Header").text
    raise Exception, "user name is not present in the conf text" unless conf_text.downcase.include? fname.downcase or conf_text.downcase.include? lname.downcase
  end

  def verify_waitlist_position
    ###Apparently the waitlist panel refreshes itself every 5 secs so we have to catch the StaleElement Exception and
    ###try again.
    try = 0
    begin
      @driver.wait_until(30, "Unable to Current User Position") {get_element("Current User Position").present?}
      actual_position = get_element("Current User Position").text
      actual_name = get_element("Current User Name").text
      actual_party_size = get_element("Current User Party Size").text
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      try += 1
      puts "Caught a StaleElementReferenceError accessing Waitlist diner's current position attempt #{try}"
      sleep 1
      retry unless try > 2
    end

    expected_postion = $RESERVATION['wait_list_queue']
    expected_postion = "1" if $RESERVATION['wait_list_queue'].include? "first in line"
    puts "Current position: #{actual_position}"
    raise Exception, "Actual Position is #{actual_position}  Expected Waitlist position is #{expected_postion}" unless expected_postion.include? actual_position

    expected_name = "#{$USER['fname']} #{$USER['lname'][0]}."
    puts "Current name: #{actual_name}"
    raise Exception, "Actual Name is #{actual_name}  Expected Waitlist Diner's Name is #{expected_name}" unless expected_name.downcase.include? actual_name.downcase

    expected_party_size = $RESERVATION['party_size'][/\d+/]
    puts "Current party size: #{actual_party_size}"
    raise Exception, "Actual Position is #{actual_party_size}  Expected Waitlist position is #{expected_party_size}" unless actual_party_size.include? expected_party_size
  end
end