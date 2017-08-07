@qa-only
@Avail-Service-integration
@avail-service-POPSuppressPromo
Feature: REST API Search returns - standard points if rest is associated with POP suppressed Promo.

Background:

Scenario Outline: REST API Search returns - standard points if rest is associated with POP suppressed Promo.

     Given I Add test restaurant "<RID>" with a Active POP Suppress Promo "<pid>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
     Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"



@Region-NA
   Scenarios: POP-Suppressed-Active PROMO Suppresses POP to assoiciated RID
   | RID            |  pid | search_day_offset | search_time   | points_1  | slot_time_1 |
   | (COM-POP2-RID) |  840 |  1                 | 22:00        | 100       |  Exact      |


Scenario Outline: REST API Search returns  - POP-Suppressed-Active PROMO does not Suppresses POP to NON assiciated RID

      Given I Remove test restaurant "<RID>" with a Active POP Suppress Promo "<pid>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
      When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
      Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"

@Region-NA
      Scenarios:
      | RID             | pid  |  search_day_offset | search_time  |  points_1 | slot_time_1  |
      | (COM-POP2-RID) |  840 | 1                   |  22:00       |    1000   | Exact        |

Scenario Outline: REST API Search returns  - NON-POP-Suppressed-Active PROMO does not Suppresses POP to assiciated RID

      Given I Add test restaurant "<RID>" with a Active NON POP Suppress Promo "<pid>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
      When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
      Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"


@Region-NA
      Scenarios:
      | RID             | pid  |  search_day_offset | search_time  |  points_1 | slot_time_1  |
      | (COM-POP2-RID) |  840 | 1                   |  22:00       |    1000   | Exact        |


Scenario Outline: REST API Search returns  - POP-Suppressed-Active Promo Expiry check - no POP suppression

      Given I Add test restaurant "<RID>" with a Active POP Suppress Promo "<pid>" that expires in "<no_of_days>" days forward
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
      When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
      Then I verify REST API brings Points "1000" slot "Exact" for restaurant "<RID>"


  @Region-NA
      Scenarios:
      | RID             |  pid  |search_day_offset | multi_days | search_time  | no_of_days  |
      | (COM-POP2-RID)  |  840  | 3                |  7 days    |22:00         |  2          |

#-----  POP points on - promo exclusion dates [ Rule is not implemented /followed]
#Scenario Outline:  REST API Search returns  - POP-Suppressed-Active-Promo - promo exclusion dates - no POP supprssion
#
#      Given I Add test restaurant "<RID>" Active POP Suppress Promo "<pid>" having exclusion date as "<no_of_days>" from today
#      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
#      When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
#      Then I verify REST API brings Points "1000" slot "Exact" for restaurant "<RID>"
#
#@Region-NA
#        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
#        | RID            | pid  |   search_time  | no_of_days  | search_day_offset |
#        | (COM-POP2-RID) |  840 |    22:00       |  4          |     4             |


Scenario Outline:  REST API Search returns- Promo_set_with_POP_suppression_excluded_for_Lunch_only -  does suppresses POP for Dinner time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Lunch Only
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
    When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
    Then I verify REST API brings Points "100" slot "Exact" for restaurant "<RID>"


    @Region-NA
        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
        | RID             |  search_day_offset |  search_time  | pid |
        | (COM-POP2-RID)  |  1                 | 22:00         |  840 |

Scenario Outline:  REST API Search returns - Promo_set_with_POP_suppression_excluded_for_Lunch_only -  does NOT suppresses POP for Lunch time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Lunch Only
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
    When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
    Then I verify REST API brings Points "1000" slot "Exact" for restaurant "<RID>"


    @Region-NA
        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
        | RID             |  search_day_offset |  search_time  | pid |
        | (COM-POP2-RID)  |  1                 | 08:00         |  840 |

Scenario Outline:  REST API Search returns -Promo_set_with_POP_suppression_excluded_for_Dinner_only -  does'not suppresses POP for Dinner time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Dinner Only
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
    When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
    Then I verify REST API brings Points "1000" slot "Exact" for restaurant "<RID>"


    @Region-NA
        Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
        | RID             |  search_day_offset |  search_time  | pid |
        | (COM-POP2-RID)  |  1                 | 22:00         | 840 |

Scenario Outline:  REST API Search returns - Promo_set_with_POP_suppression_excluded_for_Dinner_only -  does suppresses POP for Lunch time

     Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Dinner Only
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I call REST API multi search for metro "4", region "5" ,search day "<search_day_offset>", time "<search_time>", partysize "2"
     Then I verify REST API brings Points "100" slot "Exact" for restaurant "<RID>"


      @Region-NA
          Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
          | RID             |  search_day_offset |  search_time  | pid |
          | (COM-POP2-RID)  |  1                 | 08:00         | 840 |