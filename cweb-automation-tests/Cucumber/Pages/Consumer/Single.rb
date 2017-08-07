class Single < ConsumerBasePage

  def self.page_name 
    "single.aspx"
  end

  attr_accessor :rid, :domain, :driver
  attr_reader :page_elements

  def self.page_url_match? (url)
    (url.match /#{product_name}(.*?)-reservations-(.*?)/) or (url.match /#{product_name}\..*\/#{page_name}/i) or (url.include?("restaurant/profile") and !url.include?("?rd=10"))
  end

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = Hash.new
    @page_elements
  end

  protected :init_elements

end