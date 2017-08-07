@Avail-Service-points
Feature: Availability Service - Qualified Search returns - default pointType and PointValue.

Background:



Scenario Outline: Availability Service - Qualified Search returns - default pointType and PointValue.

     Given I use test restaurant "<RID>"
     When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "<popFlag>"
     Then I verify PointsType "<p_type>", PointsValue "<p_value>" for time slot "<time>"

@Region-NA  @incomplete
   Scenarios: search for a non POP restaurant - without passing POPFlag
   | RID                 | search_day_offset | search_time  | p_type   |  p_value | time  | popFlag |
   | (COM-POP2-RID)      | 2                 |  19:00       | Standard |  100     | 19:00 |         |

#@Region-NA
#   Scenarios: search for a non POP restaurant - passing POPFlag as true
#   | RID                 | search_day_offset | search_time  | p_type   |  p_value | time  | popFlag |
#   | (COM-SIMSearch-RID) | 2                 |  19:00       | Standard |  100     | 19:00 |  true   |
#
#@Region-NA
#   Scenarios: search for a non POP restaurant - passing POPFlag as false
#   | RID                 | search_day_offset | search_time  | p_type   |  p_value | time  | popFlag |
#   | (COM-SIMSearch-RID) | 2                 |  19:00       | Standard |  100     | 19:00 |  false   |









