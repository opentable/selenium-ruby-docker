@qa-only
@Avail-Service-integration
@avail-service-BlockedDay

Feature:  Consumer Search - Blocked Day Rule

Background:
  And I start with a new browser

Scenario Outline: Consumer Search Search - Blocked Day Rule - No Availability on blocked day.

  Given I block a day for "<numDays>" days from today for test restaurant "<RID>"
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantBlockedDayMessages;CacheRestaurantCCBlockedDayMessages" item
  When I perform Consumer search using searchdate "<numDays>" days forward
  Then I verify Consumer site search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"



@Region-NA
Scenarios: search with blocked day
  | RID                     | numDays      | no_time_message                         |   rname  |
  | (COM-SIMSearch-RID)     | 2            | Online reservations are not available   | (COM-SIMSearch-Name) |


Scenario Outline: Consumer Search using search day as NONblocked day - returns availability.

  Given I unblock all block days for test restaurant "<RID>"
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantBlockedDayMessages;CacheRestaurantCCBlockedDayMessages" item
  When I perform Consumer search using searchdate "<numDays>" days forward
  Then I verify Consumer site search brings Availability

@Region-NA
Scenarios:
| RID                     | numDays |
| (COM-SIMSearch-RID)     | 2       |







