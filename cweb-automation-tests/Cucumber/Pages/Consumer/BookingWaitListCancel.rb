class BookingWaitListCancel < ConsumerBasePage

  def self.page_name
    "BookingWaitListCancel"
  end

  def self.page_url_match?(url)
    url.include?("/book/wait-list/cancel")
  end


  attr_accessor :driver
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(browser, init_elements)
  end


  def init_elements
    @page_elements = {
        "Leave" => "button_id;btn-cancel",
        "Find another table" => "element_css;#btn-home",
    }
    @page_elements
  end

  protected :init_elements

  def leave_reservation(*args)
    @driver.wait_until(60, "Unable to find Leave Reservation button") {get_element("Leave").present?}
    get_element("Leave").click
    @driver.wait_until(60, "Spinner is still spinning after 60 secs"){!@driver.div(:class,"spinner").present?}
    @driver.wait_until(30, "Not in the We've canceled your reservation page"){get_element("Find another table").present?}
  end
end
