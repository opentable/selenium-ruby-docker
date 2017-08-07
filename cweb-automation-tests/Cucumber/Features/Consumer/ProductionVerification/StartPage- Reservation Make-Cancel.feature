@Reservations
@RestaurantProfile
@Web-bat-tier-0
@Team-WarMonkeys

Feature: [Start page - Reservation Make-Cancel] Registered user can make and cancel a reservation via start page in Production

  @regular-user-make-change-cancel
  Scenario Outline:   Register user makes, changes and cancels a reservation via Startaspx

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    And I start with a new browser with locale for "<domain>"
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click first available time slot in the search results
    And I click on Sign in link and login as registered user
    And I fill in "Phone" with "<phone>"
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from | days_fwd | party_sz | time     |    phone     |
    | .com   | start/?m=1 |    4     | 2 people | 12:00 PM | 415-555-6565 |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from | days_fwd | party_sz | time     | phone      |
    | .com.mx | start/?m=1 |    4     | 2 people | 12:00 PM | 4155556565 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from | days_fwd | party_sz | time  |    phone    |
    | .co.uk | start/?m=1 |    4     | 2        | 12:00 | 4155556565  |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from | days_fwd | party_sz | time  | phone      |
    | .de    | start/?m=1 |    4     | 2        | 12:00 | 4155556565 |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from | days_fwd  | party_sz | time  |     phone   |
    | .jp    | start/?m=1 |     4     | 2        | 12:00 |  4155556565 |

  @Region-EU @Domain-IE
  Scenarios:
    | domain | start_from | days_fwd | party_sz | time  | phone      |
    | .ie    | start/?m=1 |    4     | 2        | 12:00 | 1 402 9988 |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | start_from | days_fwd  | party_sz | time     |     phone   |
    | .com.au | start/?m=1 |     4     | 2        | 12:00 PM |  1300345345 |


  @pop-reservation
  Scenario Outline:   Register user makes and cancels a POP reservation via Startaspx

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    And I start with a new browser with locale for "<domain>"
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click any POP time slot for any restaurant
    And I click on Sign in link and login as registered user
    And I fill in "Phone" with "<phone>"
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from | days_fwd | party_sz | time     |    phone     |
    | .com   | start/?m=1 |    4     | 2 people | 12:00 PM | 415-555-6565 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from | days_fwd | party_sz | time  |    phone    |
    | .co.uk | start/?m=1 |    4     | 2        | 12:00 | 4155556565  |