@Search
@Web-bat-tier-0

Feature: Search capabilities in Production

  Scenario Outline: Filter metro multi search results

    Given I set test domain to "<domain>"
    And I start with a new browser with locale for "<domain>"
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I should see text "<results_title>" on page
    And I get the number of tables from the results title
    Then I check search filter checkbox "<region>"
    And I should see the number of tables decreased
    Then I uncheck search filter checkbox "<region>"
    Then I check search filter checkbox "<cuisine>"
    And I should see the number of tables decreased
    Then I uncheck search filter checkbox "<cuisine>"
    Then I check search filter checkbox "<price>"
    And I should see the number of tables decreased
    Then I uncheck search filter checkbox "<price>"
    Then I check search filter checkbox "<filter_time>"
    And I should see the number of tables decreased
    Then I uncheck search filter checkbox "<filter_time>"
    Then I click first available time slot in the search results


  @Region-NA @Domain-COM
  Scenarios:
    | domain |         start_from        | days_fwd | party_sz | time     | results_title    |   region  | cuisine  |       price        |     filter_time   |
    | .com   | san-francisco-restaurants |    4     | 2 people | 12:00 PM | tables available | Peninsula | American | $$ ($30 and under) | 1,000 Point Times |

  @Region-NA @Domain-COM.MX
  Scenarios:
    |  domain |       start_from        | days_fwd | party_sz | time     | results_title    |       region      | cuisine  |          price            |   filter_time |
    | .com.mx | mexico-city-restaurants |    4     | 2 people | 12:00 PM | mesas disponibles | Ciudad de México | Americana | $$$ (De MXN310 a MXN500) | {0} solamente |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |     start_from     | days_fwd | party_sz | time  |       results_title      |     region     | cuisine  |       price        | filter_time |
    | .co.uk | london-restaurants |    4     | 2 people | 12:00 | tables with availability | City of London | American | ££ (£25 and under) |  {0} Only   |

  @Region-EU @Domain-DE
  Scenarios:
    | domain |      start_from       | days_fwd | party_sz | time  | results_title    |       region       |   cuisine    |        price         | filter_time |
    |  .de   | c/munchen-restaurants |    4     | 2 people | 12:00 | Tische verfügbar | Bayerisch-Schwaben | Amerikanisch | €€€ (31 bis 50 Euro) | Nur {0} Uhr |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain |    start_from     | days_fwd | party_sz | time  |     results_title |       region       |   cuisine   |       price         | filter_time   |
    |  .jp   | tokyo-restaurants |    4     | 2 people | 12:00 | 予約可能なレストラン | 東京23区（都心部以外）|  アメリカ料理 | ¥¥¥（5,000〜9,999円）| {0}のみ表示する |

  @Region-EU @Domain-IE
  Scenarios:
    | domain |   start_from       | days_fwd | party_sz | time  |      results_title       |  region  | cuisine  |       price      | filter_time |
    | .ie    | dublin-restaurants |    4     | 2 people | 12:00 | tables with availability | Dublin 1 |  Italian | £££ (£26 to £40) |   {0} Only  |

  @Region-Asia @Domain-COM.AU
  Scenarios:
    | domain  |     start_from     | days_fwd | party_sz | time     |      results_title       |   region   | cuisine |       price      | filter_time |
    | .com.au | sydney-restaurants |    4     | 2 people | 12:00 PM | tables with availability | Inner West | Italian | $$$ ($41 to $70) |   {0} Only  |



  @pop-search-results
  Scenario Outline: Multi search includes POP results

    Given I set test domain to "<domain>"
    And I start with a new browser with locale for "<domain>"
    And I navigate to url "<start_from>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    Then I should see text "<pop_title>" on page
    Then I click any POP time slot for any restaurant


  @Region-NA @Domain-COM
  Scenarios:
    | domain |        start_from         | days_fwd | party_sz | time     |      pop_title                |
    | .com   | san-francisco-restaurants |    4     | 2 people | 12:00 PM | RESTAURANTS WITH BONUS POINTS |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |    start_from      | days_fwd | party_sz | time  |        pop_title              |
    | .co.uk | london-restaurants |    4     | 2        | 12:00 | RESTAURANTS WITH BONUS POINTS |