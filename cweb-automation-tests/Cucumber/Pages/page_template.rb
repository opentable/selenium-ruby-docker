class PageName < WebBasePage

  def self.page_name 
    "pagename.aspx"
  end

  attr_reader :driver, :page_elements

  def initialize(browser)
    @driver = browser
    init_elements
    super(@driver, @page_elements)
  end

  def init_elements
    @page_elements = {
    }
  end

  protected :init_elements

end