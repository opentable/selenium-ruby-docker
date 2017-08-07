@Team-Infra
@Web-bat-tier-1
Feature: Reservation using a Referrer, referrer is Points Off

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution

  @Attribution-Referrer-PointsOff-Make

  Scenario Outline:  PartnerID not supplied , RestRefID not supplied , RefID = referrer w/ points off
  Expected Result: Points suppressed ( ReservationVW.ResPoints = 0 , BillingType = 'OTReso' ,
  PrimarySourceType = 'RefID' ; ResPointsRuleLog.PointsRuleID = 14 = ReferrerSuppressedPoints )

    Given I start with a new browser
    And I set test domain to "<domain>"
    Then I connect to database "<database>" as "<login>"
    Then I execute Update SQL "update referrer set ExcludeFromBillingTypeRule = 0,ExcludeFromPrimarySourceTypeRule = 0,PointsOn = 0 where ReferrerID = <refid>"
    Then I recache consumer website for "CacheReferrers" item
    And I close the browser
    Then I navigate to url "<URL>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "OTReso"
    Then I verify Attribution "PrimarySourceType" equal to "RefID"
    Then I verify Attribution "ResPoints" equal to "0"
    Then I verify Attribution "ReferrerID" equal to "<refid>"


  @Region-NA @Domain-COM
  Scenarios:
    | domain | URL                                                                                               | days_fwd | party_sz | time    | database         | login               | refid |
      | .com   | http://www.opentable.com/restaurant/profile/(COM-POP2-RID)/reserve?rid=(COM-POP2-RID)&&ref=408  | 2        | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er | 408   |

  @Region-EU @Domain-CO.UK @incomplete
  Scenarios:
    | domain | URL                                                                                                | days_fwd | party_sz | time  | database         | login               | refid |
    | .co.uk | http://www.opentable.co.uk/restaurant/profile/(COUK-POP2-RID)/reserve?rid=(COUK-POP2-RID)?ref=10783 | 2        | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er | 10783 |

