@Reservations
@Web-bat-tier-1
@Wishlist

Feature: [Wishlist - Reservation Make-Change-Cancel] Anyone can make and cancel a reservation via wishlist

  @user-wishlist-make-cancel
  Scenario Outline: Multiple users makes and cancels a reservation via restaurant profile

    Given I set test domain to "<domain>"
    Then I set restaurant "<rid>" to be waitlist enabled
    Then I add diner number "1", "testuser@aaa.com", party_size "1" to waitlist for restaurant "<rid>"
    And I start with a new browser
    Then I navigate to url "<start_from>"
    Then I set user info username "otprodtester@gmail.com", password "0pentab1e", firstname "Prodtester", lastname "Opentable", phone ""
    And I set party size to "<party_sz>"
    And I click "Find a Table"
    And I should see "<wait_list_queue>" in the wait list queue
    Then I click "Join Waitlist Now"
    And I verify "<party_sz>", date and "<wait_list_queue2>" in the wait-list details page
    And I sign in as registered user
    And I commit to waitlist
    Then I verify diner's "2" reservation details on Waitlist View page
    Then I close and open a browser and clear cookies
    Then I navigate to url "<start_from>"
    And I set party size to "<party_sz2>"
    And I click "Find a Table"
    And I should see "<wait_list_queue3>" in the wait list queue
    Then I click "Join Waitlist Now"
    And I verify "<party_sz2>", date and "<wait_list_queue4>" in the wait-list details page
    And I setup and sign in as anonymous user
    And I commit to waitlist
    Then I verify diner's "3" reservation details on Waitlist View page
    Then Waitlist diner "1" leaves waitlist and my queue position is reset to "<wait_list_queue2>"
    Then I verify diner's "3" reservation details on Waitlist View page
    Then I leave the waitlist as Diner "3"

  @Region-NA @Domain-COM
  Scenarios:
    | domain |              start_from                |        rid        |  party_sz | wait_list_queue | wait_list_queue2 | party_sz2 |  wait_list_queue3  | wait_list_queue4 |
    | .com   | restaurant/profile/(COM-WaitList-RID)  | (COM-WaitList-RID)| 4 people  | 1 party in line |   2nd in line    | 3 people  | 2 parties in line  |   3rd in line    |


  Scenario Outline: Diners makes and cancels waitlist reservation via restref

    Given I set test domain to "<domain>"
    Then I set restaurant "<rid>" to be waitlist enabled
    Then I add diner number "1", "testuser@aaa.com", party_size "1" to waitlist for restaurant "<rid>"
    And I start with a new browser
    Then I navigate to url "<start_from>"
    And I set party size to "<party_sz2>"
    And I click "Find a Table"
    Then I click "Join Waitlist Now"
    And I verify "<party_sz2>", date and "<wait_list_queue2>" in the wait-list details page
    And I setup and sign in as anonymous user
    And I commit to waitlist
    Then I verify diner's "2" reservation details on Waitlist View page
    Then I leave the waitlist as Diner "2"

  @Region-NA @Domain-COM
    Scenarios:
      | domain |                              start_from                                    |        rid        | wait_list_queue2 | party_sz2 |
      | .com   | restaurant/profile/(COM-WaitList-RID)/reserve?restref=(COM-WaitList-RID)   | (COM-WaitList-RID)|   2nd in line    | 3 people  |

  Scenario Outline: View and cancel waitlist reservation through upcoming reservation box.

    Given I set test domain to "<domain>"
    Then I set restaurant "<rid>" to be waitlist enabled
    Then I add diner number "1", "<registered_user>", party_size "1 person" to waitlist for restaurant "<rid>"
    Then I start with a new browser
    Then I login with username "<registered_user>" and password "<password>"
    And I click "Upcoming Reservation Count"
    And I click "View" in Upcoming Reservation window
    Then I should be on URL containing "book/wait-list/view"
    Then I verify diner's "1" reservation details on Waitlist View page
    And I click "Upcoming Reservation Count"
    And I click "Cancel" in Upcoming Reservation window
    Then I should be on URL containing "book/wait-list/cancel"
    Then I leave the waitlist as Diner "1" from Waitlist Cancel page

  @Region-NA @Domain-COM
    Scenarios:
      | domain | registered_user  | password |        rid          |
      | .com   | testuser@aaa.com | password | (COM-WaitList-RID)  |

  Scenario Outline: View and cancel waitlist reservation through my profile.

    Given I set test domain to "<domain>"
    Then I set restaurant "<rid>" to be waitlist enabled
    Then I add diner number "1", "<registered_user>", party_size "1 person" to waitlist for restaurant "<rid>"
    Then I start with a new browser
    Then I login with username "<registered_user>" and password "<password>"
    Then I click "My Profile"
    And I click View in the Upcoming Reservation section of My Profile
    Then I should be on URL containing "book/wait-list/view"
    Then I verify diner's "1" reservation details on Waitlist View page
    Then I click "My Profile"
    And I click Cancel in the Upcoming Reservation section of My Profile
    Then I should be on URL containing "book/wait-list/cancel"
    Then I leave the waitlist as Diner "1" from Waitlist Cancel page

  @Region-NA @Domain-COM
    Scenarios:
      | domain | registered_user  | password |        rid          |
      | .com   | testuser@aaa.com | password | (COM-WaitList-RID)  |

