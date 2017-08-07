@qa-only
@Avail-Service-integration
@avail-service-POPSuppressPromo

Feature: Consumer Search returns - standard points if rest is associated with POP suppressed Promo.

Background:
    And I start with a new browser
Scenario Outline: Consumer Search returns - standard points if rest is associated with POP suppressed Promo.

     Given I Add test restaurant "<RID>" with a Active POP Suppress Promo "<pid>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
   Scenarios: POP-Suppressed-Active PROMO Suppresses POP to assoiciated RID
   | RID            |  pid | search_day_offset | search_time   | points_1  | slot_time_1 |
   | (COM-POP2-RID) |  840 |  1                | 10:00 PM     | 100       |  10:00 PM      |


Scenario Outline: Consumer Search returns  - POP-Suppressed-Active PROMO does not Suppresses POP to NON assiciated RID

      Given I Remove test restaurant "<RID>" with a Active POP Suppress Promo "<pid>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
      When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
      Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
      Scenarios:
      | RID             | pid  |  search_day_offset | search_time  |  points_1 | slot_time_1  |
      | (COM-POP2-RID)  |  840 | 1                   | 10:00 PM     | 1000       |  10:00 PM      |

Scenario Outline: Consumer Search  - NON-POP-Suppressed-Active PROMO does not Suppresses POP to assiciated RID

      Given I Add test restaurant "<RID>" with a Active NON POP Suppress Promo "<pid>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
      When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
      Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
      Scenarios:
      | RID             | pid  |  search_day_offset | search_time  |  points_1 | slot_time_1  |
      | (COM-POP2-RID) |  840  | 1                  | 10:00 PM     | 1000       |  10:00 PM      |

Scenario Outline: Consumer Search returns  - POP-Suppressed-Active Promo Expiry check - no POP suppression

      Given I Add test restaurant "<RID>" with a Active POP Suppress Promo "<pid>" that expires in "<no_of_days>" days forward
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
       When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
      Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

@Region-NA
      Scenarios:
      | RID             |  pid  |search_day_offset |  search_time  | no_of_days  | points_1 |  slot_time_1 |
      | (COM-POP2-RID)  |  840  | 3                |  10:00 PM     |  2          |  1000    | 10:00 PM     |
#-----  POP points on - promo exclusion dates [ Rule is not implemented /followed]
#Scenario Outline:  Consumer Search  - POP-Suppressed-Active-Promo - promo exclusion dates means no POP supprssion
#
#      Given I Add test restaurant "<RID>" Active POP Suppress Promo "<pid>" having exclusion date as "<no_of_days>" from today
#      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
#      When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
#      Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"
#
#@Region-NA
#      Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
#      | RID            | pid  |   search_time  | no_of_days  | search_day_offset | points_1 | slot_time_1 |
#      | (COM-POP2-RID) |  840 |    10:00 PM    |  4          |     4             |  1000    | 10:00 PM    |
#

Scenario Outline:  Consumer Search returns- Promo_set_with_POP_suppression_excluded_for_Lunch_only
           -  does suppresses POP for Dinner time but not for Lunch

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Lunch Only
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
    Then I verify Consumer site returns "100" points for time slot "10:00 PM"

@Region-NA
      Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
      | RID             |  search_day_offset |  search_time  | pid |
      | (COM-POP2-RID)  |  1                 |  10:00 PM     |  840 |

Scenario Outline:  Consumer Search returns - Promo_set_with_POP_suppression_excluded_for_Lunch_only -  does NOT suppresses POP for Lunch time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Lunch Only
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item

    When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
    Then I verify Consumer site returns "1000" points for time slot "8:00 AM"

@Region-NA
      Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
      | RID             |  search_day_offset |  search_time  | pid |
      | (COM-POP2-RID)  |  1                 |  8:00 AM      |  840 |

Scenario Outline:  Consumer Search returns -Promo_set_with_POP_suppression_excluded_for_Dinner_only -  does'not suppresses POP for Dinner time

    Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Dinner Only
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
   When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
    Then I verify Consumer site returns "1000" points for time slot "10:00 PM"

@Region-NA
      Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
      | RID             |  search_day_offset |  search_time  | pid |
      | (COM-POP2-RID)  |  1                 | 10:00 PM      | 840 |

Scenario Outline:  Consumer Search returns - Promo_set_with_POP_suppression_excluded_for_Dinner_only -  does suppresses POP for Lunch time

     Given I Add test restaurant "<RID>" to a Active POP suppress Promo pid "<pid>" having POP suppression excluded For Dinner Only
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "100" points for time slot "8:00 AM"

@Region-NA
      Scenarios: POP-Suppressed-Active Promo suppressed POP only during active period
      | RID             |  search_day_offset |  search_time  | pid |
      | (COM-POP2-RID)  |  1                 |   8:00 AM         | 840 |