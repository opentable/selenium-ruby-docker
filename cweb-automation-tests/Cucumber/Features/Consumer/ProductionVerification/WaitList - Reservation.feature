@Reservations
@Web-bat-tier-0
@WaitList

Feature: [WaitList - Reservation Make-Change-Cancel] Anyone can make and cancel a reservation via waitlist

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
      | domain |             start_from                  |        rid        | wait_list_queue2 | party_sz2 |
      | .com   | restaurant/profile/(COM-WaitList-RID)   | (COM-WaitList-RID)|   2nd in line    | 3 people  |


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
      | domain |                              start_from                                  |        rid        | wait_list_queue2 | party_sz2 |
      | .com   | restaurant/profile/(COM-WaitList-RID)/reserve?restref=(COM-WaitList-RID) | (COM-WaitList-RID)|   2nd in line    | 3 people  |