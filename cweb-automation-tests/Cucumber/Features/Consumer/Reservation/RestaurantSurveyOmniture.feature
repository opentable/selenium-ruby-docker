@Web-bat-tier-2  @incomplete
@Team-WarMonkeys

Feature: [Restaurant Survey Omniture - HOLD]

  Scenario Outline: Restaurant with a survey should display Restaurant Survey on Details page
      Given I start with new browser with locale "<locale>" for domain "<domain>"
      And I am at a restaurant with a survey
      When I start making a reservation for the day 5 of next month
      Then I should see a survey question
      And I should see the Omniture key "s.eVar10" with the value "RestaurantSurvey" in the page source

    @Region-NA @Domain-COM  @incomplete
    Scenarios:
      | domain | locale |
      | .com   | en     |

    Scenario Outline: Restaurant without survey should not display Restaurant Survey on Details page
      Given I start with new browser with locale "<locale>" for domain "<domain>"
      And I am at a restaurant without a survey
      When I start making a reservation for the day 5 of next month
      Then I should not see a survey question
      And I should not see the Omniture key "s.eVar10" with the value "RestaurantSurvey" in the page source

    @Region-NA @Domain-COM  @incomplete
    Scenarios:
      | domain | locale |
      | .com   | en     |

    Scenario Outline: Diner selects Yes in Restaurant Survey
      Given I start with new browser with locale "<locale>" for domain "<domain>"
      And I am at a restaurant with a survey with an input field
      When I start making a reservation for the day 5 of next month
      And I set radio button "Survey Answer Yes"
      Then I should see the Omniture key "s.event74" with the value "surveyyes" in the page source

    @Region-NA @Domain-COM  @incomplete
    Scenarios:
      | domain | locale |
      | .com   | en     |


    Scenario Outline: Diner selects No in Restaurant Survey
      Given I start with new browser with locale "<locale>" for domain "<domain>"
      And I am at a restaurant with a survey
      When I start making a reservation for the day 5 of next month
      And I set radio button "Survey Answer No"
      Then I should see the Omniture key "s.event74" with the value "surveyno" in the page source

    @Region-NA @Domain-COM @incomplete
    Scenarios:
      | domain | locale |
      | .com   | en     |


