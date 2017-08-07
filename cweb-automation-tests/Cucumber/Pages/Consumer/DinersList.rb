class DinersList < ConsumerBasePage

  def self.page_name
    "DinersList"
  end

  attr_accessor :driver
  attr_reader :page_elements

  # @ToDo: Add domain as property of this page class
  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Upper Right X Icon" => "element_css;.close-overlay>i",
        "Add" => "element_css;.button.secondary.right",
        "Edit" => "element_css;.icon-edit",
        "Cancel" => "element_css;.button.secondary.left.cancel-edit",
        "Save" => "element_css;.button.secondary.right",
        "Remove Icon" => "element_css;..icon-close",
        "Cancel Remove" => "element_css;.button.type-2.left",
        "Confirm Remove Diner" => "element_css;.button.right",
        "Diner First" => "element_css;.column.medium-6.diner-first-name>input",
        "Diner Last" => "element_css;.column.medium-6.diner-last-name>input",
        "Kana Diner First" => "element_css;.column.medium-6.diner-sortable-first-name",
        "Kana Diner Last" => "element_css;.column.medium-6.diner-sortable-last-name",
        "Diner Name" => "element_css;.diner-name",
        # "Foreign" => "link_id;linkForeign"
    }
    # if @driver.driver.inspect.include?("internet_explorer")
    #   @page_elements["Return to Reservation"] = "image_src;/img/buttons/but_returntoreservation.gif"
    # end
    @page_elements
  end

  protected :init_elements

  def complete_reservation
    click("Complete Free Reservation")
  end

  def add_diner(fname, lname)
    puts "fname: #{fname}  lname: #{lname}"
    get_element("Diner First").send_keys(fname)
    get_element("Diner Last").send_keys(lname)
    get_element("Add").click
  end

  def close_diners_list
    get_element("Upper Right X Icon").click
  end

  def check_diner_name(fname, lname)
    @driver.wait_until(20,"Add Diner failed") {get_element("Edit").present?}
    fullname = "#{fname} #{lname}"
    fullname = "#{lname} #{fname}" if $domain.www_domain_selector == "www.opentable.jp"
    Raise Exception("Diner #{fname} #{lname} not found!") if !get_element("Diner Name").text.include? fullname
  end

end
