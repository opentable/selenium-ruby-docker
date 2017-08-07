class BookingRestaurantProfile < ConsumerBasePage

  def self.page_name
    "BookingRestaurantProfile"
  end

  def self.page_url_match? (url)
    url.include?("-reservations-") and url.include?("?restref=") || url.include?("restaurant/profile") and url.include?("/reserve/?restref=")

  end

  def initialize(browser, rid = nil)
    @driver = browser
    init_elements
    super(@driver, @page_elements)
  end

  def init_elements
    @page_elements = {
        "Search Results Module" => "ul_class;dtp-results-times",
    }
  end

  def click_time_slot(time, days_fwd)
    time_slot = check_time_slot_showing(time, days_fwd)
    @driver.wait_until(60, "Spinner is still spinning after 90 secs"){!@driver.div(:class,"spinner").present?}
    @driver.wait_until(5, "Timeslot is not visible"){time_slot.present?}
    time_slot.click
    @driver.wait_until(30, "Expecting booking details.aspx page but got #{@driver.url} instead") { @driver.url.include? "details" }
  end

  def check_time_slot_showing(time, days_fwd)
    get_element("Search Results Module", 30)
    s_date = get_date_based_on_time_zone(days_fwd.to_i).strftime("%Y-%m-%d")
    time = DateTime.parse(time).strftime("%H:%M")
    time_slot = $driver.element(:xpath, "//*[@id='dtp-results']/div/ul/li[3]/a[@data-datetime='#{s_date} #{time}']")
    @driver.wait_until(60, "Failed to find time slot #{time} for #{s_date}") {time_slot.present?}
    return time_slot
  end

  def click_first_available_POP_time_slot
    @driver.wait_until(60, "Spinner is still spinning after 90 secs"){!@driver.div(:class,"spinner").present?}
    search_results_module = get_element("Search Results Module", 30)
    search_results_module.lis.each do |li|
      if li.html.include? "dtp-button button js-with-offers"
        $RESERVATION["time_searched"] = li.link.text
        li.link.click
        break
      end
    end
    @driver.wait_until(30, "Expecting booking details.aspx page but got #{@driver.url} instead") { @driver.url.include? "details" }
  end
end