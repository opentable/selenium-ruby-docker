@qa-only
@Avail-Service-integration
@avail-service-CreditCardPartySizeRule

Feature: consumer site:  CreditCard Required rule [ PS Rule ]

Background:
  Then I start with a new browser

Scenario Outline: CC info is required  for PS => CCMinPS

  Given I set test restaurant "<RID>" Credit card required Min Party Size "<cc_min_ps>" limit
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantCCBlockedDayMessages" item
  When I perform consumer site search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "<ps>"
  Then I verify Consumer site Single search brings Availability at time "<search_time>"
  And I verify Credit Card required for slot time "<search_time>" at details page


@Region-NA
   Scenarios: search for CC day
   | RID                     | cc_min_ps |search_day_offset | search_time | ps  |
   | (COM-SIMSearch-RID)     | 4         |  2               | 7:00 PM     | 4   |

#@Region-NA
#   Scenarios: search for CC day
#   | RID                     | cc_min_ps |search_day_offset | search_time | ps  |
#   | (COM-SIMSearch-RID)     | 4         |  2               | 7:00 PM     | 5   |

 Scenario Outline: CC info is NOT required  for PS < CCMinPS

  Given I set test restaurant "<RID>" Credit card required Min Party Size "<cc_min_ps>" limit
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantCCBlockedDayMessages" item
  When I perform consumer site search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "<ps>"
  Then I verify Consumer site Single search brings Availability at time "<search_time>"
  And I verify Credit Card NOT required for slot time "<search_time>" at details page


@Region-NA
   Scenarios: search for CC day
   | RID                     | cc_min_ps |search_day_offset | search_time | ps  |
   | (COM-SIMSearch-RID)     | 4         |  2               | 7:00 PM     | 3   |














