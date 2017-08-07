#depricated.
#Get stuff out of here.
class ConsumerBasePage < WebBasePage

  def self.page_name
    "opentable"
  end

  attr_accessor :driver
  attr_reader :elements

  def initialize(browser, elements = {})
    @driver = browser

    # initialize base elements hash
    @elements = ot_base_elements
    @elements = @elements.merge(elements)
    super(@driver, @elements)
  end

  def ot_base_elements
    # only common elements, found
    # on most consumer site pages should be added here
    # key => {how;value}

    #Initialization in case $opentable_starturl is not set in the beginning
    $opentable_starturl = $domain.www_domain_selector if $opentable_starturl.nil?
  # start.aspx, rest_profile.aspx, booking-flow
      @elements = {
          "Find a Table" => {
              "1" => "button_class;button dtp-picker-button",
              "2" => "input_id;submit",  # Used by restaurant widgets (ism)
              "3" => "a_id;OT_Find_a_Table", # Used by restaurant widgets (frontdoor)
          },
          "Time" => {
              "1" => "select_list_name;Select_0",
              "2" => "select_class;selectdropdownelement-native time-picker", #part of experiment?
              "3" => "select_list_name;ResTime", # Used by restaurant widgets (ism)
              "4" => "ul_id;OT_timeList", # Used by restaurant widgets (frontdoor)
          },
          "Party Size" => {
              "1" => "select_list_name;Select_1",
              "2" => "select_class;selectdropdownelement-native party-size-picker", #part of experiment?
              "3" => "select_list_name;PartySize", # Used by restaurant widgets (ism)
              "4" => "ul_id;OT_partyList", # Used by restaurant widgets (frontdoor)
          },
          "Calendar" =>  {
              "1" => "input_class;datepicker dtp-picker-select picker__input",
              "2" => "input_id;startDate", # Used by restaurant widgets (ism)
              "3" => "input_id;datepicker", # Used by restaurant widgets (frontdoor)
          },
          "Calendar Container" => {
              "1" => "div_class;picker__box",
              "2" => "td_class;months partOfCal", # Used by restaurant widgets (ism)
              "3" => "div_id;ui-datepicker-div", # Used by restaurant widgets (frontdoor)
          },
          "Calendar Month" => {
              "1" => "div_class;picker__month",
              "2" => "td_class;months partOfCal", # Used by restaurant widgets (ism)
              "3" => "element_css;.ui-datepicker-month",  # Used by restaurant widgets (frontdoor)
          },
          "Calendar Navigator Next" => {
              "1" => "div_class;picker__nav--next",
              "2" => "element_css;.rightArrow.partOfCal", # Used by restaurant widgets (ism)
              "3" => "element_css;.ui-icon.ui-icon-circle-triangle-e",  # Used by restaurant widgets (frontdoor)
              "4" => "element_css;a.partOfCal", # Used by /r/singleres.aspx (attribution test)
          },
          "My Profile" => {
              "1" => "link_id;global_nav_myprofile", #Start page
              "2" => "link_id;TopNav_linkMyProfile", # Concierge profile page
              "3" => "element_xpath;//a[contains(@href,'myprofile.aspx')]",
              "4" => "element_xpath;//*[@id='global_header']/nav/a[2]", #Concierge profile/info page.  Can't use Title due to different languages eg My Profile vs Mein Profile vs...
          },
          "User Name" => "link_id;global_nav_username",
          "Upcoming Reservation Count" => {
              "1" => "div_id;upcoming-reservations-count",
              "2" => "link_id;upcoming-reservations-count",
          },
          "Join Waitlist Now" => "a_class;button expand waitlist-button",
        }

    @elements
  end

  protected :ot_base_elements

  # override this function for consumer site
  def select(friendly_name, value)
    ori_value = get_element(friendly_name).value
    if !(get_element(friendly_name).value.include? value)
      if get_element(friendly_name).value.to_s.include? "Uhr"
        value = "#{value} Uhr"
      end
    end

    $driver.wait_until(10,"Unable to find element #{friendly_name}") {get_element(friendly_name).exists?}
    sleep 5
    get_element(friendly_name).click
    get_element(friendly_name).select value
    get_element(friendly_name).click
    puts "Time value selected==> #{get_element(friendly_name).value}  Original value==> #{ori_value}"
    $driver.wait_until(5,"Element #{friendly_name} is still set at #{get_element(friendly_name).value} instead of #{value}") {!get_element(friendly_name).value.eql? ori_value} if !get_element(friendly_name).value.eql? ori_value
  end

  def select_by_value_attribute(friendly_name, value)
    $driver.wait_until(5,"Unable to find element #{friendly_name}") {get_element(friendly_name).exists?}
    if !get_element(friendly_name).option(:value, "#{value}").selected?
      get_element(friendly_name).select_value("#{value}")
    end
  end

  def double_click(element)
    get_element(element).double_click
  end

  def sign_out
    begin
      get_element("Sign Out").click
    rescue => e
      puts "Did not find Sign Out link on page"
    end
  end

#####################################
# common controls methods
#####################################

#####################################
#Sets calendar date
#
#@param s_date Valid Date
#
#####################################

  def wait_for_spinner_to_complete()
    @driver.wait_until(90, "Spinner is still spinning after 90 secs"){!@driver.div(:class,"spinner").present? &&!@driver.p(:class,"spinner-caption").present?  }
  end

  def wait_for_document_to_load()
    $driver.wait_until { $driver.execute_script("return window.document.readyState") == "complete" }
  end

  def convert_month_to_number(calendar_month)
  #Calculate if the current page has the right month
    if calendar_month[/(\d)/,1].nil?
      #Added convert_month_index to take care i18n
      int_current_month = convert_month_index(calendar_month).to_i
    else # deal with Japanese dates
      if calendar_month.length == 2
        int_current_month = calendar_month[/(\d)/,1].to_i
      else
        int_current_month = calendar_month[/(\d\d)/,1].to_i
      end
    end
    return int_current_month
  end

  ##Use this as the default to make,change reservations.  Use set_date_by_calendar_ui function sparingly when testing out the dtp
  ##as tests will take longer to execute
  def set_date(s_date)
     if get_element("Calendar").attribute_value('class') == 'datepicker dtp-picker-select picker__input'
      @driver.execute_script("$('.date-picker').OTdatepicker('set', '#{s_date}')")
      #Called by frontdoor/singlerest.aspx ism/singlerest.aspx
     elsif ((get_element("Calendar").attribute_value('class') == 'OT_searchDateField hasDatepicker') || (get_element("Calendar").attribute_value('class').include? 'feedFormfieldCalendar'))
      get_element("Calendar").to_subtype.clear
      get_element("Calendar").send_keys DateTime.parse(s_date).strftime("%m/%d/%Y") if $domain.www_domain_selector == "www.opentable.com"
      get_element("Calendar").send_keys DateTime.parse(s_date).strftime("%d/%m/%Y") if $domain.www_domain_selector == "www.opentable.co.uk"
    end

  end

  def set_date_by_calendar_ui(s_date)
    @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
    if !get_element("Calendar").exists?
      # In TC, the page is sometimes not rendered properly.  Try to refresh and see if the calendar is displayed.
      # If not, raise the exception
      @driver.refresh
      @driver.wait_until(10, "Failed to display calendar"){get_element("Calendar").present?}
    end
    get_element("Calendar").send_keys :tab
    wait_for_calendar(get_element("Calendar Container"))
    if get_element("Calendar Container").attribute_value('class') == "months partOfCal"
      s_year = DateTime.parse(s_date).strftime('%y')
      s_month = DateTime.parse(s_date).strftime('%m')
      s_day = DateTime.parse(s_date).strftime('%d')
      calendar_month = get_element("Calendar Month").text.split(" ").first
      puts "#{calendar_month}"
    else
      #Get the day, month, year
      s_year = DateTime.parse(s_date).strftime('%Y')
      s_month = DateTime.parse(s_date).strftime('%_m')
      s_day = DateTime.parse(s_date).strftime('%-d')

      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
      if !get_element("Calendar Container").present?
        get_element("Calendar").send_keys :tab
        wait_for_calendar(get_element("Calendar Container"))
      end

      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
      calendar_month = get_element("Calendar Month").text
    end

    int_current_month = convert_month_to_number(calendar_month)

    unless s_month.to_i == int_current_month
      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
      get_element("Calendar").click if get_element("Calendar Navigator Next").nil?
      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
      get_element("Calendar Navigator Next").click
      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "/book/view"
    end

      #Used by new redesign
    if get_element("Calendar Container").attribute_value('class') == 'picker__box'
      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "view"
      i_day_in_milli_secs =  convert_date_in_milli_seconds (s_date.to_datetime)
      puts "Excepted datetime: #{i_day_in_milli_secs}, Date: #{s_date.to_datetime}"
      @driver.wait_until(45,"Unable to find datetime #{i_day_in_milli_secs}") {@driver.element(:css,"div.picker__day.picker__day--infocus[data-pick='#{i_day_in_milli_secs}']").present?}
      @driver.div(:class,"modify").element.wd.location_once_scrolled_into_view if $driver.url.include? "view"
      @driver.element(:css, "div.picker__day.picker__day--infocus[data-pick='#{i_day_in_milli_secs}']").click

    #Used by single.aspx, ism/singlerest.aspx
    elsif get_element("Calendar Container").attribute_value('class') == 'months partOfCal'
      s_data_to_click_id = " pk#{s_month}#{s_day}#{s_year}"
      @driver.element(:xpath, "//a[@id='#{s_data_to_click_id}']").click

    #Called by frontdoor/singlerest.aspx
    elsif get_element("Calendar Container").attribute_value('class') == 'ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'
      @driver.table(:class, 'ui-datepicker-calendar').td(:text, "#{s_day}").click
    end
  end

  def wait_for_calendar (s_element)
    @driver.wait_until(30,"Failed to display Calendar") {s_element.exists?}
    s_element.click
  end

#####################################
# sets party size
# @param party_sz
#  Example: 2 people
#####################################
  def set_party_sz(party_sz)
    if (party_sz == "Larger Party")
      party_sz = 21
    else
      party_sz = party_sz.to_i
    end
    select_by_value_attribute("Party Size", party_sz)
  end

#####################################
# sets restaurant
# @param restaurant name
#  Example: Ame
#####################################
  def select_restaurant(restaurant)
    success = false

    if defined?($g_page) && defined?($g_page.set_location_restaurant_on_new_start_page)
      $g_page.set_location_restaurant_on_new_start_page(restaurant)
      success = true
      return success
    end
    if @driver.text_field(:id, @elements["Restaurant Auto Fill"].split(';')[1]).exists?
      @driver.text_field(:id, @elements["Restaurant Auto Fill"].split(';')[1]).clear
      @driver.text_field(:id, @elements["Restaurant Auto Fill"].split(';')[1]).set restaurant[0, 4]
      puts "restaurant name first four digits has been entered in the auto fill text field"
      rest_obj= wait_until_element_find(120, @driver.div(:id, @elements["Auto fill list"].split(';')[1]).span(:text, /#{restaurant}/))
      puts "restaurant name has been found in the auto search drop down"
      rest_obj.click
      puts "restauarnt name has been clicked"
      success =true
    else
      # click Restaurant Tab if present
      if @driver.span(:id, @elements["By Restaurant Name Tab"].split(';')[1]).exists?
        if @driver.span(:id, @elements["By Restaurant Name Tab"].split(';')[1]).visible?
          @driver.span(:id, @elements["By Restaurant Name Tab"].split(';')[1]).click
        end
      end
      r = @elements["Restaurant"]

      r.each_value { |v|
        if @driver.text_field(:id, v.split(';')[1]).exists?
          @driver.text_field(:id, v.split(';')[1]).set restaurant
          success = true
          break
        elsif @driver.select(:id, v.split(';')[1]).exists?
          @driver.select(:id, v.split(';')[1]).select restaurant

          success = true
          break
        end
      }
    end
    success
  end

  def scrape_js_value_from_source(variable, delimiter)
    variable = variable.to_s.strip
    match_string = nil
    # look for a string with pattern: ex: iGMTOffsetMins = 120;
    match_string = self.driver.html.match(/#{variable}[\s]*#{delimiter}[\s]*[\w\W]*\;/)
    puts "match_string: #{match_string.inspect}"
    if !match_string
      raise Exception, "Variable #{variable} that you are looking for cannot be found in source."
    end
    return match_string.to_s.split(delimiter)[1].gsub(' ', '').split('\;')[0]
  end

  def get_calendar_default_date
    gmt_offset_mins = self.scrape_js_value_from_source("iGMTOffsetMins", "=").to_i
    puts "gmt_offset_mins: #{gmt_offset_mins}"
    default_date = Time.new.getgm + (gmt_offset_mins * 60)
    if default_date.hour == 23 && default_date.min > 25
      ## the calendar shows next day.  Add one hours to the local time to advance to next day
      #date_in_region = (DateTime.parse(date_in_region) + 1).strftime("%Y-%m-%d")
      default_date += 3600
    end
    default_date
  end

  def click_findatable_fillin_anonymous_user_info(fname, lname, email)
    check_opentables_fillin_user_info(fname, lname, email, false, false)

  end

  def check_opentables_fillin_user_info(fname, lname, email, isSignin, isConcierge)
    #initializing opentables class
    $g_page = BookingRestaurantProfile.new(@driver)
    $g_page.click_time_slot($RESERVATION["time_searched"], $RESERVATION["days_fwd"])
    $g_page = BookingDetails.new(@driver)
    $g_page.fill_details_page_info(isConcierge, fname, lname, email, isSignin)

  end

#sign up functionality for new design
  def fill_user_fname_lname (fname, lname, frame)
    frame.text_field(:id, 'ucName_txtFirstName').set(fname)
    frame.text_field(:id, 'ucName_txtLastName').set(lname)
  end

  def fill_kata_kaja_user_info(kanaL, kanaF, kanjiL, kanjiF, frame)
    frame.text_field(:id, 'ucName_txtKanjiLastName').set kanjiL
    frame.text_field(:id, 'ucName_txtKanjiFirstName').set kanjiF
    frame.text_field(:id, "ucName_txtKanaLastName").set kanaL
    frame.text_field(:id, 'ucName_txtKanaFirstName').set kanaF
  end


  def sign_up (fname, lname, email, pwd, metro, is_admin, kanaL = nil, kanaF = nil, kajiL=nil, kajiF = nil)
    sleep 3
    frame_obj = @driver.iframe(:src, /registerpopup/)
    get_foreign_link = frame_obj.element(:id, 'linkForeign')
    begin
      if get_foreign_link.present?
        fill_kata_kaja_user_info(kanaL, kanaF, kajiL, kajiF, frame_obj)
      else
        fill_user_fname_lname(fname, lname, frame_obj)
      end
      frame_obj.text_field(:name, 'txtEmail').set(email)
      frame_obj.text_field(:id, 'txtPassword').send_keys(pwd)
      frame_obj.text_field(:id, 'txtReEnterPassword').send_keys(pwd)
      self.is_admin_user(frame_obj) if is_admin
      self.select_primary_metro(frame_obj, metro)
      frame_obj.element(:id, 'btnRegister').click
      @driver.wait_until(90, "registeration failed") { get_element("User Name")|| get_element("My Profile") }
    rescue
    end
  end

  def is_admin_user (frame_obj)
    begin
      frame_obj.element(:id, "chkIsAdmin").click
      frame_obj.ins(:class, 'iCheck-helper').fire_event :click
    rescue
    end
  end

  def select_primary_metro (frame_obj, metro)
    begin
      if frame_obj.select_list(:id, 'cboCity').exists?
        frame_obj.select_list(:id, 'cboCity').select metro
      end
    rescue
      frame_obj.link(:id, 'cboCity_SelectDropDownSelectorLink').click
      frame_obj.element(:css, "label[data-value='#{metro}']").click
    end
  end


  def set_party_sz_on_new_design(party_size)
    select_by_value_attribute("Party Size", "#{party_size.to_s.split(" ")[0]}")
  end

  def get_current_date_time_based_on_zone_domain
    c_date = Time.now.getutc
    c_date = TZInfo::Timezone.get($domain.metro_time_zone).utc_to_local(c_date)
    return c_date
  end

  def get_date_based_on_time_zone (days_fwd)
    s_date = self.get_current_date_time_based_on_zone_domain
    s_date = s_date.advance(:days => days_fwd)
    return s_date
  end

  def convert_date_in_milli_seconds (s_date)
    sdate = s_date.strftime('%Y-%m-%d 00:00:00 ')+"-0800"
    sdate = s_date.strftime('%Y-%m-%d 00:00:00 ')+"-0700" if Time.parse(s_date.to_s).dst?
    return sdate.to_datetime.to_i.floor*1000
  end

end
