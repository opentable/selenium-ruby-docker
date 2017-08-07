@Avail-Service-ERB
@avail-service-sameDayPOPThreshhold
Feature: Availability Service - Qualified Search returns - POP pointType and PointValue when search falls within POP schedule.

Background:

Scenario Outline: same day POP schedule : should return POP time after threshold.


     Given I add same-Day POP schedule for RID "<RID>", ThresholdTime as PAST time, for DIP StartTime "23:00", EndTime "23:30"
     When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
     Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
     And I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

@Region-NA  @incomplete
   Scenarios: same day POP schedule : should return POP time after threshold.
   | RID                | search_day_offset | search_time   | p_type1  |  p_value1  | time1 | p_type2      | p_value2 | time2 |
   | (COM-ERB24hr-RID)  | 0                 |  23:00        | POP      |  1000      | 23:00 | Standard     |  100     | 22:30 |


Scenario Outline: Availability Service - Qualified Search returns - default pointType and PointValue.
     Setup - Auto_Attribution_Rest is setup with POP all days 10 PM - 11 PM window

     Given I add same-Day POP schedule for RID "<RID>", ThresholdTime as FUTURE time, for DIP StartTime "23:00", EndTime "23:30"
     When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
     Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
     And I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

@Region-NA  @incomplete
   Scenarios: same day POP schedule : should NOT return POP time before threshold.
   | RID                | search_day_offset | search_time   | p_type1      |  p_value1  | time1 | p_type2      | p_value2 | time2 |
   | (COM-ERB24hr-RID)  | 0                 |  23:00        | Standard     |  100       | 23:00 | Standard     |  100     | 22:30 |



Scenario Outline: remove same day POP : Standard points slots returned

  Given I remove same-Day POP schedule for RID "<RID>"
  When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
  Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"


@Region-NA
Scenarios: search time is POP time - verify slot within POP window/slot outside of POP window
| RID             | search_day_offset | search_time   | p_type1       |  p_value1  | time1 |
| (COM-ERB24hr-RID)  | 0                 |  23:00        | Standard      |  100       | 23:00 |








