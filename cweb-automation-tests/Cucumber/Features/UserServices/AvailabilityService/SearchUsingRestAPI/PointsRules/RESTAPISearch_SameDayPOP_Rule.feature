@qa-only
@Avail-Service-integration
@avail-service-sameDayPOPThreshhold
Feature: V3 REST Search returns - POP pointType and PointValue when search falls within POP schedule.

Background:


Scenario Outline: V3 REST Search returns  : same day POP schedule : should return POP time after threshold.

     Given I add same-Day POP schedule for RID "<RID>", ThresholdTime as PAST time, for DIP StartTime "23:00", EndTime "23:30"
     And I recache consumer website for "all" item
     When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
     Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"
     And I verify REST API brings Points "<points_2>" slot "<slot_time_2>" for restaurant "<RID>"

@Region-NA
   Scenarios: same day POP schedule : should return POP time after threshold.
   | RID                | search_day_offset | search_time   | points_1  | slot_time_1 | points_2 | slot_time_2 |
   | (COM-ERB24hr-RID)  | 0                 |  23:00        | 1000      | Exact       |  100     | Early       |

Scenario Outline: V3 REST Search returns - Qualified Search returns - default pointType and PointValue.


     Given I add same-Day POP schedule for RID "<RID>", ThresholdTime as FUTURE time, for DIP StartTime "23:00", EndTime "23:30"
     And I recache consumer website for "all" item
     When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
     Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"
     And I verify REST API brings Points "<points_2>" slot "<slot_time_2>" for restaurant "<RID>"

@Region-NA
   Scenarios: same day POP schedule : should NOT return POP time before threshold.
   | RID                | search_day_offset | search_time   | points_1  | slot_time_1 | points_2 | slot_time_2 |
   | (COM-ERB24hr-RID)  | 0                 |  23:00        | 100      | Exact       |  100     | Early       |


Scenario Outline: remove same day POP : Standard points slots returned

    Given I remove same-Day POP schedule for RID "<RID>"
    And I recache consumer website for "all" item
    #And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList" item
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"

@Region-NA
Scenarios: search time is POP time - verify slot within POP window/slot outside of POP window
| RID                | search_day_offset | search_time   | p_type1       |  p_value1  | time1 |
| (COM-ERB24hr-RID)  | 0                 |  23:00        | Standard      |  100       | 23:00 |

