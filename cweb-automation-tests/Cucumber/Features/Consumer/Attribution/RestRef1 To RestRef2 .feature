@Team-Infra
@Web-bat-tier-0
@Web-bat-tier-1
Feature: User Access RestRef path RID-1 then Goes RestRef RID-2 and makes Reso in RID2 Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser
  @Attribution
  @Attribution-Restref1-to-Restref2-Make

  Scenario Outline:  User Access RestRef path RID-1 then Goes RestRef RID-2 and makes Reso in RID2
  Manual Case : Attribution - RestREf to OT Transition

    Given I set test domain to "<domain>"
    And I navigate to url "<RestRef_RID1>"
    And I click "Find a Table"
    And I navigate to url "<RestRef_RID2>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "RestRefRID" equal to "<RID2>"
    Then I verify Attribution "ResPoints" equal to "0"

  @Region-NA @Domain-COM
  Scenarios:
    | domain | RestRef_RID1                                                                                              | RestRef_RID2                                                                   | RID2           | days_fwd | party_sz | time    | database         | login               |
    | .com   | http://www.opentable.com/restaurant/profile/(COM-AlwaysOnline-RID)/reserve?restref=(COM-AlwaysOnline-RID) | http://www.opentable.com/single.aspx?rid=(COM-POP2-RID)&restref=(COM-POP2-RID) | (COM-POP2-RID) |    2     | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | RestRef_RID1                                                                                                  | RestRef_RID2                                                                        | RID2             | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | http://www.opentable.co.uk/restaurant/profile/(COUK-AlwaysOnline-RID)/reserve?restref=(COUK-AlwaysOnline-RID) | http://www.opentable.co.uk/single.aspx?rid=(COUK-POP2-RID)&restref=(COUK-POP2-RID)  | (COUK-POP2-RID)  |    2     | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |
