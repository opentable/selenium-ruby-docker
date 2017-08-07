@Avail-Service

Feature: Perform a multi rid search using ERB and console [ non cached PS]
Background:


Scenario Outline: Call Qualified Search [ Console + ERB] for PS = 1

  Given call Search API using Rids "<rid_list>" and PartySize "<ps>"
  Then I verify search brings AllowNextAvailable as "true" for rid "<RID1>"
  And I verify search brings AllowNextAvailable as "false" for rid "<RID2>"

@Region-NA
Scenarios: using console RID  (COM-POP2-RID)
  | RID1               |   RID2               |  ps | rid_list   |
  | (COM-POP2-RID)     |  (COM-SIMSearch-RID) |  1  |  (COM-POP2-RID),(COM-SIMSearch-RID) |











