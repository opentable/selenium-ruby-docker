require 'jiralicious'
require 'jira_formatter/issue'
require 'jira_formatter/jira_configuration'

module JiraFormatter
  class JiraInterface
    
    def initialize
      JiraConfiguration.instance.configure
    end
    
    def report(scenarios)
      scenarios.each do |scenario|
        begin
          Issue.new(scenario)
        rescue => e
          puts "##teamcity[buildStatus status='FAILURE' text='Jira Reporting Failed']"
          puts "jira reporting failed for #{scenario}\n#{e.class}#{e.message}\n#{e.backtrace}"
          unless ENV['JIRA_FORMATTER_SWALLOW_ERRORS'] == 'true'
            raise e
          end
        end
      end
    end
  end
end