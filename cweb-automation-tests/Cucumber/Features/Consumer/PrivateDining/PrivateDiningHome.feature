@privatedining
@Web-bat-tier-1
@Team-WarMonkeys

Feature: User should see private dining restaurant and should be able to go to the rest profile

  Scenario Outline: Private dining show restaurant
    When I navigate to url "<Private dining page>"
    Then I should see text "<privatediningrestname>" on page
    Then I click link with href "<pdrestprofile>"
    Then I should url "<privatediningurl>" and text "<text>" on new window

  @Domain-COM
  Scenarios:
    | Private dining page | privatediningrestname | pdrestprofile                               | text                     | privatediningurl                      |
    | private-dining      | 1300 on Fillmore      | /private-dining/restaurant/16609?lang=en-US | About Our Private Dining | private-dining/restaurant/16609?lang= |