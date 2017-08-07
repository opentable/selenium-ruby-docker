class CsFrame < ConsumerBasePage

  def self.page_name 
 "cs_frame.asp" 
 end
  def self.page_url_match? (url)
    super(url) or url.match /#{product_name}\..*\/cs_(\w+?).asp/i
      #url.include?"cs_default.asp" or url.include?"cs_single.asp" or url.include?"cs_confirm.asp" or url.include?"cs_cancel.asp"
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
        "Rid" => "text_field_name;Rid",
        "Metro ID" => "text_field_name;g",
        "First Name" => "text_field_name;FirstName",
        "Last Name" => "text_field_name;LastName",
        "Party Size" => "text_field_name;PartySize",
        "Date" => "text_field_name;ResDate",
        "Submit" => "button_name;Submit",
        "Reserve" => "button_id;submit2",
        "Cancel Reservation" => "link_text;Cancel Reservation"

    }
  end

  protected :init_elements


  def get_element(friendly_name, timeout_in_seconds = 5, context ="@driver.frame(:name, 'MainApp')")
    if (friendly_name == "Reserve" || friendly_name =="Cancel Reservation")
      super(friendly_name, timeout_in_seconds, "@driver.frame(:name, 'PrimaryNav')")
    else
      super(friendly_name, timeout_in_seconds, context)
    end
  end

  def set_datetime(days_fwd)
    @driver.wait_until(10, "cs_frame.asp page not found") {get_element("Submit").present?}
    new_date = self.get_date_based_on_time_zone(days_fwd.to_i)
    sdate =  new_date.strftime "%-m/%-d/%Y %l:00:00 PM"
    self.set("Date",sdate)
  end

  def verify_time

    # get time searched for from date field
    s_search = get_element("Date").value
    s_search_dt = s_search.sub(/\s+/,' ')
    # verify exact time searched for is selected
    if (!@driver.frame(:name, "PrimaryNav").radio(:value, /#{s_search_dt}/).exists?)
      raise Exception, "search for #{s_search_dt} did not return results!"
    end

    if (!@driver.frame(:name, "PrimaryNav").radio(:value, /#{s_search_dt}/).set?)
      raise Exception, "exact search time is not selected be default!"
    end

  end

  def verify_msg

    # get search information
    s_search_dt = get_element("Date").value
    dt = DateTime.strptime(s_search_dt, "%m/%d/%Y %T %p")
    hour = dt.strftime("%I").to_s.to_i

    s_search_dt = dt.strftime("%A, %B %d, %Y #{hour}:%M %p").to_s
    s_party_sz = @driver.frame(:name, "MainApp").select(:name, "PartySize").value
    s_diner_full_name = get_element("First Name").value + " " + get_element("Last Name").value

    begin

      if !@driver.frame(:name, "PrimaryNav").body(:index, 0).text.include? s_search_dt
        raise Exception, "did not find #{s_search_dt} in reservation confirmation message!"
      end

      if !@driver.frame(:name, "PrimaryNav").body(:index, 0).text.include? "Party of #{s_party_sz}"
        raise Exception, "did not find correct party size #{s_party_sz} in reservation message!"
      end

      if !@driver.frame(:name, "PrimaryNav").body(:index, 0).text.include? "Under the name of #{s_diner_full_name}"
        raise Exception, "did not find diner name #{s_diner_full_name} in reservation message!"
      end
    rescue Exception => e
      cancel_reservation
      raise Exception, e.message
    end
  end

  def cancel_reservation(*args)
    click("Cancel Reservation")
  end

  def text
    sleep 2
    page_text = ""

    @driver.frames.each { |f| page_text += f.body.text }
    page_text
  end

  def click(friendly_name)
    @driver.wait_until(5, "Element: #{friendly_name} Not found") {get_element(friendly_name).present?}
    get_element(friendly_name).click
    if friendly_name == "Submit"
      #After hitting the Submit, just wait for the results to load first.
      @driver.wait_until(5,"No secondary search results") {@driver.frame(:name, "SecondaryNav").form(:id, "multi").present?}
    elsif friendly_name == "Reserve"
      raise Exception, "The reservation no longer exists" if !get_element("Cancel Reservation").present?
    end
  end

end