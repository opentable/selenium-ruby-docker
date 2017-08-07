# -*- coding: utf-8 -*-
# encoding: utf-8
class BookingWaitListDetails < ConsumerBasePage

  def self.page_name
    "BookingWaitListDetails"
  end

  def self.page_url_match? (url)
    url.include? ("/book/wait-list/details")
  end

  attr_accessor :driver
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    # $RESTAURANT['RID'] = restaurant_id
    @elements = {} unless @elements
    @elements = init_elements.merge(@elements)
    super(@driver, @elements)
  end

  def init_elements
    @page_elements = {
        "Commit" => "button_id;btn-complete",
        "Phone" => "element_css;input[name='phoneNumber']",
        "Email" => "element_css;input[name='email']",
        "Diner First Name" => "element_css;#firstName",
        "Diner Last Name" => "element_css;#lastName",
        "Guest Party Size" =>  "element_css;.reservation-block-li.party-size>h4",
        "Guest Date Medium" => "element_css;.show-for-medium-only",
        "Guest Date Large" => "element_css;.show-for-desktop-only",
        "Guest Date XLarge" => "element_css;.show-for-xldesktop-only",
        "Waitlist" => "h4_id;reso-time",
        "Get text updates" => "element_css;.row.show-for-medium-up",
      }
    @page_elements
  end

  protected :init_elements

  def opt_in_text_updates
    if get_element("Get text updates").present?
    script = "return $('.toggle').filter(':visible').children('input[name=\"optInTextUpdates\"]').is(':checked');"
    get_element("Get text updates").click if (@driver.execute_script(script) == false)
    end
  end

  def fill_anonymous_user_info
    $USER['fname'] = "CW-Automation"
    $USER['lname'] = "Tester"
    $USER['email'] = "#{self.random_email}"
    $USER['phone'] = "(999) 123-4567"

    ##This is a work-around as send_keys does not work well on Ubuntu/Chrome Chromev59 - 60, Chromedriver=2.29 - 2.31
    set("Diner First Name", $USER['fname'])
    set("Diner Last Name", $USER['lname'])
    set("Email", $USER['email'])
    set("Phone", $USER['phone'])
  end

  def add_mobile_number
    if (get_element("Phone").value == "")
      $USER['phone'] = "2234567890"
      get_element("Phone").send_keys("2234567890")
    else
      $USER['phone'] = get_element["Phone"].value
    end

  end

  def verify_waitlist_date
    $RESERVATION["date"] = "Today"
    browser_width = @driver.execute_script("return window.innerWidth")

    if (get_element("Guest Date Large").present?) && (browser_width >= $large_lower_width && browser_width <= $large_upper_width)
      displayed_date = get_element("Guest Date Large").text
    elsif get_element("Guest Date XLarge").present? && browser_width >= $xlarge_lower_width
      displayed_date = get_element("Guest Date XLarge").text
    elsif get_element("Guest Date Medium").present? && (browser_width >= $medium_lower_width && browser_width < $large_lower_width)
      displayed_date = get_element("Reso Date Medium").text
    else
      raise Exception, "Reservation date not found in Details page"
    end
    raise Exception, "Waitlist Date is set at #{displayed_date} instead of Today" unless ["today"].include? displayed_date.downcase
  end

  def verify_party_size(party_size)
    $RESERVATION["party_size"] = party_size
    puts "Guests party size: #{get_element("Guest Party Size").text}"
    raise Exception, "Actual Guest is #{get_element("Guest Party Size").text}  Expected Waitlist Guest is #{party_size}" unless party_size.downcase.include? get_element("Guest Party Size").text.downcase
  end

  def verify_waitlist_queue(wait_list_queue)
    $RESERVATION["wait_list_queue"] = wait_list_queue
    puts "Waitlist queue: #{get_element("Waitlist").text}"
    raise Exception, "Actual Wait Queue is: #{get_element("Waitlist").text}  Expected Waitlist Queue is: #{wait_list_queue}" unless wait_list_queue.downcase.include?  get_element("Waitlist").text.downcase
  end

  def complete_reservation
    puts "Waitlist Details complete_reservation module"
    get_element("Commit").click
    @driver.wait_until(60, "Spinner is still spinning after 60 secs"){!@driver.div(:class,"spinner").present?}
    @driver.wait_until(60, "Not in /book/wish-list/view page") { @driver.url.include? "/book/wait-list/view" }
  end
end