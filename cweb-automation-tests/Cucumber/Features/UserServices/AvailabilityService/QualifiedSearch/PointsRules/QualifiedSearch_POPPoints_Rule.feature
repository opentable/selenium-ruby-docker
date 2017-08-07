@Avail-Service-points
Feature: Availability Service - Qualified Search returns - POP pointType and PointValue when search falls within POP schedule.
        and test POP Times are not returned when API request doesn't have AlloPOP or AllowPOP is false.

Background:


Scenario Outline: Availability Service [ POP Points Rule ] - Qualified Search returns - default pointType and PointValue.
     Setup - Auto_Attribution_Rest is setup with POP all days 10 PM - 11 PM window

     Given I use test restaurant "<RID>"
     When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "<popFlag>"
     Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
     And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

@Region-NA @incomplete
   Scenarios: search during POP time without passing POPAllow value - verify no POP time returned
   | RID            | search_day_offset | search_time    | p_type1  |  p_value1  | time1 | p_type2  |  p_value2  | time2   | popFlag  |
   | (COM-POP2-RID) | 2                 |  22:00         | Standard |  100       | 22:00 | Standard |  100       | 21:00   |          |

@Region-NA  @incomplete
   Scenarios: search during POP time , passing POPAllow as false - verify no POP time returned
   | RID            | search_day_offset | search_time    | p_type1  |  p_value1  | time1 | p_type2  |  p_value2  | time2   | popFlag  |
   | (COM-POP2-RID) | 2                 |  22:00         | Standard |  100       | 22:00 | Standard |  100       | 21:00   |  false   |

@Region-NA  @incomplete
   Scenarios: search during POP time , passing POPAllow as true - verify POP time returned for POP window
   | RID            | search_day_offset | search_time    | p_type1  |  p_value1  | time1 | p_type2  |  p_value2  | time2   | popFlag  |
   | (COM-POP2-RID) | 2                 |  22:00         | POP      |  1000       | 22:00 | Standard |  100       | 21:00   |  true   |

@Region-NA   @incomplete
   Scenarios: search during POP time [ dinner schedule] , passing POPAllow as true - verify POP time returned for POP window
   | RID            | search_day_offset | search_time    | p_type1  |  p_value1  | time1 | p_type2  |  p_value2  | time2   | popFlag  |
   | (COM-POP2-RID) | 2                 |  21:00         | POP      |  1000       | 22:00 | Standard |  100       | 21:00   |  true   |

@Region-NA  @incomplete
   Scenarios: search during POP time [ Lunch schedule] , passing POPAllow as true - verify POP time returned for POP window
   | RID            | search_day_offset | search_time    | p_type1  |  p_value1    | time1 | p_type2  |  p_value2  | time2   | popFlag  |
   | (COM-POP2-RID) | 2                 |  08:30          | POP      |  1000       | 08:30 | Standard |  100       | 08:45   |  true   |




