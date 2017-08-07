@Avail-Service-ERB
Feature:

Background:  SearchLogging - slot counts


Scenario Outline: SearchLogging - slot counts

     Given I call flushlogger API then capture high watermark
     When I call search API and allow POP using single rid "<RID>"
     And I call flushlogger
     Then I verify "<i>" SlotsAvail and "<j>" POPSlotsAvail are logged for RID "<RID>"

@Region-NA
   Scenarios: total search requests are counted in log
     | RID               |  i  | j  |
     | (COM-ERB24hr-RID) |  21 | 7  |












