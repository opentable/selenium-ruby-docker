@qa-only
@Avail-Service-integration
@avail-service-AdvanceBooking

Feature: Consumer Search returns No availability for search beyond AdvanceBooking limit.

Background:
  And I start with a new browser

Scenario Outline: Consumer Search returns No availability for search beyond AdvanceBooking limit.

     Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantCCBlockedDayMessages" item
     When I perform Consumer search using searchdate "<numDays>" days forward
     Then I verify Consumer site search brings NoAvailability Reason as "<text>" for restaurant "<rname>"



@Region-NA  @Search_maxPS
   Scenarios: search with search date > advance booking limit (Note: max_advance_option_id = 10 translates to a 14 day limit)
   | RID                   | max_advance_option_id | numDays | text                                 | rname   |
   | (COM-SIMSearch-RID)   | 10                    | 20      | maximum advance reservation limit    |  (COM-SIMSearch-Name) |


Scenario Outline: Consumer Search - returns availability for search under AdvanceBooking limit.

  Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
  When I perform Consumer search using searchdate "<numDays>" days forward
  Then I verify Consumer site search brings Availability

@Region-NA  @Search_maxPS
Scenarios: REST API Search with search date < advance booking limit
| RID                     | max_advance_option_id | numDays |
| (COM-SIMSearch-RID)     | 10                    | 8       |
