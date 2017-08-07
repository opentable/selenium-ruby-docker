class Redeempoints < ConsumerBasePage

  def self.page_name 
 "redeempoints" || "redeem"
 end

  def self.page_url_match? (url)
    url.include? ("\/redeempoints.aspx")  or url.match /\/redeem\//
  end

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser 
 		@domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "Address Line1" =>
            {
                "1" => "text_field_name;txtAddress1",
                "2" => "text_field_id;txtAddress1JP",
                "3" => "text_field_name;address1",
            },
        "Address Line2" =>
            {
                "1" => "text_field_name;txtAddress2",
                "2" => "text_field_id;txtAddress2JP",
                "3" => "text_field_name;address2",
            },
        "City" =>
            {"1" => "text_field_name;txtCity",
             "2" => "text_field_id;txtCityJP",
             "3" => "text_field_name;city",
            },
        "County" =>
            {"1" => "text_field_name;txtState",
             "2" => "text_field_id;txtStateJP",
             "3" => "text_field_name;countryName",
            },
        "Zip" =>
            {"1" => "text_field_name;txtZipCode",
             "2" => "text_field_id;txtZipCodeJP",
             "3" => "text_field_name;zipCode",
            },
        "State" =>
            {"1" => "text_field_name;txtStateJP",
             "2" => "text_field_name;state",
             "3" => "text_field_name;txtState",
             "4" => "select_list_id;cboStateList",
            },
        "SaveAddressCheckbox" => "checkbox_id;chkUpdateProfileAddress",
        "Continue" => {
            "1" => "button_name;btnContinue",
            "2" => "element_css;.button.expand",
        },
        "Redeem 2,000 points" => {
            "1" => "radio_id;radBtnRedeemGift20",
            "2" => "element_css;div.form-input:nth-of-type(1)",  ## New design in FRCA?
        },
        "Redeem 5,000 points" => {
            "1" => "radio_id;radBtnRedeemGift50",
            "2" => "element_css;div.form-input:nth-of-type(2)",
        },
        "Redeem 10,000 points" => {
            "1" => "radio_id;radBtnRedeemGift100",
            "2" => "element_css;div.form-input:nth-of-type(3)",
        },
        "Claim Reward" => {
            "1" => "button_id;btnClaimReward",

        },
    }
    @page_elements
  end

  protected :init_elements

  def go_to()
    visit("http://#{@domain}/#{self.class.page_name}")
  end

  def select(name, value)
    if (name == "State") && ((["www.opentable.jp","www.opentable.de", "www.opentable.co.uk"].include? $domain.www_domain_selector) || ($driver.url.include? "/redeem/"))
        set("State", value)
    else
      get_element(name).select value
    end
  end

  def click_my_profile()
    get_element("My Profile").click unless !get_element("My Profile", 10).exists?
  end
end