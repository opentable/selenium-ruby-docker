@RestaurantProfile
@Reservations
@Web-bat-tier-1

Feature: [Restaurant Profile - Reservation Make-Change-Cancel] Anyone can make, change and cancel a reservation via restaurant/profile

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @regular-user-make-change-cancel
  Scenario Outline: Registered user makes, changes and cancels a reservation via restaurant profile new bookingflow

    Given I set test domain to "<domain>"
    Then I navigate to url "<restaurant_profile>"
    Then I set user with username "<email>" and password "<password>"
    And I find a table for "<party_sz>" at "<time>" on "<days_fwd>" from today
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I fill in "Phone" with "<phone>"
    And I complete reservation
    When I get reservation anomalies report from CHARM
    Then I verify reservation billing info for "<billing_type>", "<res_points>", "<party_size>", "<partner_id>"
    Then I click "Modify"
    And I find a table for "<party_sz_change>" at "<change_time>" on "<change_days_fwd>" from today
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    Then I should see user name "<fname>" "Opentable"and conf number on view page
    Then I should see POP "<points_msg>" points message
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | restaurant_profile                          |     rest_name              |         email          | password  | fname      |    phone   | days_fwd | party_sz | party_sz_change | time    | anomalies | billing_type | res_points | zero_reason                     | party_size | partner_id | change_time | change_days_fwd |                           points_msg                           |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) | otprodtester@gmail.com | 0pentab1e | Prodtester | 4155551212 |  3       | 2 people | 2 people        | 7:00 PM |           | OTReso       | 100        |[Demoland does not allow points] | 2          | 1          | 9:00 PM     | 4               | You will earn 100 points upon dining.Learn more about points. |

  #Book-1270: MX Registered users are not getting the points message in the Details and Views page
  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | restaurant_profile                                  |    rest_name              |         email            | password  |      fname   |    phone   |  days_fwd | party_sz   | party_sz_change | time      | anomalies | billing_type | res_points | zero_reason                     | party_size | partner_id | change_time | change_days_fwd |                        points_msg                            |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)?lang=es | (MX-GuestCenterRest-Name) | otprodtestermx@gmail.com | 0pentab1e | Prodtestermx |55 5130 5300|  4        | 2 personas | 2 personas      | 2:00 PM   |           | OTReso       | 100        |[Demoland does not allow points] | 2          | 1          | 5:00 PM     | 5               | Usted ganará 100 al comer. Conozca más acerca de los puntos. |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | restaurant_profile                             |     rest_name               |          email           | password  | fname        |    phone   | days_fwd | party_sz | party_sz_change | time  | anomalies |     billing_type   | res_points |       zero_reason                 | party_size | partner_id | change_time | change_days_fwd |                         points_msg                             |
     | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name) | otprodtesteruk@gmail.com | 0pentab1e | Prodtesteruk |20 7493 8000|   4      | 2        | 2               | 19:00 |           | OTReso;OfferReso   | 100        | [Demoland does not allow points]  | 2          | 1          | 17:00       |        5        | You will earn 100 points upon dining.Learn more about points. |

  #BOOK-1270: MX Registered users are not getting the points message in the Details and Views page
  @Region-EU @Domain-DE
  Scenarios:
    | domain | restaurant_profile                                  |     rest_name             |         email            | password  | fname        |    phone   | days_fwd | party_sz | party_sz_change | time  | anomalies | billing_type | res_points |           zero_reason            | party_size | partner_id | change_time | change_days_fwd |                              points_msg                                                                 |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | (DE-GuestCenterRest-Name) | otprodtesterde@gmail.com | 0pentab1e | Prodtesterde | 30 202300  |    4     | 2        | 2               | 19:00 |           | OTReso       | 100        | [Demoland does not allow points] | 2          | 1          | 17:00       | 5               | Bei Ankunft im Restaurant erhalten Sie 100 OpenTable-Punkte.Weitere Informationen zu OpenTable-Punkten |

  #BOOK-1271: JP date display does not have year when browser width is maximized ie not responsive
  @Region-Asia @Domain-JP
  Scenarios:
    | domain | restaurant_profile                                  |   rest_name               | email                    | password  |    fname     |    phone   | days_fwd | party_sz | party_sz_change | time  | anomalies | billing_type | res_points |           zero_reason             | party_size | partner_id | change_time | change_days_fwd |                              points_msg                          |
    | .jp    | restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | (JP-GuestCenterRest-Name) | otprodtesterjp@gmail.com | 0pentab1e | ProdtesterJP |03-3344-5111|  3       | 2        | 2               | 08:00 |           | OTReso       | 100        | [Demoland does not allow points]  | 2          | 1          | 14:00       | 3               | お食事後、お客様に100ポイントが付与されます。ポイントに関する情報を見る › |

  @Region-EU @Domain-IE
  Scenarios:
    | domain | restaurant_profile                          |   rest_name               | email                    | password  |    fname     |    phone   | days_fwd | party_sz | party_sz_change | time  | anomalies | billing_type | res_points |        zero_reason               | party_size | partner_id | change_time | change_days_fwd |                              points_msg                          |
    | .ie    | restaurant/profile/(IE-GuestCenterRest-RID) | (IE-GuestCenterRest-Name) | otprodtesterie@gmail.com | 0pentab1e | ProdtesterIE | 1 402 9988 | 2        | 2        |         2       | 08:00 |           | OTReso       |  100       | [Demoland does not allow points] |       2     |      1     | 14:00      |        2        |                                                                  |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | restaurant_profile                          |   rest_name               | email                    | password  |    fname     |     phone   | days_fwd | party_sz | party_sz_change |   time   | anomalies | billing_type | res_points |          zero_reason             | party_size | partner_id | change_time | change_days_fwd |                              points_msg                          |
    | .com.au | restaurant/profile/(AU-GuestCenterRest-RID) | (AU-GuestCenterRest-Name) | otprodtesterau@gmail.com | 0pentab1e | ProdtesterAU | 2 9266 2000 | 2        | 2        |       2         | 8:00 AM  |           |     OTReso   |    100     | [Demoland does not allow points] |    2       |      1     |  1:00 PM    |         2       |                                                                       |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    | domain     | restaurant_profile                                 |      rest_name           |             email          | password  |     fname      |    phone   | days_fwd | party_sz | party_sz_change | time  | anomalies | billing_type | res_points | zero_reason | party_size | partner_id | change_time | change_days_fwd |                                    points_msg                                         |
    | .com/fr-ca | restaurant/profile/(FRCA-AlwaysOnline-RID)?lang=fr | (FRCA-AlwaysOnline-Name) | otprodtesterfrca@gmail.com | 0pentab1e | Prodtesterfrca | 5105551212 |   2      | 2        | 2               | 22:00 |           | OTReso       | 100        |             | 2          | 1          | 17:00       | 3               | Vous accumulerez des points 100 après votre repasEn savoir plus à propos des points. |


  @anony-user-make-change-cancel @bookingflow
  Scenario Outline: Anonymous user make, change and cancel a reservation via restaurant profile using new booking flow

    Given I set test domain to "<domain>"
    And I set test user first name "<fname>"
    And I set test user last name "<lname>"
    Then I navigate to url "<start_from>"
    And I find a table for "<party_sz>" at "<time>" on "<days_fwd>" from today
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I fill in "Diner First Name" with "<fname>"
    And I fill in "Diner Last Name" with "<lname>"
    And I fill in "Phone" with "<phone>"
    And I fill in "Email" with random email
    And I complete reservation
    And I convert to regular user
    Then I verify reservation details on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    Then I check "RESO - Confirmation (Anonymous)" email
    When I get reservation anomalies report from CHARM
    Then I verify reservation billing info for "<billing_type>", "<res_points>", "<party_size>", "<partner_id>"
    Then I click "Modify"
    And I find a table for "<party_sz>" at "<change_time>" on "<change_days_fwd>" from today
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    And I should see user name "<fname>" "<lname>"and conf number on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    Then I check "RESO - Change (Anonymous)" email
    Then I cancel reservation
#    TODO: Need to change email checks away from TMS or get rid of this test
#    And I check "RESO - Cancellation (Web Site)" email

  @Region-EU @Domain-IE
  Scenarios:
    | domain | start_from                                  | fname   | lname  | phone      | rest_name                | days_fwd | party_sz | time  | change_days_fwd | change_time | party_size |anomalies | billing_type | res_points | zero_reason                                           | partner_id |
    | .ie    | restaurant/profile/(IE-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 1 402 9988 | (IE-GuestCenterRest-Name)| 2        | 2        | 08:00 | 3               | 14:00       |   2        |          |      OTReso  |   100      | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | start_from                                  |  fname  | lname  | phone        | rest_name                | days_fwd | party_sz | time     | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                                           | partner_id |
    | .com.au | restaurant/profile/(AU-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 1300 653 227 |(AU-GuestCenterRest-Name) | 2        | 2        | 8:00 AM  | 3               | 1:00 PM     |    2       |           |      OTReso  | 100        | [Zero Point Rest Ref][Demoland does not allow points] | 1          |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                    |  fname  | lname  | phone        |    rest_name                | days_fwd | party_sz | party_sz | time  | change_days_fwd | change_time | party_size | anomalies |   billing_type   | res_points |       zero_reason                 | partner_id |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 20 7493 8000 | (COUK-GuestCenterRest-Name) |   2      | 2        | 2        | 08:00 |        3        |   13:00     |   2        |           | OTReso;OfferReso | 100        | [Demoland does not allow points]  | 1          |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                          |  fname  | lname  | phone      |     rest_name             | days_fwd | party_sz | party_sz | time  | change_days_fwd | change_time |  party_size | anomalies | billing_type | res_points |           zero_reason            | partner_id |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | Joé-Joé | O'Áuto | 30 202300  | (DE-GuestCenterRest-Name) |    2     | 2        | 2        | 08:00 |        3        |  13:00      |   2         |           | OTReso       |    100     | [Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                  | fname   |  lname | phone       |     rest_name              | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                     | partner_id |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID) | Joé-Joé | O'Áuto | 4155551212  | (COM-GuestCenterRest-Name) |  2       | 2 people | 2 people | 8:00 AM |       3         | 1:00 PM     |  2         |           | OTReso       |   100      |[Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                          | fname   |  lname | phone       |     rest_name              | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                     | partner_id |
    | .com.mx |restaurant/profile/(MX-GuestCenterRest-RID)?lang=es  | Joé-Joé | O'Áuto | 4155551212  | (MX-GuestCenterRest-Name)  |  2       | 2 people | 2 people | 8:00 AM |      3          | 1:00 PM     |  2         |           | OTReso       |   100      |[Demoland does not allow points] | 1          |
#
  @Region-Asia @Domain-JP
  Scenarios:
    | domain  | start_from                                          | fname   |  lname | phone       | rest_name                 | days_fwd | party_sz | party_sz | time   | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |           zero_reason            | partner_id |
    | .jp     | restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | Joé-Joé | O'Áuto | 4155551212  | (JP-GuestCenterRest-Name) |  3       | 2        | 2 people | 08:00  | 4               |   13:00     |  2         |           | OTReso       | 100        | [Demoland does not allow points] | 1          |

  #Book-1275: Inconsistent time format in fr-CA
  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    | domain     | start_from                                            | fname   |  lname | phone       |     rest_name                | days_fwd | party_sz | party_sz | time  | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points | zero_reason                     | partner_id |
    | .com/fr-CA |restaurant/profile/(FRCA-GuestCenterRest-RID)?lang=fr  | Joé-Joé | O'Áuto | 4155551212  | (FRCA-GuestCenterRest-Name)  |  2       | 2 people | 2 people | 08:00  |      3         |   13:00     |  2         |           | OTReso       |   100      |[Demoland does not allow points] | 1          |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
    | domain        | start_from                                         | fname   |  lname | phone       | rest_name                 | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |            zero_reason           | partner_id |
    | .com.mx/en-US | restaurant/profile/(MX-GuestCenterRest-RID)?lang=en | Joé-Joé | O'Áuto | 4155551212  | (MX-GuestCenterRest-Name) |  3       | 2        | 2 people | 8:00 AM | 4               |   1:00 PM   |  2         |           | OTReso       | 100        | [Demoland does not allow points] | 1          |

  @Region-Asia @Domain-JP.en-US
  Scenarios:
    | domain    | start_from                                          | fname   |  lname | phone       | rest_name                 | days_fwd | party_sz | party_sz | time   | change_days_fwd | change_time | party_size | anomalies | billing_type | res_points |             zero_reason         | partner_id |
    | .jp/en-US | restaurant/profile/(JP-GuestCenterRest-RID)?lang=en | Joé-Joé | O'Áuto | 4155551212  | (JP-GuestCenterRest-Name) |  3       | 2        | 2 people | 08:00  | 4               |   13:00     |  2         |           | OTReso       | 100        |[Demoland does not allow points] | 1          |

  @admin-user-make-change-cancel
  Scenario Outline: Admin user makes, changes and cancels a reservation from restaurant profile

    Given I set test domain to "<domain>"
    And I have registered admin user with random email
    And I navigate to url "<start_from>"
    And I find a table for "<party_sz>" at "<time>" on "<days_fwd>" from today
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I click "Edit Diner List"
    And I add and select diner
    And I fill in "Phone" with "<phone>"
    And I complete reservation
    Then I verify reservation details on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    Then I check "RESO - Confirmation (Registered)" email
    When I get reservation anomalies report from CHARM
    Then I verify reservation billing info for "<billing_type>", "<res_points>", "<party_size>", "<partner_id>"
    Then I click "Modify"
    And I find a table for "<party_sz>" at "<change_time>" on "<change_days_fwd>" from today
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    And I check "RESO - Change (Registered)" email
    Then I cancel reservation
#    TODO: Need to change email checks away  from TMS or get rid of this test
#    Then I check "RESO - Cancellation (Web Site)" email


  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                   |     rest_name             |    phone     | days_fwd |  party_sz | time      | anomalies | billing_type | res_points | zero_reason                      | party_size | partner_id | change_time | change_days_fwd |
    | .com   | restaurant/profile/(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name)| 415-555-1212 |   1      |  2 people | 2:00 PM   |           | OTReso       | 100        | [Demoland does not allow points] | 2          | 1          | 5:00 PM     | 2               |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                          |     rest_name             |     phone    |  days_fwd |  party_sz   | time      | anomalies | billing_type | res_points | zero_reason                      | party_size | partner_id | change_time | change_days_fwd |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)?lang=es | (MX-GuestCenterRest-Name) | 55 5130 5300 |  1        |  2 personas | 2:00 PM   |           | OTReso       | 100        | [Demoland does not allow points] | 2          | 1          | 5:00 PM     | 2               |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                    |    rest_name                | phone        | days_fwd | party_sz | time  | anomalies | billing_type | res_points |       zero_reason                 | party_size | partner_id | change_time | change_days_fwd |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name) | 20 7493 8000 |   2      | 2        | 08:00 |           |       OTReso |    100     | [Demoland does not allow points]  |   2        | 1          |   13:00     |        3        |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                          |    rest_name             | phone      |  days_fwd | party_sz | time  | anomalies | billing_type | res_points |           zero_reason            |  party_size | partner_id | change_time | change_days_fwd |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | (DE-GuestCenterRest-Name)| 30 202300  |    2      | 2        | 08:00 |           | OTReso       |     100    | [Demoland does not allow points] |   2         | 1          |  13:00      |        3        |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                                          | rest_name                 |   phone    | days_fwd | party_sz | time   | anomalies | billing_type | res_points | zero_reason | party_size | partner_id | change_time | change_days_fwd |
    | .jp    | restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | (JP-GuestCenterRest-Name) | 4155551212 |  3       | 2        | 08:00  |           | OTReso       | 100        |             |  2         |  1         |   13:00     | 4               |

  @Region-NA @Domain-COM.fr-CA
  Scenarios:
    | domain     | start_from                                            | rest_name                   |    phone   |  days_fwd | party_sz | time  | anomalies | billing_type | res_points | zero_reason  | party_size | partner_id | change_time | change_days_fwd |
    | .com/fr-CA | restaurant/profile/(FRCA-GuestCenterRest-RID)?lang=fr | (FRCA-GuestCenterRest-Name) | 5105551212 |    1      | 2        | 19:00 |           |     OTReso   |     100    |              | 2          | 1          | 17:00       |  2              |

  @Region-NA @Domain-COM.MX.en-US
  Scenarios:
  | domain        | start_from                                          | rest_name                 |     phone    | days_fwd | party_sz | time    | anomalies | billing_type | res_points | zero_reason | party_size | partner_id | change_time |  change_days_fwd |
  | .com.mx/en-US | restaurant/profile/(MX-GuestCenterRest-RID)?lang=en | (MX-GuestCenterRest-Name) | 55 5130 5300 |  3       | 2        | 5:00 PM |           | OTReso       | 100        |             | 2          | 1          | 7:00 PM     |  4               |


  @concierge-user-make-cancel
  Scenario Outline: Concierge makes and cancels a reservation via restaurant profile

    Given I set test domain to "<domain>"
    Then I set user with username "<concierge user>" and password "<password>"
    Then I navigate to url "<start_from>"
    And I find a table for "<party_sz>" at "<time>" on "<days_fwd>" from today
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I fill in "Diner First Name" with "<fname>"
    And I fill in "Diner Last Name" with "<lname>"
    And I complete reservation
    Then I verify reservation details on view page
    When I get reservation anomalies report from CHARM
    Then I verify reservation billing info for "<billing_type>", "<res_points>", "<party_size>", "<partner_id>"
    Then I click "Modify"
    And I find a table for "<party_sz>" at "<change_time>" on "<change_days_fwd>" from today
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
#    TODO: Need to change email checks away from TMS or get rid of this test
#    And I check "RESO - Change (Registered)" email
    Then I cancel reservation
#    TODO: Need to change email checks away from TMS or get rid of this test
#    Then I check "RESO - Cancellation (Web Site)" email


  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                  |     rest_name              | concierge user    | password  |days_fwd | party_sz |  time    |  fname  | lname  | anomalies | billing_type | res_points | zero_reason                     | party_size | partner_id | change_time | change_days_fwd |
    | .com   |restaurant/profile/(COM-GuestCenterRest-RID) | (COM-GuestCenterRest-Name) | us_auto_concierge | password  |   3     | 2 people |  4:00 PM | Joé-Joé | O'Áuto |           | OTReso       | 100        |[Demoland does not allow points] | 2          | 1          | 9:00 PM     | 3               |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  | start_from                                          |    rest_name              | concierge user    | password  | days_fwd | party_sz   | time    |  fname  | lname  | anomalies | billing_type | res_points | zero_reason                      | party_size | partner_id | change_time | change_days_fwd |
    | .com.mx | restaurant/profile/(MX-GuestCenterRest-RID)?lang=es | (MX-GuestCenterRest-Name) | mx_auto_concierge | password  |    3     | 2 personas | 4:00 PM | Joé-Joé | O'Áuto |           | OTReso       | 100        | [Demoland does not allow points] | 2          | 1          | 9:00 PM     | 3               |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from                                         |  rest_name                | concierge user    | password  |days_fwd | party_sz | time  |  fname  | lname  | anomalies | billing_type | res_points |           zero_reason            | party_size | partner_id | change_time | change_days_fwd |
    | .jp    |restaurant/profile/(JP-GuestCenterRest-RID)?lang=ja | (JP-GuestCenterRest-Name) | jp_auto_concierge | password  |   3     | 2 people | 16:00 | Joé-Joé | O'Áuto |           | OTReso       | 100        | [Demoland does not allow points] | 2          | 1          | 21:00       | 3               |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                    |     rest_name              | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | anomalies | billing_type           | res_points | zero_reason                       | party_size | partner_id | change_time | change_days_fwd |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRest-RID) | (COUK-GuestCenterRest-Name)| uk_auto_concierge | password  |     3    | 2        | 16:00 | Joé-Joé | O'Áuto |           | OTReso;OfferReso       | 100        | [Demoland does not allow points]  | 2          | 1          | 21:00       | 3               |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from                                          |     rest_name            | concierge user    | password  | days_fwd | party_sz |  time  |  fname  | lname  | anomalies | billing_type | res_points | zero_reason                      | party_size | partner_id | change_time | change_days_fwd |
    | .de    | restaurant/profile/(DE-GuestCenterRest-RID)?lang=de | (DE-GuestCenterRest-Name)| de_auto_concierge | password  |     3    | 2        |  16:00 | Joé-Joé | O'Áuto |           | OTReso       | 100        | [Demoland does not allow points] | 2          | 1          | 21:00       | 3               |