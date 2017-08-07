@qa-only
@Avail-Service-integration
@avail-service-AdvanceBooking

Feature: REST API Search returns No availability for search beyond AdvanceBooking limit.

Background:

Scenario Outline: REST API Search returns No availability for search beyond AdvanceBooking limit.

     Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
     When I perform REST API search using searchdate "<numDays>" days forward
     Then I verify REST API search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"


@Region-NA  @Search_maxPS
   Scenarios: search with search date > advance booking limit (Note: max_advance_option_id = 10 translates to a 14 day limit)
   | RID                   | max_advance_option_id | numDays | no_time_message                      | rname   |
   | (COM-SIMSearch-RID)   | 10                    | 20      | maximum advance reservation limit    |  (COM-SIMSearch-Name) |


Scenario Outline: REST API Search - returns availability for search under AdvanceBooking limit.

  Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
  When I perform REST API search using searchdate "<numDays>" days forward
  Then I verify REST API search brings Availability

@Region-NA  @Search_maxPS
Scenarios: REST API Search with search date < advance booking limit
| RID                     | max_advance_option_id | numDays |
| (COM-SIMSearch-RID)     | 10                    | 8       |
