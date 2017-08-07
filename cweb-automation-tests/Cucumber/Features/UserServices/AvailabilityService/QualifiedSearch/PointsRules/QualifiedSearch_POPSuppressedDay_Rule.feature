@Avail-Service-points
@avail-service-POPSuppressDay

Feature: Availability Service - [POP Suppress Day]

Background:


Scenario Outline: Availability Service - Qualified Search returns - standard points if search is done on POP suppressed day
     Setup - 1. Auto_Attribution_Rest is setup with POP all days 10 PM - 11 PM window

     Given I Add suppress POP date "<day_offset>" days from today for Test restaurant "<RID>"
     When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
     Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
     And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

@Region-NA @incomplete
   Scenarios: perform search using search day = Suppressed date and time = POP Time
   | RID             | day_offset | search_day_offset | search_time   | p_type1        |  p_value1  | time1 | p_type2  |  p_value2  | time2   |
   | (COM-POP2-RID) | 20          | 20                |  22:00        | Standard       |  100       | 22:00 | Standard |  100       | 21:00   |

@Region-NA  @incomplete
   Scenarios: perform search using search day != Suppressed date and time = POP Time
   | RID             | day_offset | search_day_offset | search_time   | p_type1   |  p_value1 | time1  | p_type2   |  p_value2 | time2   |
   | (COM-POP2-RID)  | 20          | 19               |  22:00        |  POP      |  1000     | 22:00  | Standard  |  100      | 21:00   |



Scenario Outline: remove suppress day and check POP time appears.

      Given I remove suppress POP date "<day_offset>" days from today for Test restaurant "<RID>"
      When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
      Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
      And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"


@Region-NA @incomplete
    Scenarios: perform search using search day != Suppressed date and time = POP Time
    | RID             | day_offset | search_day_offset  | search_time  | p_type1   |  p_value1 | time1  | p_type2   |  p_value2 | time2   |
    | (COM-POP2-RID) | 20          | 20                 |  22:00       |  POP      |  1000     | 22:00  | Standard  |  100      | 21:00   |





