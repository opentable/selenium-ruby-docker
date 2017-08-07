class Diprogram < ConsumerBasePage

  def self.page_name 
 "diprogram"
 end

  attr_accessor :driver, :domain, :metro_id
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def go_to()
    puts "In diprogram --> Goto"
    visit("http://#{@domain}/#{self.class.page_name}?m=#{@metro_id}")
  end

  def init_elements

    @page_elements = {
        "Find a Table" => "link_class;universalButton findatable",

    }

  end
end