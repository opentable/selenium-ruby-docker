@Reservations
@RestaurantProfile
@Web-bat-tier-0
@Team-WarMonkeys

Feature: [Restaurant Profile - Reservation Make-Cancel] Any user can make and cancel a reservation via restaurant/profile in Production

  @regular-user-make-cancel
  Scenario Outline: Registered user makes and cancels a reservation via restaurant profile

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I fill in "Phone" with "<phone>"
    And I click label with text "No offer thanks" if there
    And I complete reservation
    Then I verify reservation details on view page
    ##AUTO-248: Points are all messed
    Then I verify restref is not set and points is <points>
    Then I cancel reservation
    Then I click "Sign Out"

###  Points are set as 0 in PRODUCTION for Demoland Rids
  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                  |     rest_name              |days_fwd | party_sz |  time    |   phone    | points |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) |   3     | 2 people |  3:00 PM | 1234567890 |   0    |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                          |    rest_name              | days_fwd | party_sz   | time    |    phone   | points |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)?lang=es | (MX-GuestCenterRest-Name) |    3     | 2 personas | 3:00 PM | 1234567890 |   0    |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                    |     rest_name              | days_fwd | party_sz | time  |    phone   | points |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name)|     3    | 2        | 15:00 | 1234567890 |    0   |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                          |     rest_name            | days_fwd | party_sz |  time  |    phone   | points |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | (DE-GuestCenterRest-Name)|     3    | 2        |  15:00 | 1234567890 |    0   |

  @Region-EU @Domain-IE
  Scenarios:
    | domain | start_from                                 |  rest_name                |  days_fwd | party_sz | time  |    phone  | points |
    | .ie    |restaurant/profile/(IE-GuestCenterRest-RID) | (IE-GuestCenterRest-Name) |    3      | 2 people | 15:00 | 123456789 |   0    |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                                         |  rest_name                |days_fwd | party_sz | time  |    phone   | points |
    | .jp    |restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | (JP-GuestCenterRest-Name) |   3     | 2 people | 15:00 | 1234567890 |   0    |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | start_from                                 |  rest_name                |days_fwd | party_sz | time    |    phone   | points |
    | .com.au |restaurant/profile/(AU-GuestCenterRest-RID) | (AU-GuestCenterRest-Name) |   3     | 2 people | 3:00 PM | 1300345345 |   0    |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    |   domain   | start_from                                           |       rest_name             |days_fwd | party_sz |  time  |   phone    | points |
    | .com/fr-CA |restaurant/profile/(FRCA-GuestCenterRest-RID)?lang=fr | (FRCA-GuestCenterRest-Name) |   3     | 2 people |  15:00 | 1234567890 |    0   |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    |   domain  | start_from                                         |  rest_name                |days_fwd | party_sz | time  |    phone   | points |
    | .jp/en-US |restaurant/profile/(JP-GuestCenterRest-RID)?lang=en | (JP-GuestCenterRest-Name) |   3     | 2 people | 15:00 | 1234567890 |   0    |

  @concierge-user-make-cancel
  Scenario Outline: Concierge makes and cancels a reservation via restaurant profile

    Given I set test domain to "<domain>"
    Then I start with a new browser
    When I navigate to url "<concierge_login_page>"
    Then I login as concierge with username "<concierge user>" and password "<password>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I fill in "Diner First Name" with "<fname>"
    And I fill in "Diner Last Name" with "<lname>"
    And I fill in "Phone" with "<phone>"
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation
    Then I click "Sign Out"


  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                  |     rest_name              |  concierge_login_page                        | concierge user | password  |days_fwd | party_sz |  time    |   fname    | lname |     phone    |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) | http://www.opentable.com/conciergelogin.aspx | auto_concierge | password  |   4     | 2 people |  7:00 PM | Joe        | AutoCom  | 415 555 1212 |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    |    domain   | start_from                                           |     rest_name               |  concierge_login_page                        | concierge user | password  |days_fwd | party_sz |  time  |   fname    | lname |     phone    |
    | .com/fr-CA  |restaurant/profile/(FRCA-GuestCenterRest-RID)?lang=fr | (FRCA-GuestCenterRest-Name) | http://www.opentable.com/conciergelogin.aspx | auto_concierge | password  |   4     | 2 people |  19:00 | Joe        | AutoFr  | 415 555 1212 |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                          |    rest_name              |   concierge_login_page                          | concierge user | password  | days_fwd | party_sz   | time    |   fname    | lname |     phone    |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)?lang=es | (MX-GuestCenterRest-Name) | http://www.opentable.com.mx/conciergelogin.aspx | auto_concierge | password  |    4     | 2 personas | 7:00 PM | Joe        | AutoMx  | 55 5130 5300 |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    |     domain    | start_from                                          |    rest_name              |   concierge_login_page                          | concierge user | password  | days_fwd | party_sz   | time    |   fname    | lname |     phone    |
    | .com.mx/en-US | restaurant/profile/(MX-GuestCenterRest-RID)?lang=en | (MX-GuestCenterRest-Name) | http://www.opentable.com.mx/conciergelogin.aspx | auto_concierge | password  |    4     | 2 personas | 7:00 PM | Joe        | AutoMxEn  | 55 5130 5300 |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                                         |  rest_name                |  concierge_login_page                        | concierge user | password  |days_fwd | party_sz | time  |   fname    | lname |     phone    |
    | .jp    |restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | (JP-GuestCenterRest-Name) | http://www.opentable.jp/conciergelogin.aspx  | auto_concierge | password  |   4     | 2 people | 19:00 | Joe        | AutoJp  | 03-3344-5111 |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    |    domain  | start_from                                         |  rest_name                |  concierge_login_page                        | concierge user | password  |days_fwd | party_sz | time  |   fname    | lname |     phone    |
    | .jp/en-US  |restaurant/profile/(JP-GuestCenterRest-RID)?lang=en | (JP-GuestCenterRest-Name) | http://www.opentable.jp/conciergelogin.aspx  | auto_concierge | password  |   4     | 2 people | 19:00 | Joe        | AutoJpEn  | 03-3344-5111 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                    |     rest_name              |  concierge_login_page                          | concierge user | password  | days_fwd | party_sz | time  |   fname    | lname |     phone   |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name)| http://www.opentable.co.uk/conciergelogin.aspx | auto_concierge | password  |     4    | 2        | 19:00 | Joe        | AutoUK  | 207493 8000 |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                          |     rest_name            |  concierge_login_page                       | concierge user | password  | days_fwd | party_sz |  time  |   fname    | lname |    phone     |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | (DE-GuestCenterRest-Name)| http://www.opentable.de/conciergelogin.aspx | auto_concierge | password  |     4    | 2        |  19:00 | Joe        | AutoDe  | 49 30 202300 |
