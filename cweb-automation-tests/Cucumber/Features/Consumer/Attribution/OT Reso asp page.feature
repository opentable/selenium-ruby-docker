@Team-Infra
@Web-bat-tier-1
Feature: Anonymous user makes a Reservation using OT Site and Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution-OT-asp-Make

  Scenario Outline:   Anonymous User access OT site and makes a reso, verify points and attribution values
  Points = 100, BillingType = OTReso, PrimarySourceType = None
  Manual Case(s): Anonymous OT Path - Make

    Given I set test domain to "<domain>"
    Then I navigate to url "<start_from_asp>"
    ## Is step 17 still needed as default.asp is directed to the main metro page?
    Then I navigate to url "<Go_To_Metro>"
    And I set reservation date to "<days_fwd>" days from today
    Then I select restaurant "<rest_name>"
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "OTReso"
    Then I verify Attribution "PrimarySourceType" equal to "None"
    Then I verify Attribution "ResPoints" equal to "100"


  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from_asp | Go_To_Metro| rest_name        | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | default.asp    | start/?m=1 | (COUK-POP2-Name) |   2      | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from_asp | Go_To_Metro| rest_name       | days_fwd | party_sz | time    | database         | login               |
    | .com   | default.asp    | start/?m=1 | (COM-POP2-Name) |    2     | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er |

