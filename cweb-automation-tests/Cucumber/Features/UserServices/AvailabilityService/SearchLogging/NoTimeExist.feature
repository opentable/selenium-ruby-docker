@Avail-Service-ERB
Feature: Search returns no availability as NoInventory Exist.

Background:


Scenario Outline: Search returns no availability as NoInventory Exist.

     Given I call flushlogger API then capture high watermark
     When I call search API using single rid "<RID>" for party size "<ps>"
     And I call flushlogger
     Then I verify Status_NoAvailability  "<v1>" is logged for RID "<RID>"
     And I verify Status_TimesAvailable "<v2>" is logged for RID "<RID>"
     And I verify Status_BlockedSlots30MinutesWindow "<v3>" is logged for RID "<RID>"
     And I verify Status_Available30MinuteWindow "<v4>" is logged for RID "<RID>"

@Region-NA
   Scenarios: search with no availability at this PS
     | RID               |  ps  |   v1  | v2 | v3 | v4 |
     | (COM-ERB24hr-RID) |  5   |   1   | 0  | 0  | 0  |














