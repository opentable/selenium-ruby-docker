@Avail-Service-logging
Feature:

Background: SearchLogging - multi Search


Scenario Outline: SearchLogging - multi Search

     Given I call flushlogger API then capture high watermark
     When I call multi search API using rid_list "<rid_list>"
     And I call flushlogger
     Then I verify search stats are logged for RID "<RID1>" and searchType is logged as "<searchType>"
     And I verify search stats are logged for RID "<RID2>" and searchType is logged as "<searchType>"

@Region-NA
   Scenarios: search is logged as MultiSearch (Type - 2)
     | RID1               |   RID2               | rid_list                            |   searchType |
     | (COM-POP2-RID)     |  (COM-SIMSearch2-RID) |  (COM-POP2-RID),(COM-SIMSearch2-RID) |   2          |












