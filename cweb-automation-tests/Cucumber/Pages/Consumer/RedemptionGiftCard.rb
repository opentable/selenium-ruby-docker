class RedemptionGiftCard < ConsumerBasePage

  def self.page_name
    "/Redemption/GiftCard" || "Redemption/AmazonCard"
  end

  def self.page_url_match?(url)
    url.include?("my.#{$domain.charm_domain_selector}/Redemption/GiftCard") || url.include?("my.#{$domain.charm_domain_selector}/Redemption/AmazonCard")
  end

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
    $POINTS_OTVALUE = {
        "COM" => {"2000" => "$20", "5000" => "$50", "1000" => "$100"},
        "COUK" => {"2000" => "20", "5000" => "50", "1000" => "100"},
        "FRCA" => {"2000" => "$20", "5000" => "$50", "1000" => "$100"}
    },
    $POINTS_AZVALUE = {
        "COM" => {"2000" => "$10", "5000" => "$25"},
    }
  end

  def init_elements
    @page_elements = {
      "Redeem Value List" => "select_list_id;PointsSelector",
      "Redeem Value Selected Header" => "h4_class;font-weight-medium",
      "Cancel" => "element_css;.button.type-2.left",
      "Continue" => "element_css;.button.secondary.right"
    }
  end

  def go_to()
    if !$driver.url.include? self.class.page_name
      @driver.goto("https://my.#{$domain.charm_domain_selector}/#{self.class.page_name}")
    end
  end

  def select_points(redeempoints)
    get_element("Redeem Value List").select_value(redeempoints)
  end

  def check_redeem_value(redeempoints)
    point_value =  $POINTS_OTVALUE[0][$domain.yml_param][redeempoints]
    point_value  = $POINTS_AZVALUE[$domain.yml_param][redeempoints] if $driver.url.downcase.include? "amazoncard"

    if !get_element("Redeem Value Selected Header").text.gsub(/,/,"").include? redeempoints and
                !get_element("Redeem Value Selected Header").text.include? point_value
        raise Exception, "Expected Redeem points: #{redeempoints} and cash value: #{point_value}, Actual: #{get_element("Redeem Value Selected Header").text}"
    end
    puts "Redeemed #{redeempoints} points for #{point_value}"
  end

  def click(friendly_name)
    @driver.wait_until(10, "Element: #{friendly_name} Not found") {get_element(friendly_name).exists?}
    get_element(friendly_name).click
  end
end