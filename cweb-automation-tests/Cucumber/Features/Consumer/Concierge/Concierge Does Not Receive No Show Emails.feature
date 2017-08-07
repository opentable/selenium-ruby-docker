@Concierge
@Web-bat-tier-2
@Team-WarMonkeys

Feature: [Concierge Does Not Receive No Show Emails]

  Scenario Outline:Concierge User does not receive 'No-Show' email

    Given I am an existing "concierge" user with "<concierge user>" loginname and "<email_login>" email and have upcoming reservation in "3" at restaurant "<rest_rid>" in "<domain>"
    Then I set mail server account login to "<email_login>"
    Then I set mail server account password to "<password>"
    Then I connect to database "<database>" as "<login>"
    And I update the reservation status to NS and move the reservation to past date
    Then I should not receive no-show email

  @Region-NA @Domain-COM
  Scenarios:
    | domain | concierge user    | rest_rid                  |  database         | login              | email_login               | password  |
    | .com   | us_auto_concierge | (COM-GuestCenterRest-RID) | webdb-na-primary | automation/aut0m8er | usconcierge@opentable.com | opentable |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | concierge user    | rest_rid                   | database         | login               | email_login               | password  |
    | .co.uk | uk_auto_concierge | (COUK-GuestCenterRest-RID) | webdb-eu-primary | automation/aut0m8er | ukconcierge@opentable.com | opentable |

  @Region-EU @Domain-DE
  Scenarios:
    | domain | concierge user    | rest_rid                 | database         | login               | email_login               | password  |
    | .de    | de_auto_concierge | (DE-GuestCenterRest-RID) | webdb-eu-primary | automation/aut0m8er | deconcierge@opentable.com | opentable |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain | concierge user    | rest_rid                 | database         | login                 | email_login               | password  |
    | .jp    | jp_auto_concierge | (JP-GuestCenterRest-RID) | webdb-asia-primary | automation/aut0m8er | jpconcierge@opentable.com | opentable |