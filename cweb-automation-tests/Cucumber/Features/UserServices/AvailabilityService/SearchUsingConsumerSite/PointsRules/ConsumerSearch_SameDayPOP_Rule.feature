@qa-only
@Avail-Service-integration
@avail-service-sameDayPOPThreshhold
Feature: Consumer Search returns - POP points when search falls within same day POP schedule.

Background:
  And I start with a new browser

Scenario Outline: same day POP schedule : should return POP time after threshold.

     Given I add same-Day POP schedule for RID "<RID>", ThresholdTime as PAST time, for DIP StartTime "23:00", EndTime "23:30"
     #And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
     And I recache consumer website for "all" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"
     Then I verify Consumer site returns "<points_2>" points for time slot "<slot_time_2>"

@Region-NA
   Scenarios: same day POP schedule : should return POP time after threshold.
   | RID                | search_day_offset | search_time   | points_1  | slot_time_1 | points_2 | slot_time_2 |
   | (COM-ERB24hr-RID)  | 0                 |  11:00 PM     | 1000      | 11:00 PM    |  100     | 10:45       |

Scenario Outline: Consumer Search - same day POP schedule : should NOT return POP time before threshold.

     Given I add same-Day POP schedule for RID "<RID>", ThresholdTime as FUTURE time, for DIP StartTime "23:00", EndTime "23:30"
     And I recache consumer website for "all" item
     #And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"
     Then I verify Consumer site returns "<points_2>" points for time slot "<slot_time_2>"

@Region-NA
   Scenarios: same day POP schedule : should NOT return POP time before threshold.
   | RID                | search_day_offset | search_time   | points_1  | slot_time_1 | points_2 | slot_time_2 |
   | (COM-ERB24hr-RID)  | 0                 |  11:00 PM     | 100       |  11:00 PM   |  100     | 10:45       |


Scenario Outline: remove same day POP : Standard points slots returned

    Given I remove same-Day POP schedule for RID "<RID>"
    And I recache consumer website for "all" item
    #And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CacheHolidayList" item
    When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
    Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
    Scenarios:
    | RID               | search_day_offset | search_time   |   points_1  | slot_time_1 |
    | (COM-ERB24hr-RID) | 0                 |  11:00 PM     |   100       | 11:00 PM    |








