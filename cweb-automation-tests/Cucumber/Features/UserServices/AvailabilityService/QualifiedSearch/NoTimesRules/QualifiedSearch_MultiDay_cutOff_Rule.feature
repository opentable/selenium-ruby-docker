@Avail-Service
@avail-service-MultiDayCutoff

Feature: Availability Service - Qualified Search returns No availability after for a day that falls within cutoffday limits.

Background:

@Avail-Service

Scenario Outline: search - Qualified Search returns No availability when search day falls withing Earlydays cutoff limits

     Given I setup test rid "<RID>" days cutoff limit "<cut_offdays_no>" days
     When I call Search API passing searchdate "<numDays>" days forward
     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API passing searchdate "<numDays>" days forward
     Then I verify slot-status returns NoTimesReasons as "<NoAvail_Reason>"

@Region-NA @incomplete
   Scenarios: search with search date > advance booking limit
   | RID                      | cut_offdays_no     | numDays  | NoAvail_Reason    | const_name  | value |
   | (COM-SIMSearch-RID)      | 5                  | 4        | EarlyCutoff       | EarlyCutoff |  5    |


Scenario Outline: search - returns availability when search day falls out of Earlydays cutoff limits

  Given I setup test rid "<RID>" days cutoff limit "<cut_offdays_no>" days
  When I call Search API passing searchdate "<numDays>" days forward
  Then I verify search brings Availability
  And I verify search brings constrain "<value>" for constrain name "<const_name>"
  When I call Slot-Status API passing searchdate "<numDays>" days forward
  Then I verify slot-status returns empty NoTimesReasons

@Region-NA  @incomplete
Scenarios: search with search date > advance booking limit
  | RID                      | cut_offdays_no     | numDays  |  const_name  | value |
  | (COM-SIMSearch-RID)      | 5                  | 6        |  EarlyCutoff |  5    |

Scenario Outline: search - returns availability when search day coincides with Earlydays cutoff limits

    Given I setup test rid "<RID>" days cutoff limit "<cut_offdays_no>" days
    When I call Search API passing searchdate "<numDays>" days forward
    Then I verify search brings Availability
    And I verify search brings constrain "<value>" for constrain name "<const_name>"
    When I call Slot-Status API passing searchdate "<numDays>" days forward
    Then I verify slot-status returns empty NoTimesReasons

@Region-NA  @incomplete
Scenarios: search with search date = advance booking limit
    | RID                      | cut_offdays_no     | numDays  |  const_name  | value |
    | (COM-SIMSearch-RID)      | 5                  | 5        |  EarlyCutoff |  5    |

@Region-NA @incomplete
Scenarios: search with search date = advance booking limit
    | RID                      | cut_offdays_no     | numDays  |  const_name  | value |
    | (COM-SIMSearch-RID)      | 0                  | 5        |  EarlyCutoff |  0    |
