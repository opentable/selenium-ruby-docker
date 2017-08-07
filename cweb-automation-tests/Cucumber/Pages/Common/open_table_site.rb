module OpenTableSite
  ##
  # Knows about the various page objects
  # Can determine the current page

  class IsCurrentPageNotImplemented < Exception;
  end

  class PageObject
    # Note, this was moved from WebBasePage and change from attr_accessor to attr_reader because it didn't
    # seem to be modified by anything in the code base
    attr_reader :driver

    def initialize(driver)
      @driver = driver
    end

    def self.is_current_page? driver
      raise OpenTableSite::IsCurrentPageNotImplemented, "#{self.name} does not implement is_current_page?"
    end

    def self.descendants
      #http://stackoverflow.com/questions/2393697/look-up-all-descendants-of-a-class-in-ruby
      result = []
      ObjectSpace.each_object(Class) do |klass|
        result = result << klass if klass < self
      end
      result
    end
  end

  def self.init session
    @session = session
    @pages = nil
    @page_instances = {}
  end

  def self.all_known_pages
    unless @pages
      raise "No session has been set, cannot create page objects" unless @session
      @pages = PageObject.descendants
    end
    @pages
  end

  def self.page_instance class_type
    @page_instances[class_type] ||= class_type.new @session
  end

  def self.session
    @session
  end

  def clear_cookies
    bridge = @session.driver.browser.send(:bridge)
    bridge.deleteAllCookies()
  rescue
    puts 'Error clearing cookies.'
  end

  module PageAccessors

    def current_page
      found_page = OpenTableSite.all_known_pages.find do |p|
        begin
          p.is_current_page? OpenTableSite::session
        rescue OpenTableSite::IsCurrentPageNotImplemented
          false
        end
      end

      raise "Could not find current_page, it may mean that is_current_page? method has not been implemented" unless found_page

      OpenTableSite::page_instance found_page
    end

    def current_page_is(expected_page_name)
      ot_page(expected_page_name).is_current_page?
    end

    def ot_page(page_name)
      page_name = page_name.to_s.downcase
      found_page = OpenTableSite::all_known_pages.find { |p| p.name.to_s.downcase =~ /#{page_name}(page)?$/ }
      raise "No page object for '#{page_name}' found" if found_page.nil?

      OpenTableSite::page_instance found_page
    end

  end

end