@Concierge
@Web-bat-tier-2
@Team-WarMonkeys

Feature: [Add a New Concierge]

  @Add-new-concierge
  Scenario Outline: Add a new concierge
    Given I set test domain to "<domain>"
    When I navigate to url "<concierge_login_page>"
    Then I login as concierge with username "<concierge user>" and password "<password>"
    When I navigate to url "http://www.opentable<domain>/conciergeadd.aspx"
    And I set conciergeadd page for foreign guests when I am in Japan
    And I enter random text with length 10 into "First Name" and store the value under "First_Name"
    And I enter random text with length 10 into "Last Name" and store the value under "Last_Name"
    And I enter random text with length 8 into "Login" and store the value under "Login"
    Then I fill in "Password" with "password"
    Then I fill in "Re-type Password" with "password"
    Then I fill in "Email Address" with random email
    Then I fill in "Phone" with "<phone>"
    Then I click "Add"
    Then I should see text "<message>" on page
    And I should see text "[First_Name]" on page
    And I should see text "[Last_Name]" on page
    And I should see text with down case stored under "Login"
    And I close the browser


  @Region-NA @Domain-COM
  Scenarios:
  | domain | concierge_login_page                          | concierge user | password | phone      | message                         |
  | .com   | http://www.opentable.com/conciergelogin.aspx | auto_concierge | password | 4152345678 | A new concierge has been added. |

  @Region-NA @Domain-COM.MX
  Scenarios:
  | domain | concierge_login_page                             | concierge user | password | phone      | message                         |
  | .com.mx | http://www.opentable.com.mx/conciergelogin.aspx| mx_auto_concierge | password | 4152345678 | Un nuevo conserje se ha añadido. |


  @Region-EU @Domain-CO.UK
  Scenarios:
  | domain | concierge_login_page                           | concierge user | password | phone      | message                         |
  | .co.uk |http://www.opentable.co.uk/conciergelogin.aspx | auto_concierge | password | 4152345678 | A new concierge has been added. |

  @Region-EU @Domain-DE
  Scenarios:
  | domain | concierge_login_page                        | concierge user | password | phone      | message                               |
  | .de    |http://www.opentable.de/conciergelogin.aspx| auto_concierge | password | 4152435416 | Ein neuer Concierge wurde hinzugefügt |

  @Region-Asia @Domain-JP
  Scenarios:
  | domain | concierge_login_page                        | concierge user | password | phone      | message                            |
  | .jp    | http://www.opentable.jp/conciergelogin.aspx  | auto_concierge | password | 4152435416 | 新しいコンシェルジュが追加されました。  |

