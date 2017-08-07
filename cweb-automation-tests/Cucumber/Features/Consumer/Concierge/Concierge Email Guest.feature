@Web-bat-tier-2
@Concierge
@Team-WarMonkeys

Feature: [Concierge Email Guest]

  Background:
#Add setup steps to run before each Scenario


  Scenario Outline: Concierge Email Guest
  Manual Case(s):Concierge Email Guest

    Given I am an existing "concierge" user with "<concierge user>" loginname and "<email>" email and have upcoming reservation in "3" at restaurant "<rest_rid>" in "<domain>"
    And I navigate to url "<concierge_login_page>"
    Then I login as concierge with username "<concierge user>" and password "<password>"
    And I click "Upcoming Reservation Count"
    And I click "View" in Upcoming Reservation window
    And I click "Email Guest"
    And I fill in "Email Address" with "<email>"
    And I click "Send Now"
    Then I should see msg in url
    ##Todo:  Need to come up with a better way to get to email.
#    Then I check email with subject "<email_subject>"
    Then I click "My Profile"
    And I click "View all reservations"
    And I cancel reservation
    And I close the browser

#
#  @Region-NA @Domain-COM
#  Scenarios:
#    | domain | concierge_login_page                         | concierge user    | password | rest_rid                  | email                     | email_subject                                  |
#    | .com   | http://www.opentable.com/conciergelogin.aspx | us_auto_concierge | password | (COM-GuestCenterRest-RID) | usconcierge@opentable.com | Your Reservation at (COM-GuestCenterRest-Name) |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | concierge_login_page                        | concierge user    | password |  rest_rid                | email                     | email_subject         |
    | .jp    | http://www.opentable.jp/conciergelogin.aspx | jp_auto_concierge | password | (JP-GuestCenterRest-RID) | jpconcierge@opentable.com | Concierge email guest |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | concierge_login_page                        | concierge user    | password |  rest_rid                | email                     | email_subject                                  |
    | .de    | http://www.opentable.de/conciergelogin.aspx | de_auto_concierge | password | (DE-GuestCenterRest-RID) | deconcierge@opentable.com | Ihre Reservierung im (JP-GuestCenterRest-Name) |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | concierge_login_page                           | concierge user    | password | rest_rid                   | email                     | email_subject                               |
    | .co.uk | http://www.opentable.co.uk/conciergelogin.aspx | uk_auto_concierge | password | (COUK-GuestCenterRest-RID) | ukconcierge@opentable.com | Your Booking at (COUK-GuestCenterRest-Name) |