@RestRef
@Reservations
@Web-bat-tier-1

Feature: [RestRef - Reservation Make-Change-Cancel] Anyone can make, change and cancel reservations from restref

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @admin-user-make-change-cancel
  Scenario Outline: Admin user makes, changes and cancels a restref reservation with new bookingflow

    Given I set test domain to "<domain>"
    And I have registered admin user with random email
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I click "Edit Diner List"
    And I add and select diner
    And I fill in "Phone" with "415-555-6565"
    And I click label with text "No offer thanks" if there
    And I complete reservation
    Then I verify reservation details on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    Then I check "RESO - Confirmation (Registered)" email
    When I get reservation anomalies report from CHARM
    Then I verify reservation Anomalies is "<anomalies>"
    Then I verify reservation BillingType is "<billing_type>"
    Then I verify reservation ResPoints is "<res_points>"
    Then I verify reservation ZeroReason is "<zero_reason>"
    Then I verify reservation BillableSize is "<party_size>"
    Then I verify reservation PartnerID is "<partner_id>"
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    And I check "RESO - Change (Registered)" email
    Then I cancel reservation
#    TODO: Need to change email checks away from TMS or get rid of this test
#    Then I check "RESO - Cancellation (Web Site)" email

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                                                               |          rest_name          |  days_fwd | party_sz | time  | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID)/reserve?restref=(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name) |    2      | 2        | 10:00 |           | RestRefReso  | 0          | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          |    12:00    | 3               |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                                                                   |          rest_name        |  days_fwd | party_sz | time   | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    |   .de  | restaurant/profile/(DE-GuestCenterRest-RID)/reserve?restref=(DE-GuestCenterRest-RID)&lang=de | (DE-GuestCenterRest-Name) |    2      | 2        |  10:00 |           |  RestRefReso | 0          | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          |    12:00    | 3               |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain  | start_from                                                                                   |          rest_name        | days_fwd | party_sz | time  | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .jp     | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=ja | (JP-GuestCenterRest-Name) |  2        | 2       | 10:00 |           |  RestRefReso |    0       | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00       | 3               |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    | domain    | start_from                                                                                   |          rest_name        | days_fwd | party_sz | time  | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .jp/en-US | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=en | (JP-GuestCenterRest-Name) | 2        | 2        | 10:00 |           | RestRefReso  |     0      | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00       | 3               |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                                                             |          rest_name         |  days_fwd | party_sz | time      | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .com   | restaurant/profile/(COM-GuestCenterRest-RID)/reserve?restref=(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) |     2      | 2        | 10:00 AM |           | RestRefReso  |     0      | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00 PM    | 3               |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                                                                   |          rest_name        |  days_fwd | party_sz | time     | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=es | (MX-GuestCenterRest-Name) |     2     | 2        | 10:00 AM |           | RestRefReso  |    0       | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00 PM    | 3               |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    |    domain     | start_from                                                                                   |          rest_name        |  days_fwd | party_sz | time     | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .com.mx/en-US | restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=en | (MX-GuestCenterRest-Name) |     2     | 2        | 10:00 AM |           | RestRefReso  |    0       | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00 PM    | 3               |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    | domain     | start_from                                                                                       |          rest_name          | days_fwd | party_sz | time  | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .com/fr-CA | restaurant/profile/(FRCA-GuestCenterRest-RID)/reserve?restref=(FRCA-GuestCenterRest-RID)&lang=fr | (FRCA-GuestCenterRest-Name) |  1       | 2        | 10:00 |           | RestRefReso  | 0          | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00       |  3              |

  @Region-EU @Domain-NL
  Scenarios:
    | domain     | start_from                                                                                       |          rest_name          | days_fwd | party_sz | time  | anomalies | billing_type | res_points | zero_reason                                           | party_size | partner_id | change_time | change_days_fwd |
    | .nl        | restaurant/profile/(NL-GuestCenterRest-RID)/reserve?restref=(NL-GuestCenterRest-RID) | (NL-GuestCenterRest-Name) |  1       | 2        | 10:00 |           | RestRefReso  | 0          | [Zero Point Rest Ref][Demoland does not allow points] | 2          | 1          | 12:00       |  3              |

  @anony-user-make-change-cancel
  Scenario Outline: Anonymous user make, change and cancel a reservation via new booking flow restref url

    Given I set test domain to "<domain>"
    And I set test user first name "<fname>"
    And I set test user last name "<lname>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I fill in "Diner First Name" with "<fname>"
    And I fill in "Diner Last Name" with "<lname>"
    And I fill in "Phone" with "<phone>"
    And I fill in "Email" with random email
    And I complete reservation
    And I convert to regular user
    Then I verify reservation details on view page
    When I get reservation anomalies report from CHARM
    Then I verify reservation Anomalies is "<anomalies>"
    Then I verify reservation BillingType is "<billing_type>"
    Then I verify reservation ResPoints is "<res_points>"
    Then I verify reservation ZeroReason is "<zero_reason>"
    Then I verify reservation BillableSize is "<party_size>"
    Then I verify reservation PartnerID is "<partner_id>"
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    And I should see user name "<fname>" "<lname>"and conf number on view page
    Then I cancel reservation

  @Region-EU @Domain-IE
  Scenarios:
    | domain | start_from                                                                           |  fname  | lname  | phone      | rest_name                | days_fwd | party_sz | time  | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                                           | partner_id |
    | .ie    | restaurant/profile/(IE-GuestCenterRest-RID)/reserve?restref=(IE-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 1 402 9988 | (IE-GuestCenterRest-Name)| 2        | 2        | 09:00 | 3               | 15:00       |   2        |           | RestRefReso  | 0          | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | start_from                                                                           |  fname  | lname  | phone        | rest_name                | days_fwd | party_sz | time     | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                                           | partner_id |
    | .com.au | restaurant/profile/(AU-GuestCenterRest-RID)/reserve?restref=(AU-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 1300 653 227 |(AU-GuestCenterRest-Name) | 2        | 2        | 9:00 AM  | 3               | 3:00 PM     |    2       |           | RestRefReso  |   0        | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain  | start_from                                                                                  |  fname  | lname  | phone        | rest_name                | days_fwd | party_sz | time  | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                                           | partner_id |
    |   .jp  | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=ja | Joé-Joé | O'Áuto | 1300 653 227 |(JP-GuestCenterRest-Name) | 2        | 2        | 09:00  | 3               |     15:00   |    2       |           | RestRefReso  |   0        | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    | domain     | start_from                                                                                   |  fname  | lname  | phone        | rest_name                | days_fwd | party_sz | time  | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                                           | partner_id |
    | .jp/en-US  | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=en | Joé-Joé | O'Áuto | 1300 653 227 |(JP-GuestCenterRest-Name) | 2        | 2        | 09:00  | 3               |     15:00   |    2       |           | RestRefReso  |   0        | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                                                               |  fname  | lname  | phone        |    rest_name                | days_fwd | party_sz | party_sz | time  | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |                       zero_reason                     | partner_id |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID)/reserve?restref=(COUK-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 20 7493 8000 | (COUK-GuestCenterRest-Name) |   2      | 2        | 2        | 09:00 |        3        |   15:00     |   2        |           |  RestRefReso | 0          | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                                                                   |  fname  | lname  | phone      |     rest_name             | days_fwd | party_sz | party_sz | time  | change_days_fwd | change_time |  party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)/reserve?restref=(DE-GuestCenterRest-RID)&lang=de | Joé-Joé | O'Áuto | 30 202300  | (DE-GuestCenterRest-Name) |    2     | 2        | 2        | 09:00 |  3              |  15:00      |   2         |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                                                            | fname   |  lname | phone       |     rest_name              | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |                      zero_reason                     | partner_id |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID)/reserve?restref=(COM-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 4155551212  | (COM-GuestCenterRest-Name) |  2       | 2 people | 2 people | 9:00 AM | 4               | 3:00 PM     |  2         |           | RestRefReso  |   0        |[[Zero Point Rest Ref][Demoland does not allow points]| 1          |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    |    domain  | start_from                                                                                      | fname   |  lname | phone       |      rest_name              | days_fwd | party_sz | party_sz |  time | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |                      zero_reason                     | partner_id |
    | .com/fr-CA |restaurant/profile/(FRCA-GuestCenterRest-RID)/reserve?restref=(FRCA-GuestCenterRest-RID)&lang=fr | Joé-Joé | O'Áuto | 4155551212  | (FRCA-GuestCenterRest-Name) |  2       | 2 people | 2 people | 09:00 | 4               |    15:00    |  2         |           | RestRefReso  |   0        |[[Zero Point Rest Ref][Demoland does not allow points]| 1          |

  @Region-NA @Domain-COM.MX
  Scenarios:
    |  domain | start_from                                                                                  | fname   |  lname | phone       |       rest_name           | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |                      zero_reason                     | partner_id |
    | .com.mx |restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=es | Joé-Joé | O'Áuto | 4155551212  | (MX-GuestCenterRest-Name) |  2       | 2 people | 2 people | 9:00 AM | 4               | 3:00 PM     |  2         |           | RestRefReso  |   0        |[[Zero Point Rest Ref][Demoland does not allow points]| 1          |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    |     domain    | start_from                                                                                  | fname   |  lname | phone       |       rest_name           | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |                      zero_reason                     | partner_id |
    | .com.mx/en-US |restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=en | Joé-Joé | O'Áuto | 4155551212  | (MX-GuestCenterRest-Name) |  2       | 2 people | 2 people | 9:00 AM | 4               | 3:00 PM     |  2         |           | RestRefReso  |   0        |[[Zero Point Rest Ref][Demoland does not allow points]| 1          |

  @Region-EU @Domain-NL
    Scenarios:
    |     domain    | start_from                                                                                  | fname   |  lname | phone       |       rest_name           | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |                      zero_reason                     | partner_id |
    | .nl           |restaurant/profile/(NL-GuestCenterRest-RID)/reserve?restref=(NL-GuestCenterRest-RID)&lang=en | Joé-Joé | O'Áuto | 4155551212  | (NL-GuestCenterRest-Name) |  2       | 2 people | 2 people | 09:00 | 4               | 15:00     |  2         |           | RestRefReso  |   0        |[[Zero Point Rest Ref][Demoland does not allow points]| 1          |


  @concierge-user-make-cancel
  Scenario Outline: Concierge makes and cancels a reservation via restref

    Given I set test domain to "<domain>"
    Then I set user with username "<concierge user>" and password "<password>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I fill in "Diner First Name" with "<fname>"
    And I fill in "Diner Last Name" with "<lname>"
    And I complete reservation
    Then I verify reservation details on view page
    When I get reservation anomalies report from CHARM
    Then I verify reservation Anomalies is "<anomalies>"
    Then I verify reservation BillingType is "<billing_type>"
    Then I verify reservation ResPoints is "<res_points>"
    Then I verify reservation ZeroReason is "<zero_reason>"
    Then I verify reservation BillableSize is "<party_size>"
    Then I verify reservation PartnerID is "<partner_id>"
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                                                               |       rest_name            | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID)/reserve?restref=(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name)| uk_auto_concierge | password  |     13   | 2        | 16:00 | Joé-Joé | O'Áuto | 21:00       |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                                                                   |       rest_name          | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    |   .de  | restaurant/profile/(DE-GuestCenterRest-RID)/reserve?restref=(DE-GuestCenterRest-RID)&lang=de | (DE-GuestCenterRest-Name)| de_auto_concierge | password  |     13   | 2        | 16:00 | Joé-Joé | O'Áuto | 21:00       |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-AP @Domain-JP
  Scenarios:
    | domain | start_from                                                                                   |       rest_name          | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    |   .jp  | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=ja | (JP-GuestCenterRest-Name)| jp_auto_concierge | password  |     13   | 2        | 16:00 | Joé-Joé | O'Áuto | 21:00       |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-AP @Domain-JP.en-US
  Scenarios:
    | domain     | start_from                                                                                   |       rest_name          | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .jp/en-US  | restaurant/profile/(JP-GuestCenterRest-RID)/reserve?restref=(JP-GuestCenterRest-RID)&lang=en | (JP-GuestCenterRest-Name)| jp_auto_concierge | password  |     13   | 2        | 16:00 | Joé-Joé | O'Áuto | 21:00       |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                                                              |       rest_name           | concierge user    | password  | days_fwd | party_sz | time    |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    |   .com  | restaurant/profile/(COM-GuestCenterRest-RID)/reserve?restref=(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name)| us_auto_concierge | password  |     13   | 2        | 4:00 PM | Joé-Joé | O'Áuto | 8:00 PM     |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    |   domain   | start_from                                                                                       |        rest_name           | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .com/fr-CA | restaurant/profile/(FRCA-GuestCenterRest-RID)/reserve?restref=(FRCA-GuestCenterRest-RID)&lang=fr | (FRCA-GuestCenterRest-Name)| us_auto_concierge | password  |     13   | 2        | 16:00 | Joé-Joé | O'Áuto |   21:00     |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                                                                   |         rest_name        | concierge user    | password  | days_fwd | party_sz | time    |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=es | (MX-GuestCenterRest-Name)| mx_auto_concierge | password  |     13   | 2        | 4:00 PM | Joé-Joé | O'Áuto | 8:00 PM     |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    |    domain     | start_from                                                                                   |         rest_name        | concierge user    | password  | days_fwd | party_sz | time    |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .com.mx/en-US | restaurant/profile/(MX-GuestCenterRest-RID)/reserve?restref=(MX-GuestCenterRest-RID)&lang=en | (MX-GuestCenterRest-Name)| mx_auto_concierge | password  |     13   | 2        | 4:00 PM | Joé-Joé | O'Áuto | 8:00 PM     |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-EU @Domain-NL
    Scenarios:
    |    domain     | start_from                                                                                   |         rest_name        | concierge user    | password  | days_fwd | party_sz | time    |  fname  | lname  | change_time | change_days_fwd |party_size | anomalies | billing_type | res_points |                         zero_reason                  | partner_id |
    | .nl           | restaurant/profile/(NL-GuestCenterRest-RID)/reserve?restref=(NL-GuestCenterRest-RID)&lang=en | (NL-GuestCenterRest-Name)| nl_auto_concierge | password  |     13   | 2        | 16:00 | Joé-Joé | O'Áuto | 20:00     |     13          |     2     |           | RestRefReso  |       0    |[Zero Point Rest Ref][Demoland does not allow points] | 1          |
