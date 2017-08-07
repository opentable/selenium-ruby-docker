@Team-Infra
@Attribution
@Web-bat-tier-0
@Web-bat-tier-1
Feature: User Access RestRef path ( single.aspx) makes Reso and Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser
  @Attribution

  @Attribution-RestRef-Make

  Scenario Outline:  User visits Restaurants site, site has OT Restref path link (single.aspx), user makes a reservation there
  Verify points and attribution values,  Points = 0 ( Restref point suppressed), BillingType = RestRefReso, PrimarySourceType = RestRef
  Manual Case : Attribution - Pure RestREf Reso

    Given I set test domain to "<domain>"
    Then I navigate to url "<Restref_URL>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RestRef"
    Then I verify Attribution "ResPoints" equal to "0"




  @Region-NA @Domain-COM
  Scenarios:
    | domain | Restref_URL                                                                              | days_fwd | party_sz | time    | database         | login               |
    | .com   | http://www.opentable.com/restaurant/profile/(COM-POP2-RID)/reserve?restref=(COM-POP2-RID) |   2      | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | Restref_URL                                                                                  | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | http://www.opentable.co.uk/restaurant/profile/(COUK-POP2-RID)/reserve?restref=(COUK-POP2-RID) |    2     | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |
