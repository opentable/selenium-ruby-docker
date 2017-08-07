@privatedining
@Web-bat-tier-1
@Team-WarMonkeys

Feature: Verify PD NLurl works

  Scenario Outline: Private dining NLurl should work for all domains
    When I navigate to url "<NLurl>"
    Then I should see text "<Headerstring>" on page
    Then I should see text "<contactRest>" on page
    And I should see private dining filters on page
    And I should not see link with exact text "<Hidden>"
    And I should see "<number>" of special occasion links on page
    And I close the browser

  @Domain-COM
    Scenarios:
      | NLurl                                                               | Headerstring                                              | contactRest        | Hidden                       |number |
      | http://www.opentable.com/seattle-rehearsal-dinner-restaurants       | Seattle / Eastern Washington Rehearsal Dinner Restaurants | Contact Restaurant | Rehearsal Dinner Restaurants |6      |
      | http://www.opentable.com/seattle-birthday-party-venues              | Seattle / Eastern Washington Birthday Party Venues        | Contact Restaurant | Birthday Party Venues        |6       |
      | http://www.opentable.com/san-francisco-rehearsal-dinner-restaurants | San Francisco Bay Area Rehearsal Dinner Restaurants       | Contact Restaurant | Rehearsal Dinner Restaurants |6       |
      | http://www.opentable.com/hollywood-rehearsal-dinner-restaurants     | Los Angeles Rehearsal Dinner Restaurants                  | Contact Restaurant | Rehearsal Dinner Restaurants |6       |
