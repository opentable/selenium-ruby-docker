@Team-Infra
@Web-bat-tier-1
Feature: ExclusiveVille rest site passes Referrer (Points Off), no RestRef passed.

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution

  @Attribution-Referrer-PointsOff-Exclusive-Make

  Scenario Outline:  non-concierge user , RID in ExclusiveVille , slot w/o POP/DIP , PartnerID=w/o patner , RestRefID not supplied, RefID = referrer w/points off
  Expected Result: Points suppressed ( ReservationVW.ResPoints = 0 , BillingType = 'RestRefReso' , PrimarySourceType = Referrer ;
  ResPointsRuleLog.PointsRuleID = 5 = RestRefSuppressedPoints)



    Given I set test domain to "<domain>"
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
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RefID"
    Then I verify Attribution "ResPoints" equal to "0"
    Then I verify Attribution "ReferrerID" equal to "<refid>"
    Then I verify Attribution "RestRefRID" equal to "<rid>"



  @Region-NA @Domain-COM
  Scenarios:
    | domain | URL                                                                          | rid                 | days_fwd | party_sz | time    | database         | login               | refid |
    | .com   | http://www.opentable.com/ism/singlerest.aspx?rid=(COM-Exclusive-RID)&ref=408 | (COM-Exclusive-RID) | 2        | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er | 408   |

  ##BillingType is set to OTReso instead of RestRefReso  Per Charles, ref takes precedence of restref so this is correct.  Then .com is wrong
  @Region-EU @Domain-CO.UK @incomplete
  Scenarios:
    | domain | URL                                                                                | rid                  | days_fwd | party_sz | time  | database         | login               | refid |
    | .co.uk | http://www.opentable.co.uk/ism/singlerest.aspx?rid=(COUK-Exclusive-RID)&ref=10783  | (COUK-Exclusive-RID) | 2        | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er | 10783   |

