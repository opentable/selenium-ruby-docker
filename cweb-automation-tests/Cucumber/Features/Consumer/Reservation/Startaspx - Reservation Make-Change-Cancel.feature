@StartPageReso
@Web-bat-tier-1
@Reservations

Feature: [Start.aspx - Reservation Make-Change-Cancel] Anyone can make, change and cancel a reservation from start.aspx

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @admin-user-make-change-cancel
  Scenario Outline:   Admin user makes, changes and cancels a reservation via Startaspx using old booking flow

    Given I set test domain to "<domain>"
    And I have registered admin user with random email
    And I login as registered user
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click first available time slot in the search results
    And I click "Edit Diner List"
    And I add and select diner
    And I fill in "Phone" with "4155556565"
    And I fill in  CC number "4111111111111111" and exp date if needed
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                | days_fwd | party_sz | time     |
    | .com   | san-francisco-restaurants | 2        | 2 people | 12:00 PM |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    |    domain     | start_from                             | days_fwd | party_sz | time     |
    | .com.mx/en-US | mexico-city-restaurants?mn=110&lang=en | 2        | 2 people | 12:00 PM |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                             | days_fwd | party_sz | time     |
    | .com.mx | mexico-city-restaurants?mn=110&lang=es | 2        | 2 people | 12:00 PM |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from         | days_fwd | party_sz | time  |
    | .co.uk | london-restaurants | 2        | 2        | 12:00 |

  ##Auto-231
  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                 | days_fwd | party_sz | time  |
    | .de    | berlin-restaurants?lang=de |  7       | 4        | 12:00 |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                | days_fwd | party_sz | time  |
    | .jp    | tokyo-restaurants?lang=ja | 2        | 2        | 12:00 |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    |   domain  | start_from          | days_fwd | party_sz | time  |
    | .jp/en-US | start/?m=1&lang=en  | 2        | 2        | 12:00 |

  #Add diner link not available
  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    | domain     |     start_from              | days_fwd  | party_sz | time    |
    | .com/fr-CA | toronto-restaurants?lang=fr |  2        | 2        | 12:00   |

  @anony-user-make-change-cancel
  Scenario Outline: Anonymous user makes, changes and cancels a reservation via Startaspx using new booking flow

    Given I set test domain to "<domain>"
    And I set test user first name "<fname>"
    And I set test user last name "<lname>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click first available time slot in the search results
    And I fill in "Diner First Name" with "<fname>"
    And I fill in "Diner Last Name" with "<lname>"
    And I fill in "Phone" with "<phone>"
    And I fill in "Email" with random email
    And I fill in  CC number "4111111111111111" and exp date if needed
    And I complete reservation
    And I convert to regular user
    Then I verify reservation details on view page
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain |      start_from           | fname | lname | phone        | days_fwd | party_sz | time     |
    | .com   | san-francisco-restaurants | Joe   | Auto  | 415-555-1212 | 7        | 2 people | 11:00 AM |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |   start_from      | fname | lname | phone        | days_fwd | party_sz | time  |
    | .co.uk | london-restaurants| Joe   | Auto  | 20 7493 8000 | 7        | 2 people | 11:00 |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from               | fname | lname | phone       | days_fwd | party_sz | time  |
    | .de    | c/munchen-restaurants?lang=de | Joe   | Auto  | 30 202300   | 7        | 2        | 11:00 |

  #no availability during modify
  @Region-Asia @Domain-AU @incomplete
  Scenarios:
    | domain  | start_from         | fname | lname |  phone      | days_fwd | party_sz | time     |
    | .com.au | sydney-restaurants | Joe   | Auto  | 2 9266 2000 | 7        | 2        | 11:00 AM |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                     | fname | lname | phone        | days_fwd | party_sz   | time     |
    | .com.mx | mexico-city-restaurants?lang=es| Joe   | Auto  | 55 5130 5300 | 7        | 2 personas | 11:00 AM |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                | fname | lname |  phone       | days_fwd | party_sz | time  |
    | .jp    | tokyo-restaurants?lang=ja | Joe   | Auto  | 33-3344-5111 | 7        | 2        | 11:00 |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    | domain    | start_from                | fname | lname | phone        | days_fwd | party_sz | time  |
    | .jp/en-US | start/?m=1&lang=en | Joe   | Auto  | 33-3344-5111 | 7        |  2       | 11:00 |

  #Blocked by AUTO-3 or AUTO/16 AUTO-254
  @Region-NA @Domain-COM.fr-CA @incomplete
  Scenarios:
    | domain     | start_from                   | fname | lname | phone        | days_fwd | party_sz | time    |
    | .com/fr-CA | toronto-restaurants?lang=fr  | Joe   | Auto  | 514-872-0311 | 7        | 2 people | 11:00   |

  @anony-user-make-change-cancel @startpage_team
  Scenario Outline: Anonymous user make, change and cancel a reservation in japanese [JP] via startaspx

    Given I set test domain to "<domain>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click first available time slot in the search results
    Then I fill in "Kanji First" with "<kanji_first_name>"
    Then I fill in "Kanji Last" with "<kanji_last_name>"
    Then I fill in "Kana First" with "<kana_first_name>"
    Then I fill in "Kana Last" with "<kana_last_name>"
    And I fill in "Phone" with "4155556565"
    And I fill in "Email" with random email
    And I complete reservation
    Then I click "No, thank you"
    Then I cancel reservation

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                | days_fwd | party_sz | time  | kanji_first_name | kanji_last_name | kana_first_name | kana_last_name |
    | .jp    | tokyo-restaurants?lang=ja |2         | 2        | 19:00 |  高浜 茂          | 高浜 茂          | レストラン       | プロモーション   |
