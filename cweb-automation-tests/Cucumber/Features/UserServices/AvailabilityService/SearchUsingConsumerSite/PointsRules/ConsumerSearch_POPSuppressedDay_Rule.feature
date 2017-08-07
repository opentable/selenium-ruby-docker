@qa-only
@Avail-Service-integration
@avail-service-POPSuppressDay

Feature: Consumer Search - [POP Suppress Day]

Background:
        And I start with a new browser


Scenario Outline: Consumer Search - [POP Suppress Day]

     Given I Add suppress POP date "<day_offset>" days from today for Test restaurant "<RID>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
   Scenarios: perform search using search day = Suppressed date and time = POP Time
   | RID             | day_offset | search_day_offset | search_time    |   points_1  | slot_time_1 |
   | (COM-POP2-RID)  | 20          | 20                |  10:00 PM     |   100       | 10:00 PM    |

@Region-NA
   Scenarios: perform search using search day <> Suppressed date and time = POP Time
   | RID             | day_offset | search_day_offset | search_time    |   points_1  | slot_time_1 |
   | (COM-POP2-RID)  | 20         | 19                |  10:00 PM      |   1000      | 10:00 PM       |




Scenario Outline: Consumer Search - remove suppress day and check POP time appears.

      Given I remove suppress POP date "<day_offset>" days from today for Test restaurant "<RID>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList" item
      When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
      Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
    Scenarios: perform search using search day = Suppressed date and time = POP Time
    | RID             | day_offset | search_day_offset | search_time    |   points_1  | slot_time_1 |
    | (COM-POP2-RID)  | 20          | 20                |  10:00 PM     |   1000       | 10:00 PM    |



