@privatedining
@Web-bat-tier-1
@Team-WarMonkeys

Feature: User should be able to see translated text based on his choice

  Scenario Outline: Private dining User should choose any language and see translated contents
    When I navigate to url "<PDrest profile page>"
    Then I should see text "<AboutText>" on page
    Then I select private dining language "<language>"
    Then I should see text "<infoTxt>" on page

  @Domain-COM
  Scenarios:
    | PDrest profile page                     | AboutText                | language | infoTxt                                |
    | private-dining/restaurant/16609?lang=en | About Our Private Dining | Deutsch  | Informationen zu Privatveranstaltungen |
  @Domain-COM
  Scenarios:
    | PDrest profile page                     | AboutText                | language | infoTxt                                          |
    | private-dining/restaurant/16609?lang=en | About Our Private Dining | Espanol  | Acerca de nuestro servicio para Eventos Privados |
  @Domain-COM
  Scenarios:
    | PDrest profile page                     | AboutText                | language | infoTxt                         |
    | private-dining/restaurant/16609?lang=en | About Our Private Dining | Francais | À propos de notre Service privé |
  @Domain-COM
  Scenarios:
    | PDrest profile page                     | AboutText                | language | infoTxt                        |
    | private-dining/restaurant/16609?lang=en | About Our Private Dining | JP       | 『パーティー・貸切』に関する情報 |