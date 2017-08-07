@qa-only
@Avail-Service-integration
@avail-service-POPSuppressHoliday

Feature: Consumer search - [POP Suppress Holiday] - standard points if search is done on POP suppressed Holiday

Background:
      And I start with a new browser
Scenario Outline: Consumer search - [POP Suppress Holiday] - standard points if search is done on POP suppressed Holiday

     Given I Add a POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
   Scenarios: perform search using search day = POPSuppressed Holiday date and time = POP Time
   | RID              | day_offset | search_day_offset | search_time    | points_1 | slot_time_1     |
   | (COM-POP2-RID)   | 16         | 16                |  10:00 PM      | 100      | 10:00 PM        |

@Region-NA
   Scenarios: perform search using search day !=POPSuppressed Holiday date and time = POP Time
   | RID             | day_offset | search_day_offset | search_time  | points_1  | slot_time_1     |
   | (COM-POP2-RID)  | 16         | 2                 |  10:00 PM    |  1000     | 10:00 PM        |



Scenario Outline: remove POP suppressed Holiday day and check POP time appears

    Given I Remove POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
    When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
    Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"


@Region-NA
    Scenarios: perform search using search day != Suppressed date and time = POP Time
    | RID             | day_offset | search_day_offset  | search_time   | points_1  | slot_time_1 | points_2 | slot_time_2 |
    | (COM-POP2-RID)  | 16         | 16                 |  10:00 PM     | 1000       | 10:00 PM   |  100      | Early      |





