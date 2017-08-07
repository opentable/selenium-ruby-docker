@Avail-Service-points
@avail-service-POPSuppressPromo
Feature: Availability Service - Qualified Search returns - standard points if rest is associated with POP suppressed Promo.

Background:

Scenario Outline: setup :
        1. Test promo PID - 991 - suppresses POP
        2. TEST RID (COM-POP2-Name) has active POP schedule for 10 to 11 PM
        3. Link Active Promo [ POP suppressed] to test RID

     Given I Add test restaurant "<RID>" with a Active POP Suppress Promo "<pid>"
     When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "<popFlag>"
     Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"


@Region-NA @incomplete
   Scenarios: POP-Suppressed-Active PROMO Suppresses POP to assoiciated RID
   | RID            |  pid | search_day_offset | search_time   | p_type1        |  p_value1  | time1 | popFlag |
   | (COM-POP2-RID) |  561 |  1                 | 22:00        | Standard       |  100       | 22:00 |  true   |


Scenario Outline: POP-Suppressed-Active PROMO does not Suppresses POP to NON assiciated RID

      Given I Remove test restaurant "<RID>" with a Active POP Suppress Promo "<pid>"
      When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "<popFlag>"
      Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
      And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"

@Region-NA @incomplete
      Scenarios:
      | RID             | pid  |  search_day_offset | search_time  | p_type1   |  p_value1 | time1  | p_type2   |  p_value2 | time2   | popFlag |
      | (COM-POP2-RID) |  561 | 1                   |  22:00       |  POP      |  1000     | 22:00  | Standard  |  100      | 21:00   | true    |


Scenario Outline: NON-POP-Suppressed-Active PROMO does not Suppresses POP to assiciated RID

      Given I Add test restaurant "<RID>" with a Active NON POP Suppress Promo "<pid>"
      When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
      Then I verify PointsType "<p_type1>", PointsValue "<p_value1>" for time slot "<time1>"
      And  I verify PointsType "<p_type2>", PointsValue "<p_value2>" for time slot "<time2>"


  @Region-NA  @incomplete
      Scenarios:
      | RID             | pid  |  search_day_offset | search_time  | p_type1   |  p_value1 | time1  | p_type2   |  p_value2 | time2   |
      | (COM-POP2-RID)  |  561 |1                   |  22:00       |  POP      |  1000     | 22:00  | Standard  |  100      | 21:00   |


Scenario Outline: POP-Suppressed-Active Promo suppressed POP only during active period

      Given I Add test restaurant "<RID>" with a Active POP Suppress Promo "<pid>" that expires in "<no_of_days>" days forward
      When I call Search API passing searchdate "<search_day_offset>" days forward, search_days "<multi_days>", search time "<search_time>"
      Then I verify search brings No POP time for next "<no_of_days>" days and shows POP times after that for search time "<search_time>"


  @Region-NA @incomplete
      Scenarios:
      | RID             |  pid  |search_day_offset | multi_days | search_time  | no_of_days  |
      | (COM-POP2-RID)  | 561  | 0                |  7 days    |22:00         |  2          |


#Scenario Outline:  POP-Suppressed-Active-Promo suppressed POP only during active days not on promo exclusion dates
#
#      Given I Add test restaurant "<RID>" Active POP Suppress Promo "<pid>" having exclusion date as "<no_of_days>" from today
#      When I call Search API passing searchdate "<no_of_days>" days forward, search_days "<multi_days>", search time "<search_time>"
#      Then I verify search brings POP time on exclusion date but NON POP all other days for search time "<search_time>"
#
#@Region-NA
#        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
#        | RID            | pid  |  multi_days | search_time  | no_of_days  |
#        | (COM-POP2-RID) |  840 |  7 days     |  22:00       |  4          |


Scenario Outline:  Promo_set_with_POP_suppression_excluded_for_Lunch_only -  does suppresses POP for Dinner time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Lunch Only
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "Standard", PointsValue "100" for time slot "<search_time>"

    @Region-NA @incomplete
        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
        | RID             |  search_day_offset |  search_time  | pid |
        | (COM-POP2-RID)  |  1                 | 22:00         |  561 |

Scenario Outline:  Promo_set_with_POP_suppression_excluded_for_Lunch_only -  does NOT suppresses POP for Lunch time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Lunch Only
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "POP", PointsValue "1000" for time slot "<search_time>"

    @Region-NA @incomplete
        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
        | RID             |  search_day_offset |  search_time  | pid |
        | (COM-POP2-RID)  |  1                 | 08:00         |  561 |

Scenario Outline:  Promo_set_with_POP_suppression_excluded_for_Dinner_only -  does'not suppresses POP for Dinner time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Dinner Only
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "POP", PointsValue "1000" for time slot "<search_time>"

    @Region-NA @incomplete
        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
        | RID             |  search_day_offset |  search_time  | pid |
        | (COM-POP2-RID)  |  1                 | 22:00         | 561 |

Scenario Outline:  Promo_set_with_POP_suppression_excluded_for_Dinner_only -  does suppresses POP for Lunch time

      Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Dinner Only
      When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
      Then I verify PointsType "Standard", PointsValue "100" for time slot "<search_time>"

      @Region-NA  @incomplete
          Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
          | RID             |  search_day_offset |  search_time  | pid |
          | (COM-POP2-RID)  |  1                 | 08:00         | 561 |

Scenario Outline:  Lunch/Dinner promo with POP suppression on restaurant where promo enabled for dinner -  does suppress POP for dinner time
    Given I Add test restaurant "<RID>" to an Active Lunch-Dinner POP Suppress Promo "<pid>" with promo Disabled for lunch and Enabled for dinner
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "Standard", PointsValue "100" for time slot "<search_time>"

  @Region-NA  @incomplete
  Scenarios:   dinner bit on enables Lunch/Dinner promo
    | RID             |  search_day_offset |  search_time  | pid |
    | (COM-POP2-RID)  |  1                 | 22:00         | 561 |

Scenario Outline:  Lunch/Dinner promo with POP suppression on restaurant where promo disabled for dinner -  does not suppress POP for dinner time
    Given I Add test restaurant "<RID>" to an Active Lunch-Dinner POP Suppress Promo "<pid>" with promo Disabled for lunch and Disabled for dinner
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "POP", PointsValue "1000" for time slot "<search_time>"

  @Region-NA  @incomplete
  Scenarios:  dinner bit off disables Lunch/Dinner promo
    | RID             |  search_day_offset |  search_time  | pid |
    | (COM-POP2-RID)  |  1                 | 22:00         | 561 |

Scenario Outline:  NON Lunch/Dinner promo with POP suppression on restaurant where promo disabled for dinner -  does suppress POP for dinner time
    Given I Add test restaurant "<RID>" to an Active NON Lunch-Dinner POP Suppress Promo "<pid>" with promo Disabled for lunch and Disabled for dinner
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "Standard", PointsValue "100" for time slot "<search_time>"

  @Region-NA  @incomplete
  Scenarios: dinner bit is ignored for non-Lunch/Dinner promo
    | RID             |  search_day_offset |  search_time  | pid |
    | (COM-POP2-RID)  |  1                 | 22:00         | 561 |



  Scenario Outline:  Lunch/Dinner promo with POP suppression on restaurant where promo enabled for lunch -  does suppress POP for lunch time
    Given I Add test restaurant "<RID>" to an Active Lunch-Dinner POP Suppress Promo "<pid>" with promo Enabled for lunch and Disabled for dinner
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "Standard", PointsValue "100" for time slot "<search_time>"

  @Region-NA
  Scenarios:   lunch bit on enables Lunch/Dinner promo
    | RID             |  search_day_offset |  search_time  | pid |
    | (COM-POP2-RID)  |  1                 | 08:00         | 561 |

  Scenario Outline:  Lunch/Dinner promo with POP suppression on restaurant where promo disabled for lunch -  does not suppress POP for lunch time
    Given I Add test restaurant "<RID>" to an Active Lunch-Dinner POP Suppress Promo "<pid>" with promo Disabled for lunch and Disabled for dinner
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "POP", PointsValue "1000" for time slot "<search_time>"

  @Region-NA
  Scenarios:  lunch bit off disables Lunch/Dinner promo
    | RID             |  search_day_offset |  search_time  | pid |
    | (COM-POP2-RID)  |  1                 | 08:00         | 561 |

  Scenario Outline:  NON Lunch/Dinner promo with POP suppression on restaurant where promo disabled for lunch -  does suppress POP for lunch time
    Given I Add test restaurant "<RID>" to an Active NON Lunch-Dinner POP Suppress Promo "<pid>" with promo Disabled for lunch and Disabled for dinner
    When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
    Then I verify PointsType "Standard", PointsValue "100" for time slot "<search_time>"

  @Region-NA
  Scenarios: dinner bit is ignored for non-Lunch/Dinner promo
    | RID             |  search_day_offset |  search_time  | pid |
    | (COM-POP2-RID)  |  1                 | 08:00         | 561 |

