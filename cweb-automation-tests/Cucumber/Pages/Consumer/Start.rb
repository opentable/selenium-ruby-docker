class Start < ConsumerBasePage

  def self.page_name
    "start"
  end

  attr_accessor :driver, :metro_id, :domain
  attr_accessor :page_elements
  attr_accessor :page_name

  def initialize(driver, domain = $domain, metro_id = nil)
    @driver = driver
    @domain = domain
    @metro_id = metro_id
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "New Search Box" => "text_field_name;searchText",

    }

    @page_elements

  end

  protected :init_elements

  #visits page
  def go_to()
    @metro_id = 1 if @metro_id.nil?
    if $domain.www_domain_selector.include? "co.uk" or $domain.www_domain_selector.include? "de"
      visit("http://#{$domain.www_domain_selector}/#{self.class.page_name}.aspx?m=#{@metro_id}&forcemode=selectlocation")
    elsif $domain.www_domain_selector.include? "com.mx" or $domain.www_domain_selector.include? "jp" or (ENV['TEST_ENVIRONMENT'] == "Prod")
      visit("http://#{$domain.www_domain_selector}/#{self.class.page_name}.aspx?m=#{@metro_id}")
    else
      visit("http://#{$domain.www_domain_selector}/#{self.class.page_name}/?m=#{$domain.primary_metro_id}")
    end
    @driver.wait_until(60, "Start page not found") { get_element("New Search Box").present? }
  end

  def set_party_sz_on_new_start_page(party_size)
    set_party_sz_on_new_design(party_size)
  end

  def set_location_restaurant_on_new_start_page(name)
    # New Design requires the Restaurant name to be selected from the drop down box
    # Otherwise, clicking on the Find a Table button will force the user back to
    # the location text field

    if get_element("New Search Box", 10).present?
      get_element("New Search Box").send_keys name
      sleep(1)
      get_element("New Search Box").click
      sleep(1)
      get_element("New Search Box").send_keys :arrow_down
      sleep(1)
      get_element("New Search Box").send_keys :tab
    else
      raise(Exception, "Unable to find Restaurant search box")
    end
  end

end
