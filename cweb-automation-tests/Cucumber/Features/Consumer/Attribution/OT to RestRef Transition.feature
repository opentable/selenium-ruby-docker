@Team-Infra
@Web-bat-tier-1
Feature: User Access OT Site then RestRef path (single.aspx) makes Reso Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution-OT-to-RestRef-Make

  Scenario Outline:  User starts from Opentable site, then navigates to restaurant site and completes reso thru rest site
  Verify points and attribution values,  Points = 100 , BillingType = OTReso, PrimarySourceType = None
  Manual Case : Attribution - OT to RestRef transition

    Given I set test domain to "<domain>"
    And I navigate to url "<start_from>"
    Then I select restaurant "<rest_name>"
    And I click "Find a Table"
    And I navigate to url "<Restref_URL>>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "OTReso"
    Then I verify Attribution "PrimarySourceType" equal to "None"
    Then I verify Attribution "ResPoints" equal to "100"


  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from | Restref_URL                                                      | rest_name       | days_fwd | party_sz | time    | database         | login               |
    | .com   | start/?m=1 | restaurant/profile/(COM-POP2-RID)/reserve?restref=(COM-POP2-RID) | (COM-POP2-Name) | 3        | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from | Restref_URL                                                         | rest_name        | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | start/?m=1 | restaurant/profile/(COUK-POP2-RID)/reserve?restref=(COUK-POP2-RID)  | (COUK-POP2-Name) |   3      | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |
