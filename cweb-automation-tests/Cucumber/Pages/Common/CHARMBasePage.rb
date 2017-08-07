class CHARMBasePage < WebBasePage

  attr_accessor :driver
  attr_reader :elements

  def self.page_name
    "base_page"
  end

  def self.product_name
    "charm"
  end

  def self.page_url_match? (url)
    if ENV['TEST_ENVIRONMENT'].eql? "Prod"
      url.match /http:\/\/#{product_name}(.|-)(\w+)\.(\w+?)\..*\/#{page_name}/i
    else
      super
    end
  end


  def go_to()
    @driver.goto("http://#{charm_address}/#{self.class.page_name}")
  end

  def charm_address
    $domain.charm_address
  end

  def initialize(browser, elements)
    @driver = browser

    # initialize base elements hash
    @elements = base_elements
    @elements = @elements.merge(elements)
    super(@driver, @elements)
  end

  def base_elements
    @elements = {
        "Restaurant Info" => "link_text;Restaurant Info",
        "Reports" => "link_text;Reports",
        "User Info" => "link_text;User Info",
        "Update Holidays" => "link_text;Update Holidays",
        "Internal Resources" => "link_text;Internal Resources",
        "Update Emails" => "link_text;Update Emails"
    }
    @elements
  end

  protected :base_elements

  def select(name, item)
    if !(name.downcase == "domain" && item == "OpenTable.jp")
      get_element(name).select(item)
    end
  end
end
