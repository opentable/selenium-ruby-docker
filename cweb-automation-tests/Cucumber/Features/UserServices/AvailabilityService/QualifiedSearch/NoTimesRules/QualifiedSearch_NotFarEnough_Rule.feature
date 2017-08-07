@Avail-Service-ERB
Feature: Availability Service - Qualified Search returns No availability for search within time limit NotFarEnoughInAdvance

Background:



Scenario Outline: search - returns availability for search time more than 5 min [local rest time ]

    Given I setup test restaurant "<RID>"
    When I call search API using search day "<searchStartDayOffset>" days from today, search time "<searchTimeOffsetMinutes>" minutes from now
    Then I verify search brings Availability

@Region-NA @incomplete
  Scenarios: search within Next 5 min time - should return no availability
  | RID                     | searchStartDayOffset   | searchTimeOffsetMinutes  |
  | (COM-ERB24hr-RID)       |                    0   |                       6  |

#----------  COMMENTING THIS CASE AS TIME CLIPPING LOGIC CHANGES THE SEARCH TIME to 15 min intervals and CAN"T TEST THIS Scenario --
#---------   CASE IS COVERED in UNIT TEST ----
#Scenario Outline: search - returns No availability for search time less than 5 min from [local rest time ]
#     Given I setup test restaurant "<RID>"
#     When I call search API using search day "<searchStartDayOffset>" days from today, search time "<searchTimeOffsetMinutes>" minutes from now
#     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
#
#
#@Region-NA
#   Scenarios: search within Next 5 min time - should return no availability
#   | RID                     | searchStartDayOffset | searchTimeOffsetMinutes    | NoAvail_Reason  |
#   | (COM-SIMSearch-RID)     |                    0 |                       2    | NotFarEnoughInAdvance |




