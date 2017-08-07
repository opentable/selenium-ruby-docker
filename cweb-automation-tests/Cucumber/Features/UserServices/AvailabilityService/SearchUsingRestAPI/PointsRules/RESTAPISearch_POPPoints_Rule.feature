@qa-only
@Avail-Service-integration
Feature: RESTAPI Search - returns - default POP POINTS for searches falling in POP schedule.

Background:

Scenario Outline: RESTAPI Search - returns - default POP POINTS for searches falling in POP schedule.

     Given I use test restaurant "<RID>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I call REST API multi search for metro "<mid>", region "<region_id>" ,search day "<days_fwd>", time "<s_time>", partysize "<ps>"
     Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"
     And I verify REST API brings Points "<points_2>" slot "<slot_time_2>" for restaurant "<RID>"

@Region-NA
   Scenarios: search during POP time , passing POPAllow as true - verify POP time returned for POP window
   | RID            | mid |region_id | days_fwd | s_time  | ps | slot_time_1 | points_1 |  slot_time_2 | points_2 |
   | (COM-POP2-RID) | 4   | 5        | 2        |  22:00  | 2  |  Exact      | 1000     |  Early       | 100      |


  Scenario Outline: RESTAPI Search - returns - default POP POINTS for searches falling in POP schedule.

       Given I use test restaurant "<RID>"
       When I call REST API multi search for metro "<mid>", region "<region_id>" ,search day "<days_fwd>", time "<s_time>", partysize "<ps>"
       Then I verify REST API brings Points "<points_1>" slot "<slot_time_1>" for restaurant "<RID>"
       And I verify REST API brings Points "<points_2>" slot "<slot_time_2>" for restaurant "<RID>"


@Region-NA
   Scenarios: search during POP time , passing POPAllow as true - verify POP time returned for POP window
   | RID            | mid |region_id | days_fwd | s_time   | ps | slot_time_1 | points_1 |  slot_time_2 | points_2 |
   | (COM-POP2-RID) | 4   | 5        | 2        |  21:45   | 2  |  Exact      | 100      |  Later       | 1000     |

@Region-NA
   Scenarios: search during POP time , passing POPAllow as true - verify POP time returned for POP window
   | RID            | mid |region_id | days_fwd | s_time   | ps | slot_time_1 | points_1 |  slot_time_2 | points_2 |
   | (COM-POP2-RID) | 4   | 5        | 2        |  08:30   | 2  |  Exact      | 1000     |  Later       | 100     |





