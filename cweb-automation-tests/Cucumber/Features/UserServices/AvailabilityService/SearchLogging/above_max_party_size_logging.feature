@Avail-Service-logging
@avail-service-maxPS
Feature:  SearchLogging -  Status_MaxPartySizeRestriction for searches above MaxPS.

Background:


Scenario Outline: SearchLogging -  Status_MaxPartySizeRestriction for searches above MaxPS.

     Given I setup test restaurant "<RID>" Max PartySize value "<maxPS>"
     And I call flushlogger API then capture high watermark
     When I call search API using single rid "<RID>" for party size "<ps>"
     And I call flushlogger
     Then I verify Status_MaxPartySizeRestriction "<v>" is logged for RID "<RID>"

@Region-NA
   Scenarios: search with PS >  MaxPS limit
   | RID                  |  maxPS | ps  |   v  |
   | (COM-SIMSearch2-RID) |    3   | 4   |   1  |

@Region-NA
Scenarios: search with PS <  MaxPS limit
  | RID                   |  maxPS | ps  |   v  |
  | (COM-SIMSearch2-RID)  |  3     |  2  |    0 |











