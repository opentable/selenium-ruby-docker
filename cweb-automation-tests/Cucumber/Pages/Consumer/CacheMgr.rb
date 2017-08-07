class CacheMgr < ConsumerBasePage

  def self.page_name
    "/cache/cachemgr.aspx"
  end

  attr_accessor :driver, :domain
  attr_reader :page_elements

  def initialize(browser, domain = $domain.www_domain_selector)
    @driver = browser
    @domain = domain
    super(@driver, init_elements)
  end

  def init_elements
    @page_elements = {
        "ReCache" => "button_id;btnReCache",
        "All" => {
            "1" => "checkbox_id;grdCacheItems_ctl01_chkSelectall",
            "2" => "checkbox_id;grdCacheItems_chkSelectall"
        },
        "All ValueLookups" => "checkbox_id;grdWebCacheItemsList_ctl01_chkSelectAllWebCache",
        "Recached message" => "span_id;lblSocketCount"
    }
  end

  protected :init_elements

  def go_to()
    @driver.goto("http://#{$domain.www_domain_selector}#{self.class.page_name}")
  end

  def recache_single_server(items_to_recache, wait_timeout_in_seconds, cache_url ="http://#{$domain.www_domain_selector}#{self.class.page_name}")
    #initilizing new browser
    browser = BrowserUtilities.open_browser($browser_type)
    browser.goto("#{cache_url}")

    if (items_to_recache.downcase == "all")
      obj = browser.checkbox(:id,"grdCacheItems_ctl01_chkSelectall")
      if !(obj.exists?)
        obj = browser.checkbox(:id,"grdCacheItems_chkSelectall")
      end
      obj.click
    elsif (items_to_recache.downcase == "all valuelookups")
       obj = browser.checkbox(:id,"grdWebCacheItemsList_ctl01_chkSelectAllWebCache")
       if !(obj.exists?)
         obj = browser.checkbox(:id,"grdCacheItems_chkSelectall")
       end
       obj.click
    else
      items_to_recache.split(";").each { |item|
         browser.td(:text, item.strip).parent.checkboxes[0].set true
      }
    end
    browser.button(:id,"btnReCache").click

    success = false
    1.upto(wait_timeout_in_seconds) do
      desc = "recached"
      elmt = browser.link(:class,/#{desc}/)
      if ((elmt != nil) && (elmt.exists?)) || browser.span(:id, "lblSocketCount").text.downcase.include?("recached all selected data")
        success = true
        break
      end
      sleep 1
    end

    if !success
      #raise Exception, "recache failed for items #{items_to_recache} after waiting #{wait_timeout_in_seconds} secnods"
      puts "recache failed for items #{items_to_recache} after waiting #{wait_timeout_in_seconds} secnods"
    end
    browser.close
  end

  def get_server_ipaddress_accepting_traffic(sitetypeid)
    db = OTDBAction.new($domain.db_server_address, $domain.db_name, $db_user_name, $db_password)
    sql = "SELECT S.IPAddress,S.ServerName FROM ServerSite SS INNER JOIN Server S on SS.ServerID = s.serverid  WHERE SS.SiteTypeID = #{sitetypeid} and S.AcceptsTraffic =1 "
    result_set = db.runquery_return_resultset(sql)
    ip_array = Array.new(){ Array.new(2) }
    result_set.each { |i|
        ip_array << [i[0],i[1]]
    }
    return ip_array

  end


  def build_url_based_on_number_of_server (port_number, sitetype_id, domain_selector)
    ipaddress = get_server_ipaddress_accepting_traffic(sitetype_id)
      url_stg = Array.new
      ipaddress.each { |ip|
        #this is to generate url for secondary domains like fr-ca, en-gb, en-us
        domain_selector =~/\/(.*)$/
        if $1.nil?;  url_stg << "#{ip[0]}:#{port_number}" else url_stg << "#{ip[0]}:#{port_number}/#{$1}"  end
      }
    return url_stg
  end

  def recache_website(items_to_recache, wait_timeout_in_seconds)
    port = $domain.webserver_site_port
    sitetype_id = $domain.webserver_sitetype_id
    domain = $domain.www_domain_selector
    urls_stg = build_url_based_on_number_of_server(port, sitetype_id, domain )
    if urls_stg.length == 1
      cache_url = "http://#{domain}#{self.class.page_name}"
      recache_single_server(items_to_recache, wait_timeout_in_seconds, cache_url)
    else
      threads = []
      urls_stg.each  do |partial_url|
        cache_url = "http://#{partial_url}#{self.class.page_name}"
         threads << Thread.new(cache_url) do |cache_url|
         recache_single_server(items_to_recache, wait_timeout_in_seconds, cache_url)
        end
      end
      threads.each(&:join)
    end

  end

end


