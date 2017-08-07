require 'digest/md5'

module JiraFormatter
  class Issue

    def initialize(scenario)
      @hash = scenario
      puts "Reporting to Jira: \"#{long_summary}\""
      search_results = search_for_existing_issue
      if search_results.num_results == 0
        build_issue
      else
        load_issue(search_results)
      end
      update_issue
    end

    private


    def long_summary
      "Feature: #{@hash[:feature]} | Scenario: #{@hash[:scenario]}"
    end
    
    def short_summary
      "Feature: #{@hash[:feature]}".gsub("\n", " ") + "   in #{ENV['TEST_ENVIRONMENT']}"
    end

    def tags
      if ENV['TEST_ENVIRONMENT']
        @hash[:tags] + [ENV['TEST_ENVIRONMENT']]
      else
        @hash[:tags]
      end
    end

    def steps_and_exception_info
      "#{@hash[:steps]}" + "\n" +"Exception happened: \n\n" + "#{@hash[:exception]}"
    end

    def search_for_existing_issue
      search_string = "project = #{JiraConfiguration.instance.project['id']} AND summary ~ \"#{short_summary}\""
      escaped_search_string = search_string.gsub(/[\[\]\+\-\']/, "")
      Jiralicious.search(escaped_search_string)
    end

    def build_issue
      @jissue = Jiralicious::Issue.new
      @jissue.fields.set_id("project", JiraConfiguration.instance.project['id'])
      @jissue.fields.set("summary", short_summary)
      @jissue.fields.set_id("issuetype", JiraConfiguration.instance.default_issue_type['id'])
      @jissue.fields.set('labels', tags)
      @jissue.fields.set("description", steps_and_exception_info)
      @jissue.save!
    end

    def load_issue(search_results)
      @jissue = Jiralicious::Issue.find(search_results.issues[0].jira_key)
      @jissue.fields.set('labels', tags)
      @jissue.save
    end

    def update_issue
      transition_issue
      add_comments
    end

    def status
      @jissue.fields.fields_current['status']['id'].to_i
    end

    def transition_issue
      transition = JiraConfiguration.instance.transitions[status][@hash[:status].to_s]
      if transition
        Jiralicious::Issue.transition("#{@jissue.jira_self}/transitions", {"transition" => "#{transition}"})
      end
    end

    def add_comments
      comment = "Test #{@hash[:status]} on #{@hash[:run_time]}\nBuild: http://teamcity/viewLog.html?buildId=#{ENV['BUILD_ID']}\n#{long_summary}"
      @jissue.comments.add comment
    end
  end
end
