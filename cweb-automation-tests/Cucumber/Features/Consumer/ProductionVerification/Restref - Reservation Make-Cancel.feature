@Reservations
@Restref
@Web-bat-tier-0
@Team-WarMonkeys

Feature: [RestRef - Reservation Make-Cancel] Registered user can make and cancel a reservation via restref in Production

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser


  @registered-user-make-cancel
  Scenario Outline: Registered user makes and cancels a reservation from restref

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I fill in "Phone" with "<phone>"
    And I complete reservation
    Then I verify reservation details on view page
    Then I verify restref is set and points is 0
    Then I cancel reservation


  @Region-NA @Domain-COM
  Scenarios:
    | domain |            start_from                                                                  |           rest_name        | days_fwd | party_sz |   time  |    phone   |
    |  .com  | restaurant/profile/(COM-GuestCenterRest-RID)/reserve?restref=(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) |     5    | 2        | 4:00 PM | 1234567890 |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    |    domain   |            start_from                                                                            |           rest_name         | days_fwd | party_sz | time  |    phone   |
    |  .com/fr-ca | restaurant/profile/(FRCA-GuestCenterRest-RID)/reserve?restref=(FRCA-GuestCenterRest-RID)&lang=fr | (FRCA-GuestCenterRest-Name) |     5    | 2        | 16:00 | 1234567890 |

  @Region-NA @Domain-COM.MX
  Scenarios:
    |  domain  |            start_from                                                                |           rest_name       | days_fwd | party_sz |    time  |    phone   |
    |  .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID) | (MX-GuestCenterRest-Name) |     5    | 2        | 4:00 PM  | 1234567890 |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    |     domain     |            start_from                                                                        |           rest_name       | days_fwd | party_sz |   time   |    phone   |
    |  .com.mx/en-US | restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=en | (MX-GuestCenterRest-Name) |     5    | 2        | 4:00 PM  | 1234567890 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |            start_from                                                                    |           rest_name         | days_fwd | party_sz | time  |    phone   |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID)/reserve?restref=(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name) |     5    | 2        | 16:00 | 1234567890 |

  @Region-EU @Domain-IE
  Scenarios:
    | domain | start_from                                                                           |           rest_name       | days_fwd | party_sz | time  |    phone   |
    |   .ie  | restaurant/profile/(IE-GuestCenterRest-RID)/reserve?restref=(IE-GuestCenterRest-RID) | (IE-GuestCenterRest-Name) |     5    | 2        | 16:00 | 1234567890 |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain | start_from                                                                           |           rest_name       | days_fwd | party_sz |   time  |    phone   |
    |.com.au | restaurant/profile/(AU-GuestCenterRest-RID)/reserve?restref=(AU-GuestCenterRest-RID) | (AU-GuestCenterRest-Name) |     5    | 2        | 4:00 PM | 1234567890 |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain |             start_from                                                               |           rest_name       |days_fwd | party_sz | time  |    phone   |
    | .jp    | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID) | (JP-GuestCenterRest-Name) |   5     | 2 people | 16:00 | 1234567890 |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    |    domain  |            start_from                                                                       |           rest_name       |days_fwd | party_sz | time  |    phone   |
    | .jp/en-US  |restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=en | (JP-GuestCenterRest-Name) |   5     | 2 people | 16:00 | 1234567890 |

  @Region-EU @Domain-DE
  Scenarios:
    | domain |            start_from                                                                |           rest_name       | days_fwd | party_sz |  time  |    phone   |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)/reserve?restref=(DE-GuestCenterRest-RID) | (DE-GuestCenterRest-Name) |    5     | 2        |  16:00 | 1234567890 |
