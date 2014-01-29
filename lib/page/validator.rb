require "page/validator/version"
require "page-object"

module PageValidator
  include PageObject

  #implements PageObject initialize_page called in Page class constructor
  #to validate page title and that page finished loading
  #the logic is:
  def initialize_page
    has_expected_title_wait? if self.respond_to?("has_expected_title_wait?")

    has_expected_title? if self.respond_to?("has_expected_title?")

    has_expected_element? if self.respond_to?("has_expected_element?")

    has_expected_element_visible? if self.respond_to?("has_expected_element_visible?")

    if self.respond_to?('load_finished?')
      wait_until(::PageObject.default_element_wait*6) {load_finished?}
      if !load_finished?
        make_screenshot('_init_page_load_not_finished')
      end
    end

  end

  # @param [String] tag (optional) - screenshot identifier - to distinguish files
  def make_screenshot(tag='')
    @browser.save_screenshot("./screenshots/#{ENV['JENKINS_BUILD_NUMBER']}_#{Time.now.strftime("%Y%m%d_%H%M%S")}#{tag}.png")
  end

  def has_expected_title_wait?(timeout=::PageObject.default_element_wait)
    return false unless self.respond_to?("has_expected_title?")
    begin
      wait_until(timeout) do
        begin
          has_expected_title? if self.respond_to?("has_expected_title?")
        rescue RuntimeError => e
          #puts "#{title} doesn't match expected title"
          sleep(0.5)
        end
      end
    rescue Selenium::WebDriver::Error::TimeOutError=>e
      has_expected_title?
    end
  end

  def wait_load_finished(element_name='load_finished', timeout=::PageObject.default_element_wait)
    el = "#{element_name}_element"
    if self.respond_to? el
      self.send(el).when_visible(timeout)
    end
  end



  def expected_visible_element(element_name, timeout=::PageObject.default_element_wait)
    define_method("has_expected_element_visible?") do
      retries=0
      begin
        self.respond_to? "#{element_name}_element" and self.send("#{element_name}_element").when_present timeout and self.send("#{element_name}_element").when_visible timeout
      rescue => e
        if !e.message.to_s.downcase.include? "element is no longer attached to the dom"
          puts e.message
          puts e.backtrace.join("\n")
          retries+=1
          if retries<6
            retry
          else
            raise
          end
        end
      end
    end
  end



end