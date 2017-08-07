@Avail-Service
@avail-service-BlockedDay


Feature: Perform a search on a BlockedDay - verify AllowNextAvail is true for Console/cached ERB.
Background:

@Avail-Service

Scenario Outline: Perform a search on a BlockedDay - verify AllowNextAvail is true for Console/cached ERB

  Given I block a day for "<numDays>" days from today for test restaurant "<RID>"
  When I call Search API passing searchdate "<numDays>" days forward
  Then I verify search brings AllowNextAvailable as "<value>"

#@Region-NA
#Scenarios: using console RID  (COM-POP2-RID)
#  | RID                | numDays      | value |
#  | (COM-POP2-RID)     | 2            | true  |


@Region-NA
Scenarios: using cached ERB (COM-SIMSearch-RID)
  | RID                  | numDays  | value    |
  | (COM-SIMSearch-RID)  | 2        | true     |








