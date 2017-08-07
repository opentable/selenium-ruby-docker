# Encoding: utf-8
class Opentables_newdesign < ConsumerBasePage

  def self.page_name
    "Opentables_newdesign"
  end

  def self.page_url_match?(url)
    page_match = "s\\/\\?datetime"
    url.match /#{product_name}\..*\/#{page_match}/i and !url.include? "/irp"
  end

  attr_accessor :driver
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
    @driver.execute_script("if (document.getElementById('FloatingFooterAdContainer')) document.getElementById('FloatingFooterAdContainer').style.display='none'")
  end

  def init_elements
    @page_elements = {
        # this label can display both, metro or specific neighborhood
        # depending on what type of search was done on start page
        "Search Location Label" => {
            "1" => "span_id;SearchNav_lblSearchLocation",
            "2" => "link_id;location-picker-link"
        },
        "Map" => "image_id;MapImage_imgMap",
        "Location Filter" => {
            "1" => "div_id;LocationFilter",
            "2" => "element_xpath;//div[@class='Neighborhoods-filter-menu']//div[@class='menu-container']"
        },
        "Price Filter" => {
            "1" => "div_id;PriceFilter",
            "2" => "div_class;PriceBrands-filter-menu"
        },
        "Cuisine Filter" => {
            "1" => "div_id;CuisineFilter",
            "2" => "element_xpath;//div[@class='Cuisines-filter-menu']//div[@class='menu-container']"
        },
        "Exact Time Filter" => {
            "1" => "div_id;ExactTimesFilter",
            "2" => "element_xpath;//li[@class='filter-option-time']//div[@class='checkbox-container']"
        },
        "POP Time Filter" => {
            "1" => "div_id;PopTimesFilter",
            "2" => "element_xpath;//div[@id='OfferTypes-filter-items']//input[@data-filter-name='OnlyPopTimes']"
        },
        "1000 Points Search Results" => "element_xpath;//*[@id='poptable-results']/div[2]/div[2]",
        "Search Results" => {
            "1" => "element_xpath;//*[@id='search_results']/div[3]/div/div/div[2]/div[4]/div", #/s/PopRestaurantList?
            "2" => "table_id;SearchResults_ResultsGrid",
            "3" => "div_class;infinite-results-list",
            "4" => "table_id;search_results_table"
        },
        "Find Next Available" => {
            "1" => "link_class;universalButtonMedium secondaryMediumBold",
            "2" => "link_class;button minimal"
        },
        "Affiliated Restaurants" => "link_id;AltRests_linkAffiliated",
        "Nearby Restaurants" => "link_id;AltRests_linkNearbyLink",
        "User also Dined at" => "link_id;AltRests_linkUserSuggestedLink",
        "1000 Points Restaurants" => "link_id;AltRests_linkDIPLink",
        "Search Results Times" => {
            "1" => "ul_class;ResultTimes"
        },
        "change location" => {
            "1" => "link_id;SearchNav_OTChangeLocation_hlChangeLocation",
            "2" => "link_id;location-picker-link"
        },
        "white level link" => "link_class;RefRestLink",
        "San Francisco" => "checkbox_id;FilterOption_Region_5",
        "Italian" => "checkbox_id;FilterOption_Cuisine_14",
        "$$$ ($31 to $50)" => "checkbox_id;FilterOption_Price_3",
        "Exact Times Checkbox" => "checkbox_id;FilterOption_ExactTimes",
        "Pop Times Checkbox" => "checkbox_id;FilterOption_PopTimes",
        "First Available Timeslot" => "element_css;a.timeslot.rest-row-times-btn ",
        "First Available POP Timeslot" => "element_xpath;//*[@id='search_results']/div[3]/div/div/div[2]/div[4]/div/a[contains(@class,'timeslot rest-row-times-btn')]",
        "Results Title" => "h3_id;results-title"

    }
    @page_elements
  end

  protected :init_elements

  def click_filter(filter_element)
    filter_element.click
    start_time =   Time.now
    ##There is a delay for the spinner to show up so wait till it shows up and then wait for it to complete
    @driver.wait_until(60, "Spinner is still not present after 60 secs"){@driver.div(:class,"spinner").present?}
    end_time = Time.now()
    time_lapse = end_time.to_f - start_time.to_f
    puts "Timelapse between click and spinner: #{time_lapse} secs"
    self.wait_for_spinner_to_complete()
  end

  def get_results_table_count
    results = get_element("Results Title").text.gsub(",", "")
    table_count = results.match(/\d{1,}/)
  end

  def compare_table_results()
    filtered_results_table = self.get_results_table_count
    (filtered_results_table.to_s.to_i <= $RUNTIME_STORAGE['results_tables'].to_s.to_i) ? \
    (puts "Number of filtered tables is #{filtered_results_table} vs unfiltered tables #{$RUNTIME_STORAGE['results_tables']}") : (raise Exception, "Number of filtered tables is #{filtered_results_table} > unfiltered tables #{$RUNTIME_STORAGE['results_tables']}")
  end

  def set_checkbox(search_filter_name)
    filter_element = $driver.element(:css, "span[title=\"#{search_filter_name}\"]")
    $driver.wait_until(60, "Filter: #{search_filter_name} checkbox is not visible after 60 secs"){$driver.element(:css, "span[title=\"#{search_filter_name}\"]").present?}
    if (filter_element.parent.input.checked?)
      (puts "Filter #{search_filter_name} already selected")
    else
      begin
        self.click_filter(filter_element)
      rescue => e
        y_position = filter_element.wd.location[:y]
        puts y_position
        #scrolling down to element
        idx = 0
        while !(filter_element.parent.input.checked?) && idx < 5
          @driver.execute_script("scroll(0, #{y_position-100})")
          self.click_filter(filter_element)
          idx += 1
          puts "idx=>#{idx}"
        end
      end
    end
    (filter_element.parent.input.checked?) ?  (puts "Filter #{search_filter_name} selected") :  (raise Exception, "Filter #{search_filter_name} STILL NOT selected!")
    $driver.wait_until(60, "Filter: #{search_filter_name} not visible or checked after 60 secs"){$driver.element(:css, "span[class='selected-filter-name']").present?}
  end

  def uncheck_checkbox(search_filter_name)
    filter_element = $driver.element(:css, "span[title=\"#{search_filter_name}\"]")
    (filter_element.parent.input.checked?) ?  self.click_filter(filter_element) : (puts "Filter #{search_filter_name} NOT selected")
    (filter_element.parent.input.checked?) ?  (raise Exception, "Filter #{search_filter_name} STILL selected!") : (puts "Filter #{search_filter_name} unselected")
    $driver.wait_until(60, "Filter: #{search_filter_name} is still visible after 60 secs"){!$driver.element(:css, "span[class='selected-filter-name']").present?}
  end

  def click_first_available_timeslot
    time_slot = nil
    self.wait_for_spinner_to_complete()
    first_available_timeslot = @driver.div(:id, 'search_results_container').links(:class,'rest-row-times-btn timeslot')
    @driver.wait_until(20, "No availability found in Search") {first_available_timeslot.present?}

    first_available_timeslot.each do |link|
      if (!link.html.include? 'data-has-pop="true"') && (!link.html.include? 'data-table-categories') && (link.present?)
        time_slot = link
        break
      end
    end
    unless time_slot.nil?
      querystring_values = parse_timeslot_attributes(time_slot)
      $RESERVATION["date_searched"] = querystring_values['d'].split('%20').first
      $RESERVATION["time_searched"] = querystring_values['d'].split('%20').last
      $RESERVATION["time_searched"] = Time.parse(querystring_values['d'].split('%20').last).strftime("%l:%M %P") if (($domain.domain.downcase.eql? "com") || ($domain.domain.downcase.eql? "com.mx"))
      $RESERVATION["points"] = querystring_values['pt']
      begin
        time_slot.send_keys :enter
      rescue Timeout::Error
        put "Getting Timeout Error but continue anyways"
      end

    end
    ## Increased the wait time as tests are failing intermittently on this line
    @driver.wait_until(120, "Details/View page not visible") {(@driver.url.include? "details") || (@driver.url.include? "view")}
  end

  def click_timeslot(time)
    @driver.element(:xpath, "//div[contains(@class, 'content-section-list')]//a[contains(@class,'timeslot') and @data-has-pop='False' and contains(text(), '#{time}')]").when_present do |time_slot|
      querystring_values = parse_timeslot_attributes(time_slot)
      $RESERVATION["date"] = querystring_values['d']
      $RESERVATION["points"] =querystring_values['pt']
      time_slot.click  if time_slot.present?
    end
    @driver.wait_until {
      (@driver.url.include? "details") || (@driver.url.include? "view")
    }
  end

  def click_anytimeslot(must_be_pop)
    should_see_element(look_up_element("@driver", "div", "class", "rest-row-times", true, 30), true)

    time_slot=nil

    timeslots = @driver.element(:xpath, "//a[@class = 'timeslot rest-row-times-btn']")
    timeslots.each { |slot|
      if !slot.class_name.nil? and slot.class_name.include? "timeslot" and !slot.class_name.include? "unavailable"
        if must_be_pop and !slot.html.nil? and slot.attribute_value("data-has-pop").include? "True"
          time_slot=slot
          break
        elsif !must_be_pop
          time_slot = slot
          break
        end
      end
    }

    if time_slot.nil?
      if must_be_pop
        raise Exception, "Could not find a valid pop time to click"
      else
        raise Exception, "No time slot found"
      end
    end
    querystring_values = parse_timeslot_attributes(time_slot)
    $RESERVATION["points"] =querystring_values['pt']

    time_slot.click

    @driver.wait_until {
      (@driver.url.include? "details.aspx") || (@driver.url.include? "details_pci.aspx") || (@driver.url.include? "view.aspx")
    }
  end

  def parse_timeslot_attributes(time_slot)
    href_attribute=time_slot.attribute_value('href').to_s
    href_attribute=time_slot.attribute_value('data-href').to_s if href_attribute.strip.empty?
    arr1 = href_attribute.to_s.split("&")
    querystring_values = Hash[arr1.map { |s| s.split('=') }]
  end

  def select_any_pop_time_slot
    pop_slot = nil
    @driver.div(:id, 'search_results_container').links(:class,'rest-row-times-btn timeslot').each do |link|
      if (link.html.include? 'data-has-pop="true"') && (link.present?)
        pop_slot = link
        break
      end
    end
    unless pop_slot.nil?
      querystring_values = parse_timeslot_attributes(pop_slot)
      $RESERVATION["date_searched"] = querystring_values['d'].split('%20').first
      $RESERVATION["time_searched"] = querystring_values['d'].split('%20').last
      $RESERVATION["time_searched"] = Time.parse(querystring_values['d'].split('%20').last).strftime("%l:%M %P") if (($domain.domain.downcase.eql? "com") || ($domain.domain.downcase.eql? "com.mx"))
      $RESERVATION["points"] = querystring_values['pt']
      is_data_table_categories = pop_slot.attribute_value('data-table-categories').to_s
      pop_slot.click
      if is_data_table_categories.empty?
        @driver.wait_until(160, "failed to navigate to details page") { (@driver.url.include? "details") }
      else
        @driver.wait_until(30,"Table Type popup window not opened") {@driver.div(:class => "modal-content-body table-selector").div(:class => "table-selector-header").present?}
      end
    else
      raise Exception, "No POP slot in the search results"
    end

  end

end
