require 'jira_formatter/jira_interface'

module JiraFormatter
  #responds to the cucumber formatter methods and parses the relevant information
  #only class to talk to cucumber libs!
  class Formatter
    #gets called by cucumber to initialize reporting
    def initialize(step_mother, io, options)
      @step_mother, @io, @options = step_mother, io, options
    end

    #gets called by cucumber after all features have completed
    #this is the starting point of all reporting
    def after_features(*args)
      JiraInterface.new.report(failed_and_passed_scenarios)
    end

    private

    def failed_and_passed_scenarios
      failures = @step_mother.scenarios(:failed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
      failed_scenario = formatted_scenarios(failures)
      passes = @failures = @step_mother.scenarios(:passed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
      passed_scenario = formatted_scenarios(passes)
      return remove_passed_scenario_if_it_has_failed(failed_scenario, passed_scenario)
    end

    def remove_passed_scenario_if_it_has_failed (failed_scenario, passed_scenario)
      failed_scenario.each { |failed|
        passed_scenario.each { |passed| passed.keep_if { passed[:feature] != failed[:feature] and passed[:scenario] != failed[:scenario] and passed[:steps] != failed[:steps] }
        passed.delete_if { passed[:feature].nil? }
        }
      }
      passes = Array.new
      passed_scenario.each { |passed| passes << passed unless passed.empty? }

      return failed_scenario + remove_dupes_from_passed_scenarios_list(passes)
    end

    def remove_dupes_from_passed_scenarios_list (sceanrio_list)
      sceanrio_list.uniq! { |x| x[:feature] and x[:scenario] }
      return sceanrio_list
    end


    def formatted_scenarios(sce)
      scenario_with_props = Array.new
      sce.each do |scenario|
        properties = Hash.new()
        properties[:run_time] = Time.new()
        properties[:tags] = scenario.source_tag_names
        properties[:status] = scenario.status
        properties[:exception] = scenario.exception if scenario.exception
        if scenario.class == Cucumber::Ast::Scenario
          properties = build_from_scenario(scenario).merge properties
        elsif scenario.class == Cucumber::Ast::OutlineTable::ExampleRow
          properties = build_from_example_row(scenario).merge properties
        end
        scenario_with_props << properties
      end
      return scenario_with_props
    end

    def build_from_scenario(scenario)
      properties = {
          :feature => scenario.feature.name.lines.first,
          :scenario => scenario.name.lines.first,
          :steps => get_all_steps_from_scenario(scenario)
      }
      return properties
    end

    def build_from_example_row(example_row)
      properties ={
          :feature => example_row.scenario_outline.feature.name.lines.first,
          :scenario => example_row.scenario_outline.name.lines.first,
          :steps => get_all_steps(example_row),
      }
      return properties
    end

    def get_all_steps(example_row)
      all_steps = "All steps specified in a Scenario Outline: \n"
      example_row.scenario_outline.raw_steps.each do |step|
        all_steps = "#{all_steps}" + "\n #{step.name}"
      end
      return all_steps.to_s
    end

    def get_all_steps_from_scenario(scenario)
      all_steps = "All steps specified in Scenario:"
      scenario.raw_steps.each do |step|
        all_steps = "#{all_steps}" + "\n #{step.name}"
      end
      return all_steps.to_s
    end

  end

end
