class RedemptionConfirm < ConsumerBasePage

  def self.page_name
    "/Redemption/Confirm" || "Redemption/AmazonConfirm"
  end

  def self.page_url_match?(url)
    (url.include? ("/Redemption/Confirm")) || (url.include? ("/Redemption/AmazonConfirm"))
  end

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
      "Redeem Value Selected Header" => "element_xpath;//*/div[2]/div/div/div/h3",
      "Remainder Value" => "element_xpath;//*/div[2]/div/div/div/div[2]",
      "Back" => "element_css;.button.type-2.left",
      "Redeem" => "element_css;.button.secondary.right",
      "Email" => "element_xpath;//*/div[2]/div/div/div/div[3]/div[2]/div"
    }
  end

  def go_to()
    if !@driver.url.include? self.class.page_name
      @driver.goto("http://my.#{$domain.charm_domain_selector}/#{self.class.page_name}")
    end
  end

  def select_points(redeempoints)
    get_element("Redeem Value List").select_value(redeempoints)
  end

  def check_redeem_value(redeempoints)
      if !get_element("Redeem Value Selected Header").text.gsub(/,/,"").include? redeempoints
        raise Exception, "Expected Redeem value: #{redeempoints}, Actual: #{get_element("Redeem Value Selected Header").text}"
      end
  end

  def check_remaining_points(redeempoints, add_points)
    $TOTAL_POINTS = add_points.to_i - redeempoints.to_i
    if !get_element("Remainder Value").text.gsub(/,/,"").include? $TOTAL_POINTS.to_s
      raise Exception, "Expected Remainder value: #{$TOTAL_POINTS}, Actual: #{get_element("Remainder Value").text}"
    end
    puts "Total remaining points = #{$TOTAL_POINTS}"
  end

  def check_email_address()
    expected_email = $USER['email']
    if !get_element("Email").text.downcase.include? expected_email.downcase
      raise Exception, "Expected Email: #{expected_email}, Actual Email: #{get_element("Email").text}"
    end
  end


  def click(friendly_name)
    @driver.wait_until(10, "Element: #{friendly_name} Not found") {get_element(friendly_name).exists?}
    get_element(friendly_name).click
    @driver.wait_until(30, "Redemption Complete page not found"){$driver.url.include? "Complete"} if friendly_name == "Redeem"
  end
end