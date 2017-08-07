@Team-Infra
@Attribution
@Web-bat-tier-1
Feature: User Access RestRef path ( single.aspx) URL has valid refid, complete Reso Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser



  @Attribution-RestRef-Ref-Exclude-Billing

  Scenario Outline:  User visits Restaurants site, site has OT Restref LInk with refid (valid), Referrer is set as ExcludeFromBillingTypeRule=1,
  ExcludeFromPrimarySourceTypeRule=0, PointOff = 1  user makes a reservation there
  Verify points and attribution values, Points = 0 (RestRef rule) ,BillingType = RestRefReso, PrimarySourceType = RefID
  Manual Case : Attribution - RestRef with Referrer

    
    Given I set test domain to "<domain>"
    Then I connect to database "<database>" as "<login>"
    Then I execute Update SQL "update referrer set ExcludeFromBillingTypeRule = 1,ExcludeFromPrimarySourceTypeRule = 0,PointsOn = 1 where ReferrerID = <refid>"
    Then I recache consumer website for "CacheReferrers" item
    And I close the browser
    Then I navigate to url "<Restref_URL>"
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
    | domain | Restref_URL                                                                                      | days_fwd | party_sz | time    | database         | login               | refid |
    | .com   | http://www.opentable.com/restaurant/profile/(COM-POP2-RID)/reserve?restref=(COM-POP2-RID)&ref=406 | 2        | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er | 406   |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | Restref_URL                                                                                          | days_fwd | party_sz | time  | database         | login              | refid |
    | .co.uk | http://www.opentable.co.uk/restaurant/profile/(COUK-POP2-RID)/reserve?restref=(COUK-POP2-RID)&ref=148 | 2        | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |148   |
