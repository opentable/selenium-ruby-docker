@Web-bat-tier-2  @incomplete
@Team-WarMonkeys

Feature: [Restaurant Survey to ERB - HOLD]

  Scenario Outline: See Restaurant Survey on Details page

    Given I start with new browser with locale "<locale>" for domain "<domain>"
        And I am at a restaurant with a survey
        And I start making a reservation for the day 5 of next month
        When I set radio button "Survey Answer Yes"
        And I complete reservation
        Then I check hidden field "ERB note" value contains "=YES)"

    @Region-NA @Domain-COM @incomplete
    Scenarios:
      | domain | locale |
      | .com   | en     |


     Scenario Outline: See Restaurant Survey on ERB

      Given I complete reservation
      And I check hidden field "ERB note" value contains "=CARD MEMBER)"



    @Region-NA @Domain-COM @incomplete
    Scenarios:
      | domain |  survey_text               |
      | .com    |  Thank you for taking test |


