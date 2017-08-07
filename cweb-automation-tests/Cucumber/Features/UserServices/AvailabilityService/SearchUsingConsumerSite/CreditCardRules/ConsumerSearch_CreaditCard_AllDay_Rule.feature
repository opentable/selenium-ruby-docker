@qa-only
@Avail-Service-integration
@avail-service-CreditCardAllDayRule

Feature:  consumer site:  CreditCard Required rule [ All day ]

Background:
    Then I start with a new browser

Scenario Outline: CreditCard Required rule : CC info is needed for a CCAll day rule

    Given I set CC day for "<cc_day_offset_from_today>" days from today for test restaurant "<RID>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantCCBlockedDayMessages" item
    When I perform consumer site search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "<ps>"
    Then I verify Consumer site Single search brings Availability at time "<search_time>"
    And I verify Credit Card required for slot time "<search_time>" at details page

@Region-NA
   Scenarios: search for CC day
   | RID                     | cc_day_offset_from_today |search_day_offset | search_time | ps  |
   | (COM-SIMSearch-RID)     | 2                        |   2              | 7:00 PM     | 2   |


Scenario Outline: CreditCard Required rule : CC info is NOT needed for a NON CC day rule

      Given I set CC day for "<cc_day_offset_from_today>" days from today for test restaurant "<RID>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantCCBlockedDayMessages" item
      When I perform consumer site search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "<ps>"
      Then I verify Consumer site Single search brings Availability at time "<search_time>"
      And I verify Credit Card NOT required for slot time "<search_time>" at details page


@Region-NA
   Scenarios: search for non CC day
   | RID                     | cc_day_offset_from_today |search_day_offset  | search_time | ps  |
   | (COM-SIMSearch-RID)     | 2                        |   1               | 7:00 PM     | 2   |
#










