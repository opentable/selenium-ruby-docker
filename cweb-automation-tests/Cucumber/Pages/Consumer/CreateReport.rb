class CreateReport < ConsumerBasePage

  def self.page_name 
 "createreport.aspx" 
 end

  # non nl page name
  attr_accessor :rid, :domain
  attr_reader :driver, :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Reservation Details Table" => "table_id;gridDetailedReport",
        "Monthly Reservation Table" => "table_id;gridReport",
        "Restaurant" => "span_id;gridReport_ctl01_lblRestaurant",
        "Reservations" => "span_id;gridReport_ctl01_lblReservations",
        "Covers" => "span_id;gridReport_ctl01_lblCovers",
        "Cancellations" => "span_id;gridReport_ctl01_lblCancellations",
        "No Shows" => "span_id;gridReport_ctl01_lblNoShows",
        "No Show Rate" => "span_id;gridReport_ctl01_lblNoShowRate",
        "Create Report" => "button_id;btnCreateReport",
        "Show Reservation Details" => "button_id;btnDetails"
    }
  end

  protected :init_elements

  def get_number_of_reservations
    get_element("Monthly Reservation Table").rows.last[1].text.to_i +
        get_element("Monthly Reservation Table").rows.last[3].text.to_i +
        get_element("Monthly Reservation Table").rows.last[4].text.to_i+1
  end

end