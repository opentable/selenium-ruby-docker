class RedemptionComplete < ConsumerBasePage

  def self.page_name
    "/Redemption/Complete" || "/Redemption/AmazonComplete"
  end

  def self.page_url_match?(url)
    (url.include?("/Redemption/Complete")) || (url.include?("/Redemption/AmazonComplete"))
  end

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
    # self.go_to()
  end

  def init_elements
    @page_elements = {
      "Redeem Success Banner" => "element_css;.content-block-header>h3",
      "New Total Value" => "div_class;header-reservation-points",
      "Book A Table" => "element_css;.button"
    }
  end

  def go_to()
    if !@driver.url.include? self.class.page_name
      @driver.goto("http://my.#{$domain.charm_domain_selector}/#{self.class.page_name}")
    end
  end


  def check_new_points()
    if !get_element("New Total Value").text.gsub(/,/,"").include? $TOTAL_POINTS.to_s
      raise Exception, "Expected Total value: #{$TOTAL_POINTS}, Actual: #{get_element("New Total Value").text}"
    end
  end

  def check_success_banner(msg)
    @driver.wait_until(120, "Redeem Success Banner not found") {get_element("Redeem Success Banner").present?}
    if !get_element("Redeem Success Banner").text.downcase.include? msg.downcase
      raise Exception, "Expected Msg: #{msg}, Actual msg: #{get_element("Redeem Success Banner").text}"
    end
    check_new_points
  end

  def click(friendly_name)
    @driver.wait_until(10, "Element: #{friendly_name} Not found") {get_element(friendly_name).exists?}
    get_element(friendly_name).click
  end
end