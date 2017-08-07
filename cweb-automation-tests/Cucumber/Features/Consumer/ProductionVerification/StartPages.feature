@Startpage
@Web-bat-tier-0

Feature: Start page sites checks

  Scenario Outline: Start page site checks for start home and metro page

    Given I set test domain to "<domain>"
    And I navigate to url "<start_from>"
    And I should be on URL containing "start/home"
    And I should see text "<home_msg>" on page
    Then I find and click the metro link "/<metro_url>" in the Featured Areas
    And I should be on URL containing "<metro_url>"
    And I should see text "<start_home_msg>" on page

  @Region-NA @Domain-COM
  Scenarios:
    | domain |    start_from     |               home_msg                   |         metro_url        |        start_home_msg     |
    | .com   | www.opentable.com |Make restaurant reservations the easy way | san-francisco-restaurants| San Francisco Restaurants |


  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  |   start_from                 |             home_msg                           |          metro_url      |        start_home_msg            |
    | .com.mx | www.opentable.com.mx?lang=es | Reserve en restaurantes de la manera más fácil | mexico-city-restaurants | RESTAURANTES EN MÉXICO |


  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |    start_from       |               home_msg                   |         metro_url  | start_home_msg    |
    | .co.uk | www.opentable.co.uk |Make restaurant reservations the easy way | london-restaurants | London Restaurants|

  @Region-EU @Domain-DE
  Scenarios:
    | domain |    start_from            |               home_msg        |   metro_url         |    start_home_msg      |
    | .de    | www.opentable.de?lang=de |Restaurants online reservieren | c/munchen-restaurants | RESTAURANTS MÜNCHEN |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain |    start_from            |               home_msg              |        metro_url  |    start_home_msg |
    | .jp    | www.opentable.jp?lang=ja |レストランのオンライン予約は驚くほど簡単！ | tokyo-restaurants | 東京のレストラン    |

  @Region-EU @Domain-IE
  Scenarios:
    | domain |    start_from    |               home_msg                   |       metro_url    |  start_home_msg    |
    | .ie    | www.opentable.ie |Make restaurant reservations the easy way | dublin-restaurants | Dublin Restaurants |

  @Region-Asia @Domain-AU
  Scenarios:
    |  domain |    start_from        |                  home_msg                |          metro_url |      start_home_msg     |
    | .com.au | www.opentable.com.au |Make restaurant reservations the easy way | sydney-restaurants | Sydney / NSW Restaurants|


  Scenario Outline: Start page site checks for Points of Interest

    Given I set test domain to "<domain>"
    And I navigate to url "<start_from>"
    Then I find and click the metro link "//<metro_url>" in the POI Areas
    And I should be on URL containing "<metro_url>"
    And I should see text "<poi_home_msg>" on page

  @Region-NA @Domain-COM
  Scenarios:
    | domain |           start_from      |                                   metro_url                                    |               poi_home_msg                           |
    | .com   | san-francisco-restaurants | www.opentable.com/landmark/restaurants-near-chinatown-san-francisco-887-clay-st| Restaurants near Chinatown, San Francisco California |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    |   domain |            start_from     |                                        metro_url         |       poi_home_msg               |
    | .jp      | tokyo-restaurants?lang=en | www.opentable.jp/landmark/restaurants-near-hikawa-shrine | Restaurants near Hikawa Shrine   |


  Scenario Outline: Start page site checks for Restaurant Profile page

    Given I set test domain to "<domain>"
    Then I navigate to url "<restaurant_profile>"
    And I should see text "<rest_name>" on page
    And I should see text "<about_rest>" on page
    And I should see link with text "<reservation>"
    And I should see link with text "<about>"
    And I should see link with text "<review>"

  @Region-NA @Domain-COM
  Scenarios:
    | domain | restaurant_profile                          |     rest_name              | reservation | about | review  |            about_rest            |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) | Reservation | About | Reviews | About (COM-GuestCenterRest-Name) |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | restaurant_profile                                  |    rest_name              | reservation |   about   | review  |         about_rest          |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)?lang=es | (MX-GuestCenterRest-Name) | Reservación | Acerca de | Reseñas | Acerca de GC - CW Auto MX 1 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | restaurant_profile                            |     rest_name              | reservation | about | review  |           about_rest              |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name)| Reservation | About | Reviews | About (COUK-GuestCenterRest-Name) |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | restaurant_profile                                  |     rest_name             | reservation  |      about      |    review   |             about_rest                    |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | (DE-GuestCenterRest-Name) | Reservierung | Restaurant-Info | Bewertungen |Informationen zu (DE-GuestCenterRest-Name) |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | restaurant_profile                                  |     rest_name             | reservation |   about |   review   |           about_rest                |
    | .jp    | restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | (JP-GuestCenterRest-Name) |     予約     | 店舗情報 | 評価・口コミ | 『(JP-GuestCenterRest-Name)』について|

  @Region-EU @Domain-IE
  Scenarios:
    | domain | restaurant_profile                          |     rest_name             | reservation | about | review  |          about_rest             |
    | .ie    | restaurant/profile/(IE-GuestCenterRest-RID) | (IE-GuestCenterRest-Name) | Reservation | About | Reviews | About (IE-GuestCenterRest-Name) |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | restaurant_profile                          |     rest_name             | reservation | about | review  |         about_rest             |
    | .com.au | restaurant/profile/(AU-GuestCenterRest-RID) | (AU-GuestCenterRest-Name) | Reservation | About | Reviews | About (AU-GuestCenterRest-Name)|

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    | domain     | restaurant_profile                                    |       rest_name             | reservation |   about  |   review  |          about_rest                   |
    | .com/fr-ca | restaurant/profile/(FRCA-GuestCenterRest-RID)?lang=fr | (FRCA-GuestCenterRest-Name) | Réservation | À propos | Critiques |À propos de (FRCA-GuestCenterRest-Name)|