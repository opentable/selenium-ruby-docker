@qa-only
@Avail-Service-integration
@avail-service-BlockedDay

Feature:  REST API Search - Blocked Day Rule

Background:

Scenario Outline: REST API Search - Blocked Day Rule - No Availability on blocked day.

  Given I block a day for "<numDays>" days from today for test restaurant "<RID>"
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantBlockedDayMessages;CacheRestaurantCCBlockedDayMessages" item
  When I perform REST API search using searchdate "<numDays>" days forward
  Then I verify REST API search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"


@Region-NA
Scenarios: search with blocked day
  | RID                     | numDays      | no_time_message  |   rname  |
  | (COM-SIMSearch-RID)     | 2            | Online reservations are not available   | (COM-SIMSearch-Name) |



Scenario Outline: Qualified search using search day as NONblocked day - returns availability.

  Given I unblock all block days for test restaurant "<RID>"
  And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;CacheRestaurantBlockedDayMessages;CacheRestaurantCCBlockedDayMessages" item
  When I perform REST API search using searchdate "<numDays>" days forward
  Then I verify REST API search brings Availability

@Region-NA
Scenarios:
| RID                     | numDays |
| (COM-SIMSearch-RID)     | 2       |







