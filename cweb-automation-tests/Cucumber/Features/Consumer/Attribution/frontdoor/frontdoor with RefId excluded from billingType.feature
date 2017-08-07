@Team-Infra
@Web-bat-tier-1
Feature: User Access frontdoor path with Refid [ excluded BillingType] and makes Reso Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution

  @Attribution-frontdoor-Ref-ExcludeBilling

  Scenario Outline:  User Access restaurant site (frontdoor with RefID )makes Reso,
  Referrer is set as excluded from BillingType.
  Verify Attribution values
  Verify points and attribution values,  Points = 0 , BillingType = RestRefReso, PrimarySourceType = Refid


    Given I set test domain to "<domain>"
    Then I connect to database "<database>" as "<login>"
    Then I execute Update SQL "update referrer set ExcludeFromBillingTypeRule = 1,ExcludeFromPrimarySourceTypeRule = 0,PointsOn = 1 where ReferrerID = <refid>"
    Then I recache consumer website for "CacheReferrers" item
    And I close the browser
    Then I navigate to url "<url>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RefID"
    Then I verify Attribution "ResPoints" equal to "0"


  @Region-NA @Domain-COM
  Scenarios:
    | domain | url                                                                                                             | refid | days_fwd | party_sz | time    | database         | login               |
    | .com   | http://www.opentable.com/frontdoor/singlerest.aspx?rid=(COM-POP2-RID)&mode=short&restref=(COM-POP2-RID)&ref=406 | 406   | 2        | 2 people | 9:00 PM | webdb-na-primary | automation/aut0m8er |

  ## Getting 100 points instead of 0
  @Region-EU @Domain-CO.UK @incomplete
  Scenarios:
    | domain | url                                                                                                                  | refid | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | http://www.opentable.co.uk/frontdoor/singlerest.aspx?rid=(COUK-POP2-RID)&mode=short&restref=(COUK-POP2-RID)&ref=2528 | 2528  |   2      | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |



