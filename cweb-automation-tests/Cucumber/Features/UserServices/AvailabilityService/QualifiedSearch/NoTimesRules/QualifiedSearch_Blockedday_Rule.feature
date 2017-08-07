@Avail-Service
@avail-service-BlockedDay

Feature: Availability Service - Qualified Search returns No availability for a Blocked day.

Background:

@Avail-Service

Scenario Outline: search - single day [blocked day] - returns No availability and Reason "BlockedDay"

  Given I block a day for "<numDays>" days from today for test restaurant "<RID>"
  When I call Search API passing searchdate "<numDays>" days forward
  Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
  When I call Slot-Status API passing searchdate "<numDays>" days forward
  Then I verify slot-status returns NoTimesReasons as "<NoAvail_Reason>"

@Region-NA @incomplete
Scenarios: search with blocked day
  | RID                     | numDays      | NoAvail_Reason    |
  | (COM-SIMSearch-RID)     | 2            | BlockedDay        |


Scenario Outline: search - multi day [blocked day falls in beginning of search window]  - returns  noAvail on blocked day and returns availability on All other days.

  Given I block a day for "<numDays>" days from today for test restaurant "<RID>"
  When I call Search API passing searchdate "<numDays>" days forward, search_days "<multi_days>"
  Then I verify search brings No Availability on first day but brings availability all other days

@Region-NA @incomplete
Scenarios: search multi day with blocked day as day 0
  | RID                     | numDays | multi_days |
  | (COM-SIMSearch-RID)     | 2       | 7 days    |


  Scenario Outline: search - multi day [blocked day falls in middle of search window]  - returns  noAvail on blocked day and returns availability on All other days.

  Given I block a day for "<blockedStart>" days from today for test restaurant "<RID>"
  When I call Search API passing searchdate "<searchStart>" days forward, search_days "<forwardDays>"
  Then I verify search brings No Availability on blocked day "<blockedStart>" relative to start day "<searchStart>" but brings availability all other days

  @Region-NA  @incomplete
  Scenarios: search multi day with blocked day as day 0
    | RID                     | searchStart | forwardDays | blockedStart |
    | (COM-SIMSearch-RID)     | 2           | 7 days      |  4           |


Scenario Outline: Qualified search using search day as NONblocked day - returns availability.

  Given I unblock all block days for test restaurant "<RID>"
  When I call Search API passing searchdate "<numDays>" days forward
  Then I verify search brings Availability
  When I call Slot-Status API passing searchdate "<numDays>" days forward
  Then I verify slot-status returns empty NoTimesReasons

@Region-NA @incomplete
Scenarios: search with PS > MaxPS limit
| RID                     | numDays |
| (COM-SIMSearch-RID)     | 2       |







