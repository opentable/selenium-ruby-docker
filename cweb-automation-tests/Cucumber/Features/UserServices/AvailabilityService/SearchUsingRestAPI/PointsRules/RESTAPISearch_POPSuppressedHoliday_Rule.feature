@qa-only
@Avail-Service-integration
@avail-service-POPSuppressHoliday

Feature: REST API Service - [POP Suppress Holiday] - standard points if search is done on POP suppressed Holiday

Background:

Scenario Outline: REST API Service - [POP Suppress Holiday] - standard points if search is done on POP suppressed Holiday

     Given I Add a POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
     When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
     Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"
     And I verify REST API brings Points "<points_2>" slot "<slot_time_2>" for restaurant "<RID>"

@Region-NA
   Scenarios: perform search using search day = POPSuppressed Holiday date and time = POP Time
   | RID              | day_offset | search_day_offset | search_time    | points_1  | slot_time_1 | points_2 | slot_time_2 |
   | (COM-POP2-RID)   | 16         | 16                |  22:00         | 100      | Exact        |  100      | Early       |

@Region-NA
   Scenarios: perform search using search day !=POPSuppressed Holiday date and time = POP Time
   | RID             | day_offset | search_day_offset | search_time  | points_1  | slot_time_1 | points_2 | slot_time_2 |
   | (COM-POP2-RID)  | 16         | 2                 |  22:00       |  1000     | Exact       |  100      | Early       |



Scenario Outline: remove POP suppressed Holiday day and check POP time appears

    Given I Remove POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
    When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
    Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"
    And I verify REST API brings Points "<points_2>" slot "<slot_time_2>" for restaurant "<RID>"


@Region-NA
    Scenarios: perform search using search day != Suppressed date and time = POP Time
    | RID             | day_offset | search_day_offset  | search_time   | points_1  | slot_time_1 | points_2 | slot_time_2 |
    | (COM-POP2-RID)  | 16         | 16                 |  22:00        | 1000       | Exact       |  100      | Early      |





