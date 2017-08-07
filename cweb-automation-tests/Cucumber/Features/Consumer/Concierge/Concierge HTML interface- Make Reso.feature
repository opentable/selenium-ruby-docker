@Concierge
@Web-bat-tier-1
@Team-WarMonkeys

Feature: [Concierge HTML interface- Make Reso] As Concierge user I can make/change/cancel reservations

  @Concierge-HTML-interface-Make-Reso

  Scenario Outline: Concierge HTML interface -  Make Reso
    Manual Case(s): Concierge HTML interface-  Make Reso

    Given I set test domain to "<domain>"
    And I login to CHARM
    And I add my IP address to partner "<partner>" in CHARM
    When I start with a new browser
    And I navigate to url "<concierge_html_url>"
    Then I set Date "<days>" days forward
    Then I fill in "Rid" with "<RID>"
  # @ToDo: have concierge html form rename Metro input field to MetroID instead of 'g'
    Then I fill in "Metro ID" with "<metro_id>"
    Then I fill in "First Name" with random text
    Then I fill in "Last Name" with random text
    And I click "Submit"
    Then I should see exact search time selected

    When I click "Reserve"
    Then I should see confirmation message

    Then I cancel reservation
    Then I should see text "The reservation has been cancelled successfully." on page

    Then I close the browser

  @Region-NA @Domain-COM
  Scenarios:
    | domain | concierge_html_url                    | RID                       | metro_id | partner   | days |
    | .com   | http://www.opentable.com/cs_frame.asp | (COM-GuestCenterRest-RID) | 1        | Concierge |  6   |

