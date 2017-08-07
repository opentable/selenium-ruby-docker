@Avail-Service-points
@avail-service-POPSuppressHoliday

Feature: Availability Service - Qualified Search returns - standard points if search is done on POP suppressed Holiday

  Background:

  Scenario Outline: Availability Service - Qualified Search returns - default pointType and PointValue if search is done on POP suppressed Holiday
  Setup - Auto_Attribution_Rest is setup with POP all days 10 PM - 11 PM window


    Given I Add a POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
    When I call search API on suppress holiday date for time "<search_time>", with AllowPop bit "true"
    Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
    And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

  @Region-NA @incomplete
  Scenarios: perform search using search day = POPSuppressed Holiday date and time = POP Time
    | RID            | day_offset | search_time | p_type1  | p_value1 | time1 | p_type2  | p_value2 | time2 |
    | (COM-POP2-RID) | 16         | 22:00       | Standard | 100      | 22:00 | Standard | 100      | 21:00 |


  Scenario Outline: Availability Service - Qualified Search returns - default pointType and PointValue if search is done on POP suppressed Holiday
  Setup - Auto_Attribution_Rest is setup with POP all days 10 PM - 11 PM window


    Given I Add a POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
    When I call search API on non holiday date for time "<search_time>", with AllowPop bit "true"
    Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
    And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

  @Region-NA @incomplete
  Scenarios: perform search using search day !=POPSuppressed Holiday date and time = POP Time
    | RID            | day_offset | search_time | p_type1 | p_value1 | time1 | p_type2  | p_value2 | time2 |
    | (COM-POP2-RID) | 16         | 22:00       | POP     | 1000     | 22:00 | Standard | 100      | 21:00 |


  Scenario Outline: remove POP suppressed Holiday day and check POP time appears

    Given I Add a POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
    And I Remove POP Suppress holiday for date "<day_offset>" days from today for Test restaurant "<RID>"
    When I call search API on suppress holiday date for time "<search_time>", with AllowPop bit "true"
    Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
    And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

  #
  @Region-NA @incomplete
  Scenarios: perform search using search day != Suppressed date and time = POP Time
    | RID            | day_offset |  search_time | p_type1 | p_value1 | time1 | p_type2  | p_value2 | time2 |
    | (COM-POP2-RID) | 16         |  22:00       | POP     | 1000     | 22:00 | Standard | 100      | 21:00 |





