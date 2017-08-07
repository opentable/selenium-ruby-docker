@Concierge
@Web-bat-tier-2
@Team-WarMonkeys

Feature: [Concierge Run Reports For Last Month] A concierge can run a report to view reservations of each restaurant.

  Background:

  Given I start with a new browser

  @Concierge-reports

  Scenario Outline:

    Given I set test domain to "<domain>"
    When I navigate to url "<concierge_login_page>"
    Then I login as concierge with username "<concierge user>" and password "<password>"
    Then I click "My Profile"
    Then I click link with href "<url>" without regex
    Then I should be on URL containing "<url>"
    Then I click "Create Report"
    Then I should be on URL containing "<url>"
    And I should see element "Restaurant" on page
    And I should see element "Reservations" on page
    And I should see element "Covers" on page
    And I should see element "Cancellations" on page
    And I should see element "No Shows" on page
    And I should see element "No Show Rate" on page
    Then I click "Show Reservation Details"
    Then I verify number of seated reservations matches number of row in Reservation Details table


  @Region-NA @Domain-COM
  Scenarios:
    | domain | concierge_login_page | concierge user    | password |url                                       |
    | .com   | conciergelogin.aspx  | us_auto_concierge | password |http://www.opentable.com/createreport.aspx|

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | concierge_login_page | concierge user    | password | url                                         |
    | .co.uk | conciergelogin.aspx  | uk_auto_concierge | password | http://www.opentable.co.uk/createreport.aspx|

  @Region-EU @Domain-DE
  Scenarios:
    | domain | concierge_login_page | concierge user    | password |  url                                      |
    | .de    | conciergelogin.aspx  | de_auto_concierge | password | http://www.opentable.de/createreport.aspx |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | concierge_login_page | concierge user    | password | url                                      |
    | .jp    | conciergelogin.aspx  | jp_auto_concierge | password | http://www.opentable.jp/createreport.aspx|