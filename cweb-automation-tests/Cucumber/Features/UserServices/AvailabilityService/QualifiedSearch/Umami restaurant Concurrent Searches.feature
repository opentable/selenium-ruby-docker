@Avail-Service
Feature:  Concurrent Umami searches.

Background:



Scenario Outline: Concurrent Umami searches.

      Given I set test domain to "<domain>"
      And I use test restaurant "<RID>"
      When I call concurrent searches using umami rids "(COM-UMAMI2-RID),(COM-UMAMI24hr-RID)" for tomorrow, search time "<search_time>"
      Then I verify each request returns availability


@Region-NA
   Scenarios:
   | RID               |  search_time  |  domain |
   | (COM-UMAMI2-RID)  |   14:00       |  .com   |