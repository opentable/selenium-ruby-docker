@RestaurantProfile
@Reservations
@Web-bat-tier-1

Feature: [Restaurant Profile - Reservation Make-Change-Cancel] Anyone can make, change and cancel a CC reservation via restaurant/profile

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @regular-user-make-change-cancel
  Scenario Outline: Registered user makes, changes and cancels a reservation via restaurant profile

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    Then I navigate to url "<restaurant_profile>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    And I click on Sign in link and login as registered user
    And I fill in "Phone" with "<phone>"
    And I fill in "Name on CC" with "Joé-Joé O'Áuto"
    And I fill in  CC number "<credit_card_number>" and exp date if needed
    And I complete reservation
    ##BOOK-1314
#    And I should see conf number and credit card number "<credit_card_number>" on view page
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_sz_change>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    Then I should see user name "" "Opentable"and conf number on view page
    Then I should see POP "<points_msg>" points message
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | restaurant_profile                        |     rest_name            | phone      | days_fwd | party_sz | party_sz_change | time    |credit_card_number   | change_time | change_days_fwd |                           points_msg                           |
    | .com   |restaurant/profile/(COM-CWAutoTestERB-RID) | (COM-CWAutoTestERB-Name) | 4155551212 |  5       | 4 people | 4 people       | 5:30 PM | 5555555555554444    | 12:30 PM     |     4           | You will earn 100 points upon dining.Learn more about points. |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | restaurant_profile                          |     rest_name             |   phone      | days_fwd | party_sz | party_sz_change | time  |credit_card_number | change_time | change_days_fwd |                           points_msg                           |
    | .co.uk | restaurant/profile/(COUK-CWAutoTestERB-RID) | (COUK-CWAutoTestERB-Name) | 20 7493 8000 |   5     | 4        |       4         | 17:30 | 5555555555554444  | 12:30       |       4          | You will earn 100 points upon dining.Learn more about points. |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | restaurant_profile                        |     rest_name           |  phone    | days_fwd | party_sz | party_sz_change | time  | credit_card_number  | change_time | change_days_fwd |                              points_msg                                                                  |
    | .de    | restaurant/profile/(DE-CWAutoTestERB-RID) | (DE-CWAutoTestERB-Name) | 30 202300 |    5     |    4     |       4         | 17:00 |  5555555555554444   | 11:00       |        4        |  Bei Ankunft im Restaurant erhalten Sie 100 OpenTable-Punkte.Weitere Informationen zu OpenTable-Punkten |


  @anony-user-make-change-cancel
  Scenario Outline: Anonymous user make, change and cancel a CC reservation via restaurant profile using new booking flow

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
    And I fill in "Name on CC" with "<fname> <lname>"
    And I fill in  CC number "<credit_card_number>" and exp date if needed
    And I fill in "CVV" with "<cvv>"
    And I complete reservation
    And I convert to regular user
    Then I verify reservation details on view page
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_size>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    And I should see user name "<fname>" "<lname>"and conf number on view page
    Then I cancel reservation

  @Region-EU @Domain-IE
  Scenarios:
    | domain | start_from                                    | fname   | lname  | phone      | rest_name                  | days_fwd | party_sz | time  | change_days_fwd | change_time | party_size |credit_card_number | cvv |
    | .ie    | restaurant/profile/(IE-GuestCenterRestCC-RID) | Joé-Joé | O'Áuto | 1 402 9988 | (IE-GuestCenterRestCC-Name)|    12    |   6      | 08:00 |      13         | 14:00       |   6        | 4111111111111111  | 432 |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  | start_from                                    |  fname  | lname  | phone        | rest_name                  | days_fwd | party_sz | time     | change_days_fwd | change_time | party_size |credit_card_number | cvv |
    | .com.au | restaurant/profile/(AU-GuestCenterRestCC-RID) | Joé-Joé | O'Áuto | 1300 653 227 |(AU-GuestCenterRestCC-Name) |    12    |   6      | 8:00 AM  |      13         | 2:00 PM     |    6       | 4111111111111111  | 432 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                      |  fname  | lname  | phone        |    rest_name                  | days_fwd | party_sz | party_sz | time  | change_days_fwd | change_time | party_size |credit_card_number | cvv |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRestCC-RID) | Joé-Joé | O'Áuto | 20 7493 8000 | (COUK-GuestCenterRestCC-Name) |    12    |   6      |   6      | 08:00 |       13         |   14:00     |   6       | 4111111111111111  | 432 |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                   | fname   |  lname | phone       |     rest_name                | days_fwd | party_sz | party_sz | time    | change_days_fwd | change_time | party_size |credit_card_number | cvv |
    | .com   |restaurant/profile/(COM-GuestCenterRestCC-RID)| Joé-Joé | O'Áuto | 4155551212  | (COM-GuestCenterRestCC-Name) |    12    | 6 people | 6 people | 8:00 AM |       13        | 2:00 PM     |  6         | 4111111111111111  | 432 |


  @admin-user-make-change-cancel
  Scenario Outline: Admin user makes, changes and cancels a CC reservation from restaurant profile

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
    And I fill in "Name on CC" with "Joé-Joé O'Áuto"
    And I fill in  CC number "<credit_card_number>" and exp date if needed
    And I fill in "CVV" with "<cvv>"
    And I complete reservation
    Then I verify reservation details on view page
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                     |      rest_name               | days_fwd |  party_sz | time      | change_time | change_days_fwd |credit_card_number | cvv |
    | .com   | restaurant/profile/(COM-GuestCenterRestCC-RID) | (COM-GuestCenterRestCC-Name) |    14    |      6    | 2:00 PM   | 5:00 PM     | 16              | 4111111111111111  | 432 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                      |      rest_name                | days_fwd |  party_sz | time    | change_time | change_days_fwd |credit_card_number | cvv |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRestCC-RID) | (COUK-GuestCenterRestCC-Name) |    14    |      6    | 14:00   |    17:00    | 16              | 4111111111111111  | 432 |

  @concierge-user-make-cancel
  Scenario Outline: Concierge makes and cancels a CC reservation via restaurant profile

    Given I set test domain to "<domain>"
    When I navigate to url "<concierge_login_page>"
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
    And I fill in "Name on CC" with "<fname> <lname>"
    And I fill in  CC number "<credit_card_number>" and exp date if needed
    And I fill in "CVV" with "<cvv>"
    And I complete reservation
    Then I verify reservation details on view page
    Then I click "Modify"
    And I set reservation date to "<change_days_fwd>" days from today
    And I set reservation time to "<change_time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I click exact time slot
    And I complete reservation
    Then I verify reservation details on view page
    Then I cancel reservation


  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from                                    |     rest_name                |  concierge_login_page                 |    concierge user | password  |days_fwd | party_sz |  time    |  fname  | lname  | change_time | change_days_fwd |credit_card_number | cvv |
    | .com   |restaurant/profile/(COM-GuestCenterRestCC-RID) | (COM-GuestCenterRestCC-Name) | http://www.opentable.com/my/concierge | us_auto_concierge | password  |   13    | 6 people |  4:00 PM | Joé-Joé | O'Áuto | 9:00 PM     |      13         | 4111111111111111  | 432 |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from                                      |      rest_name                |  concierge_login_page                   | concierge user    | password  | days_fwd | party_sz | time  |  fname  | lname  | change_time | change_days_fwd |credit_card_number | cvv |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRestCC-RID) | (COUK-GuestCenterRestCC-Name) | http://www.opentable.co.uk/my/concierge | uk_auto_concierge | password  |     13   | 6        | 16:00 | Joé-Joé | O'Áuto | 21:00       |     13          | 4111111111111111  | 432 |
