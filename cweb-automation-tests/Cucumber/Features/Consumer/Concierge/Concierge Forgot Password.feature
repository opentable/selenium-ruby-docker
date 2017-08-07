@Concierge
@Web-bat-tier-2
@Team-WarMonkeys

Feature: [Concierge Forgot Password]

  Scenario Outline:Concierge User can change password,by clicking on 'Forgot Password' link on Concierge login page.


    Then I set mail server account login to "<email_login>"
    Then I set mail server account password to "<password>"
    Given I set test domain to "<domain>"
    When I navigate to url "<concierge_login_page>"
    And I click link with exact text "<Forgot_password_link>"
    When I fill in "User Name" with "<email_login>"
    And I click "Reset Password"
    Then I check email for "Concierge Forgot Password"
    Then I click link in email to reset password
    When I fill in "Enter password" with "<con_password>"
    When I fill in "Re-enter password" with "<con_password>"
    And I click "Update Profile"
    Then I should be on URL containing "<concierge_login_page>"
    Then I close the browser
    When I navigate to url "<concierge_login_page>"
    Then I login as concierge with username "<concierge user>" and password "<con_password>"
    And I go to start page with query string "<metro_id>"
    Then I should see element "Concierge Logo" on page
    Then I click "My Profile"
    And I should see link with text "<home>"
    And I should see link with text "<my_profile>"
    And I should see link with text "<sign_out>"
    And I should see link with text "<reports>"
    And I should see link with text "<help>"
    And I close the browser


  @Region-NA @Domain-COM
  Scenarios:
    | domain | concierge_login_page | Forgot_password_link  | concierge user    | con_password | metro_id | email_login               | password  | help | home | my_profile | reports | sign_out |
    | .com   | conciergelogin.aspx  | Forgot Password?      | us_auto_concierge | password     | m=4      | usconcierge@opentable.com | opentable | Help | Home | My Profile | Reports | Sign Out |

  @Region-EU @Domain-DE
   Scenarios:
      | domain | concierge_login_page | Forgot_password_link | concierge user    | con_password | metro_id | email_login               | password  | help  | home | my_profile  | reports  | sign_out |
      | .de    | conciergelogin.aspx | Hilfe, ich habe mein Passwort vergessen ›  | de_auto_concierge | password     | m=227    | deconcierge@opentable.com | opentable | Hilfe | Home | Mein Profil | Berichte | Abmelden |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | concierge_login_page | Forgot_password_link  | concierge user    | con_password | metro_id | email_login               | password  | help  | home | my_profile | reports | sign_out |
    | .co.uk | conciergelogin.aspx | Forgot Password? | uk_auto_concierge | password     | m=72     | ukconcierge@opentable.com | opentable |  Help | Home | My profile | Reports | Sign out |

    ## Unable to save password using english in my profiles page
  @Region-Asia @Domain-JP @incomplete
  Scenarios:
    | domain | concierge_login_page | Forgot_password_link | concierge user    | con_password | metro_id | email_login               | password  | help  | home  | my_profile       | reports    | sign_out |
    | .jp    | conciergelogin.aspx |パスワードをお忘れの方  | jp_auto_concierge | password     | m=201      | jpconcierge@opentable.com | opentable | ヘルプ  | ホーム | マイ プロフィール  | レポート    | ログアウト |
