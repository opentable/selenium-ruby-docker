# encoding: UTF-8
class RestaurantProfile < ConsumerBasePage

  def self.page_name
    "restaurant/profile"
  end

  def self.page_url_match? (url)
    url.include?("restaurant/profile/") and url.include?("?rd=10") and !url.include? "-reservations-" and !url.include? "reserve"
  end

  def initialize(browser, rid = nil)
    @driver = browser
    init_elements
    super(@driver, @page_elements)
  end

  def init_elements
    @page_elements = {
         "Search Results Module" => "ul_class;dtp-results-times list-left",
         "Add to Favorites" => "element_css; div.profile-header-favorite > a > span",
         "WaitList Header" => "h6_class;widget-sub-heading",
         "Join Waitlist Now" => "a_class;button expand waitlist-button",
         "Waitlist Status" => "div_class;waitlist-status",
         "View Waitlist" => "a_class;waitlist-parties-button text-arrow-down-large",
         "Waitlist Queue" => "span_class;description",
       }
  end

  def click_any_availability_time_slot
    raise Exception, "failed to find search results" unless @driver.div(:class, "content-section-body with-padding").present?
    search_results_module = get_element("Search Results Module", 60)
    search_results_module.lis.each do |li|
      if li.html.include? "data-datetime"
        li.link.click
        break
      end
    end
    @driver.wait_until(60, "it is not expected page") { @driver.url.include? "details" }
  end

  def click_anytimeslot(pop = false)
    self.click_any_availability_time_slot
  end

  def check_waitlist_status(exp_queue_size)
    actual_queue_size = get_element("Waitlist Status").text
    raise Exception, "Wishlist status compare failed. Actual=> #{actual_queue_size} Expected=> #{exp_queue_size}" unless actual_queue_size.downcase.include? exp_queue_size.downcase
  end
end