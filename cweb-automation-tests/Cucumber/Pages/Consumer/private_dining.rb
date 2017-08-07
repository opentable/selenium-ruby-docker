
class PrivateDining  < ConsumerBasePage

  def self.page_name
    "PrivateDining"
  end

  def self.page_url_match?(url)
    url.include?("/private-dining")
  end

  def initialize(browser)
    @driver = browser
    init_elements
    super(@driver, @page_elements)
  end

  def init_elements
    @page_elements ={
    "Contact Selected Restaurant" => "button_class;Contact Selected Restaurant",
    "Submit" => "button_type;submit",
    "First Name" =>"input_name;firstName",
    "Last Name" =>"input_name;lastName",
    "Email Address" => "input_name;email",
    "Phone" => "input_name;phoneNumber",
    "GuestCount" => "input_name;partySize",
    "Eventtype" => "option_value;Birthday",
    "Langselectbtn" =>"a_class;language-selector__link js-toggle-menu",
    "LanguageDE" => "elements_css;.js-languages-list__link[href$='de']",
    "LanguageESP" => "elements_css;.js-languages-list__link[href$='es']",
    "LanguageFR" => "elements_css;.js-languages-list__link[href$='fr']",
    "LanguageJP" => "elements_css;.js-languages-list__link[href$='ja']",
    "Neighborhood"=> "element_css;li.filter-option.filter-option-locations",
    "Event size" => "element_css;li.filter-option.filter-option-events",
    "Cuisine" => "element_css;li.filter-option.filter-option-cuisines",
    "Price" => "element_css;li.filter-option.filter-option-prices",
    "specialoccasions" => "element_css; div.special-occasion.content-block",
    "Specialevent" => "element_css; div.special-occasion-item"


    }
  end

  def set_user_choice_and_submit
    get_element("First Name").send_keys ("Auto")
    get_element("Last Name").send_keys("Tester")
    get_element("Email Address").send_keys("#{random_string(8)}@opentable.com")
    get_element("Phone").send_keys("6509997999")
    get_element("GuestCount").send_keys("9")
    get_element("Eventtype").select
    get_element("Submit").click
  end
 def select_language(lang)
   get_element("Langselectbtn").click
   if lang.eql?("Deutsch")
      get_element("LanguageDE").last.click
   elsif lang.eql?("Espanol")
     get_element("LanguageESP").last.click
  elsif lang.eql?("Francais")
     get_element("LanguageFR").last.click
  else lang.eql?("JP")
     get_element("LanguageJP").last.click

  end
 end

  def verify_filters_are_seen

    if !get_element("Neighborhood").exists?
      raise Exception, "Failed to find Neighborhood filter!"
    end
    if !get_element("Event size")
      raise Exception, "Failed to find Event size filter!"
    end
    if !get_element("Cuisine")
      raise Exception, "Failed to find Cuisine filter!"
    end
    if !get_element("Price")
      raise Exception, "Failed to find Price filter!"
    end

  end

  def count_special_items (count)
    specialcount = @driver.elements(:class => "special-occasion-item").size
    spc = specialcount.to_s
    if spc.equal? count
    puts "okokok"
    end
   end

end