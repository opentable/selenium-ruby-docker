@Avail-Service
@avail-service-AdvanceBooking

Feature: Availability Service - Qualified Search returns No availability for search beyond AdvanceBooking limit.

Background:

@Avail-Service

Scenario Outline: search - returns No availability and Reason "TooFarInAdvance" for search beyond AdvanceBooking limit.

     Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
     When I call Search API passing searchdate "<numDays>" days forward
     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API passing searchdate "<numDays>" days forward
     Then I verify slot-status returns NoTimesReasons as "<NoAvail_Reason>"

@Region-NA  @Search_maxPS  @incomplete
   Scenarios: search with search date > advance booking limit (Note: max_advance_option_id = 10 translates to a 14 day limit)
   | RID                      | max_advance_option_id | numDays | NoAvail_Reason    |   const_name     | value |
   | (COM-SIMSearch-RID)      | 10                    | 20      | TooFarInAdvance   | MaxDaysInAdvance |  14   |


Scenario Outline: search - returns availability for search under AdvanceBooking limit.

  Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
  When I call Search API passing searchdate "<numDays>" days forward
  Then I verify search brings Availability
  And I verify search brings constrain "<value>" for constrain name "<const_name>"
  When I call Slot-Status API passing searchdate "<numDays>" days forward
  Then I verify slot-status returns empty NoTimesReasons

@Region-NA  @Search_maxPS  @incomplete
Scenarios: search with search date < advance booking limit
| RID                     | max_advance_option_id | numDays |  const_name     | value |
| (COM-SIMSearch-RID)     | 10                    | 8       |  MaxDaysInAdvance |  14   |
