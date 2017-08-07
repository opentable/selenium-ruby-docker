@Avail-Service-ERB
@avail-service-SameDayCutoff

Feature: Availability Service - Qualified Search returns No availability after same day cutoff time.

Background:


Scenario Outline: search - Qualified Search returns No availability after same day cutoff time.

     Given I setup test rid "<RID>" same day cutoff as PAST local time for dinner shift
     When I call Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API passing searchdate "<no>" days forward, Time "<rtime>"
     Then I verify slot-status returns NoTimesReasons as "<NoAvail_Reason>"

@Region-NA  @incomplete
Scenarios:  cutOff time is 12:00 AM search time 11:45 PM
   | RID                    |  no       | rtime    | NoAvail_Reason    | const_name    | value |
   | (COM-ERB24hr-RID)      |  0        | 23:45    | SameDayCutoff     | SameDayCutoff | 00:00 |

Scenario Outline: search - Qualified Search returns availability before same day cutoff time.

     Given I setup test rid "<RID>" same day cutoff as FUTURE local time for dinner shift
     When I call Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
     Then I verify search brings Availability
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API passing searchdate "<no>" days forward, Time "<rtime>"
     Then I verify slot-status returns empty NoTimesReasons

@Region-NA  @incomplete
   Scenarios:   cutOff time is 11:45 PM search time 11:30
   | RID                    |  no       | rtime    | const_name     | value |
   | (COM-ERB24hr-RID)      |  0        | 23:30    |  SameDayCutoff | 23:45 |


Scenario Outline: search - returns availability for next-day search when same-day cutoff limit exists

    Given I setup test rid "<RID>" same day cutoff as PAST local time for dinner shift
    When I call Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify search brings Availability
    And I verify search brings constrain "<value>" for constrain name "<const_name>"
    When I call Slot-Status API passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify slot-status returns empty NoTimesReasons

  @Region-NA  @incomplete
  Scenarios:
    | RID                     |   no      | rtime    | const_name    |   value |
    | (COM-ERB24hr-RID)       |   1       | 22:00    | SameDayCutoff |         |


Scenario Outline: search - returns availability when no cutoff limit exist

    Given I remove same day cutoff restriction for test rid "<RID>"
    When I call Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify search brings Availability
    And I verify search brings constrain "<value>" for constrain name "<const_name>"
    When I call Slot-Status API passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify slot-status returns empty NoTimesReasons

  @Region-NA  @incomplete
  Scenarios:  same day search for 11:45
    | RID                   |  no      | rtime    | const_name    |   value |
    | (COM-ERB24hr-RID)     |  0       | 23:45    | SameDayCutoff |         |

