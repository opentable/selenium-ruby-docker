@qa-only
@Avail-Service-ERB
@avail-service-FRN-case

Feature:  FRN detection in Availability Service
Background:


Scenario Outline:
     1. stop OTL on test ERB
     2. Perform direct ERB searches ( PS = 1) - 3 times in a row
     3. verify restaurant status changed to FRN
     4. restart ERB OTL.


    Given I STOP the "OTLServer" service on restaurant "<Rest_name>"
    And I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call AvailabilitySearch API "<api>" three times
    Then I verify restaurant "<rid>" status changed to FRN

@Region-NA
  Scenarios:  FRN detection in Availability Service
 | api                     |  rid                | search_dt  | fwd_days | time   | fwd_mins | back_mins | ps  |  Rest_name         |
 | /availability/searchraw |  (COM-ERB24hr-RID)  | next_day   |  0       | 19:00  | 150      |  150      | 1   | (COM-ERB24hr-Name) |


