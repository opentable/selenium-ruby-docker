@Points
@Web-bat-tier-1
@Team-WarMonkeys


Feature: [Redeem Dining Points]
  Redeem Dining Points - As an Opentable user I can redeem my dining points and verify redemption email received.

  Scenario Outline: Regular registered user redeems dining points for Opentable and/or Amazon Gift cards

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    And I close the browser
  #  #Adding points in CHARM
    And I login to CHARM
    And I click "User Info"
    And I fill in "Email" with random email
    And I click "Submit"
    Then I click link with exact text "Adjust Points"
    Then I should see text " Point Adjustment & History Tracking" on page
    Then I should see "Customer Name:" text in the span id "lblCustomerName"
    Then I should see "Point Adjustment Reason:" text in the span id "lblPointAdjustmentReason"
    Then I select "Points Adjustment Reason" item "Points Expiration Reversal"
    Then I fill in "Points To Add" with "<add_points>"
    Then I click "Add Points" and I click alert OK button
    Then I close the browser
  #Redeeming points on Website
    Then I start with a new browser
    When I navigate to url "<start_from>"
    Then I login as registered user
    Then I click "My Profile"
    Then I store current user points
    Then I should see text "<points_option>" on page
    Then I click "<gift_type>"
    Then I select "<redeem_points>" points from the redemption value
    Then I should see points changed by "<redeem_points>" amount in the Redemption page
    Then I click "Continue" in the Redemption page
    Then I should see points changed by "<redeem_points>" amount in the Redemption Confirm page from "<add_points>"
    And I check the email address for the login user
    Then I click "Redeem" in the Redemption confirm page
    And I have successfully redeemed my points the Redemption Complete page with banner "<success_claims_msg>"
    ## The last two steps are blocked by a bug filed in AUTO-131
#    Then I click "My Profile"
#    Then I should see points changed by "<redeem_points>" amount
#
  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from     | add_points | points_option                             |  gift_type   | redeem_points  | success_claims_msg                      |
    | .com   | start.aspx?m=4 | 10000      | You have enough for a 10,000 Point reward | GiftCard     |     2000       |Your Dining Rewards Gift is on the way!  |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from     | add_points | points_option                             | gift_type  | redeem_points  | success_claims_msg                      |
    | .com   | start.aspx?m=4 | 5000       | You have enough for a 5,000 Point reward  | AmazonCard |     2000       |Your Amazon.com Gift Card is on the way! |

#  @Region-EU @Domain-CO.UK  ##No Gift Card available - just dining cheques
#  Scenarios:
#    | domain | start_from     | add_points | points_option                             |  gift_type | redeem_points  | success_claims_msg                      |
#    | .co.uk | start.aspx?m=72| 10000      | You have enough points for a £70 reward!  |  GiftCard  |     4000       |Your Dining Rewards Gift is on its way!  |
#

  Scenario Outline: Regular registered user redeems dining points with dining cheques

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    And I close the browser
  #  #Adding points in CHARM
    And I login to CHARM
    And I click "User Info"
    And I fill in "Email" with random email
    And I click "Submit"
    Then I click link with exact text "Adjust Points"
    Then I should see text " Point Adjustment & History Tracking" on page
    Then I should see "Customer Name:" text in the span id "lblCustomerName"
    Then I should see "Point Adjustment Reason:" text in the span id "lblPointAdjustmentReason"
    Then I select "Points Adjustment Reason" item "Points Expiration Reversal"
    Then I fill in "Points To Add" with "10000"
    Then I click "Add Points" and I click alert OK button
    Then I close the browser
##  #Redeeming points on Website
    Then I start with a new browser
    When I navigate to url "<start_from>"
    Then I login as registered user
    Then I click "My Profile"
    Then I store current user points
    Then I should see text "<points_option>" on page
    Then I click "Get your Dining Cheque"
    Then I click "Redeem 2,000 points"
    Then I fill in "Address Line1" with "<address>"
    Then I fill in "City" with "<city>"
    Then I select "State" item "<state>"
    Then I fill in "Zip" with "<zip>"
    Then I click "Continue"
    Then I should see text "<review_claim_header>" on page
    Then I click "Claim Reward"
    Then I should not see text "<review_claim_header>" on page
#    Then I click "My Profile"
    And I should see text "<new_balance_msg>" on page
#    Then I should see points changed by "2000" amount


  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | start_from      | points_option                            | address           | city        | zip      | review_claim_header                       | state   |                  new_balance_msg                  |
    | .co.uk | start.aspx?m=72 | You have enough points for a £70 reward! | 400 Market Street | SOUTHAMPTON | SO31 4NG | Please review to claim your dining cheque | nostate | Your new account balance is: 8,000 dining points  |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | start_from       | points_option                           | address           | city  | zip      | review_claim_header                                                                                | state   |                   new_balance_msg        |
    | .jp    | start.aspx?m=201 | お持ちのポイントを分の特典と交換できます！ | 400 Market Street | tokyo | 104-0061 | 下記のお申し込み内容を必ずご確認ください。お申し込み後の取り消し、ご変更はいたしかねますのでご了承ください | JPState | お引き換え後のポイント残高: 8,000 ポイント |

  @Region-NA @Domain-COM.fr-CA  ##Doesn't take state
  Scenarios:
    | domain     | start_from      | points_option                                         | address           | city     | zip     | review_claim_header                        | state   |                   new_balance_msg                 |
    | .com/fr-CA | start.aspx?m=74 | Vous avez assez de points pour une rcompense de $130! | N2100 Regina St S | Waterloo | N2J 1P6 | Please review and claim your reward below: | Ontario | Your new account balance is: 8,000 dining points  |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | start_from       | points_option                                     | address            | city   | zip   | review_claim_header                                   |  state  |                 new_balance_msg                  |
    | .de    | start.aspx?m=227 | Sie haben genügend Punkte für eine 10.000 Prämie! | Kurfürstendamm 153 | Berlin | 10709 | Bitte Ihre Vergütung unten überprüfen und einfordern: | Berlin  | Ihr neuer Kontostand ist: 8.000 OpenTable-Punkte |
