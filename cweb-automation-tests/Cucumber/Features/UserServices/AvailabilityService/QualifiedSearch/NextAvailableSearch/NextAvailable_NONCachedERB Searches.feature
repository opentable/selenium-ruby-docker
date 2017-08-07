@Avail-Service


Feature: Perform Direct ERB Search ( using NON Cached PS)  and verify AllowNextAvail is false.
Background:


Scenario Outline: Perform Direct ERB Search and verify AllowNextAvail is false.

      Given I use test restaurant "<RID>"
      When I call Search API using PS "<ps>"
      Then I verify search brings AllowNextAvailable as "<value>"

@Region-NA
Scenarios: using ERB
  | RID                     | ps     | value |
  | (COM-SIMSearch-RID)     | 1      | false |

@Region-NA
Scenarios: using ERB
  | RID                     | ps     | value |
  | (COM-SIMSearch-RID)     | 11      | false |


#Scenario Outline: Perform Direct ERB Search (ERB NOT cached)  and verify AllowNextAvail is false.
#         1. TEST ERB - NOT cached , Rest Status - Active, Isreachable = 1
#         2. perform a PS = 2 search on a blocked Day --- verify  AllowNextAvail = false
#         OR
#         2. turn off the Listener and do PS = 2 search --- verify  AllowNextAvail = false





