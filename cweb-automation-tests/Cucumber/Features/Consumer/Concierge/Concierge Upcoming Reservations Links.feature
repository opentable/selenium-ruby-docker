@Concierge
@Web-bat-tier-2
@Team-WarMonkeys

Feature: [Concierge Upcoming Reservations Links]

  Scenario Outline:Concierge Start page displays upcoming reservation link, Reservation links (view/Invite/Modify/Cancel) route to appropriate pages
  View all reservations links route to all reservations for the concierge.

    Given I am an existing "concierge" user with "<concierge user>" loginname and "<email_login>" email and have upcoming reservation in "3" at restaurant "<rest_rid>" in "<domain>"
    When I navigate to url "<concierge_login_page>"
    Then I login as concierge with username "<concierge user>" and password "<password>"
    And I click "Upcoming Reservation Count"
    And I click "View" in Upcoming Reservation window
    Then I should be on URL containing "/book/view"
    And I click "Upcoming Reservation Count"
    And I click "Modify" in Upcoming Reservation window
    Then I should be on URL containing "/book/details"
    And I click "Upcoming Reservation Count"
    And I click "Cancel" in Upcoming Reservation window
    Then I should be on URL containing "/book/cancel"
    And I click "Upcoming Reservation Count"
    And I click "Invite" in Upcoming Reservation window
    Then I should be on URL containing "/book/view"
    And I click "Upcoming Reservation Count"
    And I click link with text "<upcoming_text>"
    Then I should be on URL containing "/profile/info"
    And I close the browser

  @Region-NA @Domain-COM
  Scenarios:
    | domain | concierge_login_page | concierge user    | password | rest_rid                  | email_login              | upcoming_text              |
    | .com   | conciergelogin.aspx  | us_auto_concierge | password | (COM-GuestCenterRest-RID) | usconceige@opentable.com | All upcoming reservations  |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | concierge_login_page | concierge user    | password |rest_rid                  | email_login              | upcoming_text                |
    | .de    | conciergelogin.aspx  | de_auto_concierge | password | (DE-GuestCenterRest-RID) | deconceige@opentable.com | Alle Reservierungen anzeigen |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | concierge_login_page | concierge user    | password | rest_rid                  | email_login              | upcoming_text      |
    | .jp    | conciergelogin.aspx  | jp_auto_concierge | password |  (JP-GuestCenterRest-RID) | deconceige@opentable.com |すべての予約を表示する |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | concierge_login_page | concierge user    | password | rest_rid                   | email_login              | upcoming_text              |
    | .co.uk | conciergelogin.aspx  | uk_auto_concierge | password | (COUK-GuestCenterRest-RID) | deconceige@opentable.com | All upcoming reservations  |


