@qa-only
@Avail-Service-integration
Feature: Consumer Search - returns - POP POINTS for searches falling in POP schedule.

Background:
       And I start with a new browser


Scenario Outline: User performs metro search then single search search time within POP Schedule

     Given I use test restaurant "<RID>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantIncentiveSuppressionDates;CacheDipRestaurantList;CachePromoRestaurantList;CachePromoRulesList;CachePromoDIPSupressionExclusionList" item
     When I perform metro search then single search for restaurant "<RID>" date "<days_fwd>" time "<s_time>" partysize "<ps>"
     Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"
     Then I verify Consumer site returns "<points_2>" points for time slot "<slot_time_2>"

@Region-NA
   Scenarios: search during POP time window
   | RID            |  days_fwd | s_time     | ps | slot_time_1 | points_1 |  slot_time_2 | points_2 |
   | (COM-POP2-RID) |  2        |  10:00 PM  | 2  |  10:00 PM      | 1000  |  9:45        | 100       |

@Region-NA
   Scenarios: search during POP time window
   | RID            |  days_fwd | s_time    | ps | slot_time_1 | points_1 |  slot_time_2 | points_2 |
   | (COM-POP2-RID) |  2        |  9:30 PM  | 2  |  10:00      | 1000    |  9:45        | 100      |


Scenario Outline: User single search time falls within POP Schedule [ no dip Cookie set] - no POP points expected

      Given I use test restaurant "<RID>"
      When I perform consumer site search for restaurant "<RID>" date "<search_days_offset>" time "<stime>" partysize "2"
      Then I verify Consumer site returns "<points_1>" points for time slot "<slot_time_1>"

 @Region-NA
    Scenarios: search during POP time window
    | RID            |  search_days_offset | stime     |  slot_time_1    | points_1 |
    | (COM-POP2-RID) |  2                  |  10:00 PM |   10:00 PM      | 100      |







