class SingleRest < ConsumerBasePage

  def self.page_name
    "singlerest.aspx"
  end

  def self.page_url_match?(url)
    super(url) and !url.include? "/frontdoor"
  end

  attr_accessor :rid, :domain
  attr_reader :driver, :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Restaurant" => "select_list_name;RestaurantID",
        "Party Size" => "select_list_name;PartySize",
        "Calendar" => "text_field_id;startDate",
        "Time" => "select_list_name;ResTime",
        "Submit" => "button_id;submit"
    }
    @page_elements
  end

  protected :init_elements

  # visits page
  def go_to()
    visit("http://#{@domain}/#{self.class.page_name}?rid=#{@rid}")
  end

end