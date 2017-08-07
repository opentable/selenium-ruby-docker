@reservation
@Web-bat-tier-0
@investigative-penguins

Feature: Affiliate Restaurants test Anonymous user

  Scenario Outline: Anonymous user makes booking in affiliated restaurant

    Given I start with a new browser
    And I set test domain to "<domain>"
    Then I navigate to url "<Affiliate_URL>"
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
    And I click "No, thank you"
    Then I should be on view page
    And I should see conf number on view page
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain |Affiliate_URL                                      | AffiliateLink      | AffiliatedRestaruantUrl        |  phone_number | days_fwd |  time   |     party_sz |AffiliatedRestaurant|AffiliatedRestaurantNLName|
    | .com   | http://www.opentable.com/restaurant/profile/108949| //www.opentable.com/s/affiliaterestaurantlist?affiliaterestaurantid=108949 | http://www.opentable.com/s/affiliaterestaurantlist?affiliaterestaurantid=108949 | 415-232-5555  |7 |6:30 PM | 2 |Guest Center - Consumer 3|guest-center-consumer-3|

  @Region-EU @Domain-COUK
  Scenarios:
    | domain |Affiliate_URL                                      | AffiliateLink      | AffiliatedRestaruantUrl        |  phone_number | days_fwd |  time   |     party_sz |AffiliatedRestaurant|AffiliatedRestaurantNLName|
    | .co.uk   | http://www.opentable.co.uk/restaurant/profile/44527| //www.opentable.co.uk/s/affiliaterestaurantlist?affiliaterestaurantid=44527 | http://www.opentable.co.uk/s/affiliaterestaurantlist?affiliaterestaurantid=44527 | 415-232-5555  |7 |18:30| 2 |OTC Bistro - United Kingdom|otc-bistro-united-kingdom|