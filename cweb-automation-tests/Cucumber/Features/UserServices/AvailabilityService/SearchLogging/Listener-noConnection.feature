@qa-only
@Avail-Service-ERB
@avail-service-FRN-case

Feature:  Search Logging - ERB Listener Off
Background:



Scenario Outline: Search Logging - ERB Listener Off

     Given I STOP the "OTLServer" service on restaurant "<Rest_name>"
     And I call flushlogger API then capture high watermark
     When I call search API using single rid "<RID>" for party size "<ps>"
     And I wait then call flushlogger
     Then I verify Status_NoConnection "<v>" is logged for RID "<RID>"

@Region-NA
  Scenarios:  FRN detection in Availability Service
  | Rest_name         |  RID               |  ps  | v  |
  | (COM-ERB24hr-Name) | (COM-ERB24hr-RID) |  1   |  1 |


