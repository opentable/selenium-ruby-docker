@privatedining
@Web-bat-tier-1
@Team-WarMonkeys

Feature: User should be able to submit form to contact restaurant

  Scenario Outline: Private dining contact restaurant
    When I navigate to url "<PDrest profile page>"
    Then I should see text "<text>" on page
    Then I fill in random private dining user info
    Then I should see text "Thanks! Your private dining request has been received by the restaurant." on page

  @Domain-COM
  Scenarios:
    | PDrest profile page                     | text                     |
    | private-dining/restaurant/16609?lang=en | About Our Private Dining |
  @Domain-COUK
  Scenarios:
    | PDrest profile page                     | text                     |
    | http://www.opentable.co.uk/private-dining/restaurant/96990?lang=en-GB| About Our Private Dining |