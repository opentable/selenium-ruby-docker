@Avail-Service-logging
Feature:

Background: SearchLogging - Total Search request counts

Scenario Outline: SearchLogging - Total Search request counts

     Given I call flushlogger API then capture high watermark
     When I call search API "<i>" times using single rid "<RID1>"
     And I call multi search API "<j>" times using rid_list "<rid_list>"
     And I call flushlogger
     Then I verify "<k>" total search requests are logged
     And I verify "<i>" single searches are logged for RID "<RID1>"
     And I verify "<j>" multi searches are logged for RID "<RID1>"
     And I verify "<j>" multi searches are logged for RID "<RID2>"

@Region-NA
   Scenarios: total search requests are counted in log
     | RID1           | RID2                  | rid_list                           |   i | j  | k |
     | (COM-POP2-RID) | (COM-SIMSearch2-RID)  |  (COM-POP2-RID),(COM-SIMSearch2-RID) |   3 | 5  | 8 |












