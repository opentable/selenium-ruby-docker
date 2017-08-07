class BookingCancel < ConsumerBasePage

  def self.page_name
    "BookingCancel"
  end

  def self.page_url_match?(url)
    url.include?("/book/cancel") || ((url.match /book\/..*\/cancel/) && ( !url.match /book\/wait-list\/cancel/))
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
        "Cancel Reservation" => {
            "1" => "button_id;btn-cancel",
            "2" => "element_css;#cancelAction",
        },
        "Find a New Reservation" => {
          "1" => "element_css;#btn-home",
          "2" => "element_css;#homeAction",
        }
    }
    @page_elements
  end

  protected :init_elements

  def cancel_reservation(*args)
    @driver.wait_until(30, "Unable to find Cancel Reservation button") {get_element("Cancel Reservation").present?}
    ## There seems to be a timing issue when canceling a reso in Prod.  Wait for a sec before moving forward
    sleep(1) if ENV['TEST_ENVIRONMENT'].downcase.eql? "prod"
    ##This is a workaround to a timing issue where clicking of the Cancel Reservation button doesn't seem to take
    try = 0
    until get_element("Find a New Reservation",10).present?
      puts "cancel try==> #{try}"
      if get_element("Cancel Reservation").present?
        get_element("Cancel Reservation").click
        @driver.wait_until(60, "Spinner is still spinning after 60 secs"){!@driver.div(:class,"spinner").present?}
      end
      try+=1
      break if get_element("Find a New Reservation").present?
      if try > 5
        ##If Cancel didn't work after 5 tries, remove the reso via api and raise an exception
        @reservation ||= ReservationServiceV2.new()
        @reservation.reso_cancel()
        raise Exception, "Not in We've canceled your reservation page"
      end
    end
  end

end
