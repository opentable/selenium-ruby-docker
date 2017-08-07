@Team-Infra
@Attribution
@Attribution-AffiliatedRests
@Web-bat-tier-0
@Web-bat-tier-1
Feature:


  Scenario Outline: Affiliated restaurant restref path
    And I set test domain to "<domain>"
    Then I navigate to url "<Restref_URL>"
    And I add optimizely and affiliate cookie
    And I set reservation date to "<days_fwd>" days from today
    And I set reservation time to "<time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I should see link with href "<AffiliateLink>"
    And I click link with href "<AffiliateLink>"
    Then I move to the affiliated restaurant page with url "<AffiliatedRestaruantUrl>"
    Then I should see text "RESTAURANTS AFFILIATED WITH " on page
    And I should see affiliated restaurant "<AffiliatedRestaurant>" on page
    When I go to restaurant profile page with nURL "<AffiliatedRestaurantNLName>"
    And I click "Find a Table"
    Then I click any available time slot
    And I should be on details page
    And I fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RestRef"
    Then I verify Attribution "ResPoints" equal to "0"


  @Region-NA @Domain-COM
  Scenarios:
    | domain |            Restref_URL                                                 | AffiliateLink                                                             | AffiliatedRestaruantUrl                                                         | days_fwd |time    | party_sz |AffiliatedRestaurant   | AffiliatedRestaurantNLName|database        |    login          |
    | .com   |http://www.opentable.com/restaurant/profile/41605/reserve?restref=41605 | //www.opentable.com/s/affiliaterestaurantlist?affiliaterestaurantid=41605 | http://www.opentable.com/s/affiliaterestaurantlist?affiliaterestaurantid=41605  |7         |6:30 PM | 2        | Auto-Console-OTC-US2  |     Auto-Console-OTC-US2  |webdb-na-primary|automation/aut0m8er|
