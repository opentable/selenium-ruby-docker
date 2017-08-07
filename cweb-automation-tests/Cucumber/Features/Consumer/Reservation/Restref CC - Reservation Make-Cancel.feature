@RestRef
@Reservations
@Web-bat-tier-1

Feature: [RestRef Reservation with stripe credit card]

  Scenario Outline:  Anonymous User makes a Restref reservation with credit card via Stripe - new booking flow

    Given I start with a new browser
    And I set test domain to "<domain>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set reservation time to "<time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    Then I should be on URL containing "details"
    Then I should not see text "<points_message>" on page
    And I fill in "Diner First Name" with "<first_Name>"
    And I fill in "Diner Last Name" with "<last_Name>"
    And I fill in "Phone" with "<phone_number>"
    And I fill in "Email" with random email
    And I fill in "Name on CC" with "<first_Name> <last_Name>"
    And I fill in  CC number "<credit_card_number>" and exp date if needed
    And I fill in "CVV" with "<cvv>"
    And I complete reservation
    And I convert to regular user
    Then I should not see text "<points_message>" on page
    Then I cancel reservation


  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |                                    start_from                                                |            rest_name          |   points_message         | first_Name | last_Name | phone_number | days_fwd | time   | credit_card_number   | cvv | party_sz |
    | .co.uk | restaurant/profile/(COUK-GuestCenterRestCC-RID)/reserve?restref=(COUK-GuestCenterRestCC-RID) | (COUK-GuestCenterRestCC-Name) |  Members earn 100 Points | Joé-Joé    | O'Áuto    | 415-232-5555 |   15     | 19:00  |  5555555555554444    | 432 | 6        |

  @Region-NA @Domain-COM
  Scenarios:
    | domain |                                    start_from                                              |            rest_name         |   points_message         | first_Name | last_Name | phone_number | days_fwd | time    | credit_card_number | cvv | party_sz |
    | .com   | restaurant/profile/(COM-GuestCenterRestCC-RID)/reserve?restref=(COM-GuestCenterRestCC-RID) | (COM-GuestCenterRestCC-Name) |  Members earn 100 Points | Joé-Joé    | O'Áuto    | 415-232-5555 |   15     | 7:00 PM |  5555555555554444  | 432  |6        |

  @Region-EU @Domain-NL @incomplete
    Scenarios:
    | domain |                                    start_from                                            |            rest_name        |   points_message         | first_Name | last_Name | phone_number | days_fwd | time    | credit_card_number | cvv | party_sz |
    | .nl    | restaurant/profile/(NL-GuestCenterRestCC-RID)/reserve?restref=(NL-GuestCenterRestCC-RID) | (NL-GuestCenterRestCC-Name) |  Members earn 100 Points | Joé-Joé    | O'Áuto    | 415-232-5555 |   15     | 19:00 |  5555555555554444  | 432  |6        |


  Scenario Outline:  Anonymous User makes a Restref reservation with credit card via Briantree - new booking flow

    Given I start with a new browser
    And I set test domain to "<domain>"
    Then I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set reservation time to "<time>"
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    Then I click time slot "<time>" for restaurant "<rest_name>" on "<days_fwd>" days from today
    Then I should be on URL containing "details"
    Then I should not see text "<points_message>" on page
    And I fill in "Diner First Name" with "<first_Name>"
    And I fill in "Diner Last Name" with "<last_Name>"
    And I fill in "Phone" with "<phone_number>"
    And I fill in "Email" with random email
    And I fill in "Name on CC" with "<first_Name> <last_Name>"
    And I fill in  CC number "<credit_card_number>" and exp date if needed
    And I complete reservation
    And I convert to regular user
    Then I should be on URL containing "view"
    Then I should not see text "<points_message>" on page
    Then I cancel reservation

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |            start_from                                                                |          rest_name        | points_message          | first_Name | last_Name | phone_number | days_fwd | time   | credit_card_number   | party_sz |
    | .co.uk | restaurant/profile/(COUK-CWAutoTestERB-RID)/reserve?restref=(COUK-CWAutoTestERB-RID) | (COUK-CWAutoTestERB-Name) | Members earn 100 Points | Joé-Joé    | O'Áuto    | 415-232-5555 | 15       | 15:30  | 5555555555554444     | 4        |

  @Region-NA @Domain-COM
  Scenarios:
    | domain |            start_from                                                              |          rest_name       | points_message          | first_Name | last_Name | phone_number | days_fwd |  time     | credit_card_number   | party_sz |
    | .com   | restaurant/profile/(COM-CWAutoTestERB-RID)/reserve?restref=(COM-CWAutoTestERB-RID) | (COM-CWAutoTestERB-Name) | Members earn 100 points | Joé-Joé    | O'Áuto    | 415-232-5555 | 15       |  5:30 PM  | 5555555555554444     |        4 |


  @Region-EU @Domain-DE
  Scenarios:
    | domain |             start_from                                                                    |          rest_name      | points_message          | first_Name | last_Name | phone_number | days_fwd | time   | credit_card_number   | party_sz |
    |   .de  |  restaurant/profile/(DE-CWAutoTestERB-RID)/reserve?restref=(DE-CWAutoTestERB-RID)&lang=de | (DE-CWAutoTestERB-Name) | Members earn 100 Points | Joé-Joé    | O'Áuto    | 415-232-5555 | 15       | 15:30  | 5555555555554444     | 4        |

  @Region-EU @Domain-NL @incomplete
  Scenarios:
    | domain |             start_from                                                                    |          rest_name      | points_message          | first_Name | last_Name | phone_number | days_fwd | time   | credit_card_number   | party_sz |
    |   .nl  |  restaurant/profile/(NL-CWAutoTestERB-RID)/reserve?restref=(NL-CWAutoTestERB-RID)         | (NL-CWAutoTestERB-Name) | Members earn 100 Points | Joé-Joé    | O'Áuto    | 415-232-5555 | 15       | 15:30  | 5555555555554444     | 4        |