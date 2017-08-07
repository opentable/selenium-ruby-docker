@Concierge
@Web-bat-tier-2
@Team-WarMonkeys

Feature: [Concierge can now login from login page ]

  @Add-new-concierge
  Scenario Outline: Concierge login on login popup
  Given I set test domain to "<domain>"
#  Given I start new browser with re-design cookie for domain "<domain>"
  And I login on "<loginpage>" page with "<conciergeemail>" and "<password>"
  Then I should be on start page

  @Region-NA @Domain-COM
  Scenarios:
  | domain |  conciergeemail    |  password  |loginpage |
  | .com   |  us_auto_concierge |  password  | https://www.opentable.com/my/loginpopup |

  @Region-NA @Domain-COM.MX
  Scenarios:
  | domain  |  conciergeemail    |  password  |loginpage |
  | .com.mx |  mx_auto_concierge |  password  | https://www.opentable.com.mx/my/loginpopup |

  @Region-EU @Domain-CO.UK
  Scenarios:
  | domain |  conciergeemail    |  password  | loginpage |
  | .co.uk |  uk_auto_concierge |  password  | https://www.opentable.co.uk/my/loginpopup |

  @Region-EU @Domain-DE
  Scenarios:
  | domain |  conciergeemail    |  password  |loginpage |
  | .de    |  de_auto_concierge |  password  | https://www.opentable.de/my/loginpopup |
  @Region-asia @Domain-JP
  Scenarios:
  | domain |  conciergeemail    |  password  |loginpage |
  | .jp    |  jp_auto_concierge |  password  | https://www.opentable.jp/my/loginpopup |



