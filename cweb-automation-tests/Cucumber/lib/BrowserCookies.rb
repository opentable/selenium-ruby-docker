class BrowserCookies
  include BrowserUtilities

  attr_accessor :cookie_name, :cookie_value

  def initialize(driver, domain=$domain.www_domain_selector)
    @browser =driver
    @domain = domain
  end


  def get_all_cookies
    cookies = @browser.driver.manage.all_cookies
    return cookies
  end

  def reopen_browser_and_add_non_expire_cookies
    cookies = prepare_to_save_cookies()
    cookies.each { |cookie|
      if !(cookie[:expires].nil?)
        @browser.driver.manage.add_cookie(cookie)
      end
    }
    return @browser
  end

  def reopen_browser_and_add_non_expire_and_soft_login_cookies
    cookies = prepare_to_save_cookies()
    cookies.each { |cookie|
      if ((cookie[:name].eql? "uCke") or (cookie[:name].eql? "pCke") or !(cookie[:expires].nil?))
        @browser.driver.manage.add_cookie(cookie)
      end
    }
    return @browser
  end

  def prepare_to_save_cookies
    cookies = self.get_all_cookies
    @browser.close
    @browser = nil
    @browser = BrowserUtilities.open_browser($browser_type)
    @browser.goto(@domain)
    cookies
  end


  def get_cookie_value (cookie_name)
    cookies = self.get_all_cookies
    cookie_value =nil
    cookies.each { |cookie|
      if !(cookie[:name].eql? cookie_name)
        cookie_value =  cookie[:value]
      end
    }
    if cookie_value.nil?
      raise Exception, "There is no value for the cookie #{cookie_name}"
    end
    return cookie_value
  end

  def get_cookie_named (cookie_name)
    cookie_with_name =@browser.driver.manage.cookie_named(cookie_name)
    return cookie_with_name
  end

  def add_all_cookies
    cookies = self.get_all_cookies
    @browser.close
    @browser = nil
    @browser = BrowserUtilities.open_browser($browser_type)
    @browser.goto(@domain)
    @browser.driver.manage.add_cookie(cookies)
    return @browser
  end

  def check_cookie_value (looking_string, cookie_name)
    get_cookie_value(cookie_name).to_s.include? looking_string
  end

  def delete_specific_cookie(cookie_name)
    if !(self.get_cookie_named(cookie_name).nil?)
      @browser.driver.manage.delete_cookie(cookie_name)
    end
  end

  def add_specific_cookie(cookie_name, cookie_value)
    cookie = {}
    cookie[:name] = cookie_name
    cookie[:value] = cookie_value
    @browser.driver.manage.add_cookie(cookie)
  end
end
