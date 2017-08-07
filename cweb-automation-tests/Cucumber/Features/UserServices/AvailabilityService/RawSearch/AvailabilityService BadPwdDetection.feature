@Avail-Service-ERB
@avail-service-badPwd

Feature:  Availability Service - BadPwd detection
Background:



Scenario Outline:
     1. change ERB pwd to bad PWD in webdb
     2. Perform direct ERB searches ( PS = 1) - 1 time
     3. verify restaurant status changed to 7 [ temp inactive
     4. revert back ERB's pwd to corrcet pwd.


    Given I set test ERB "<rid>" password in webdb to a invalid value
    And I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "int-na-svc" "" and get response "200"
    Then I verify restaurant "<rid>" status changed to TempInactive

@Region-NA
  Scenarios:  Availability Service - BadPwd detection
 | api                     |  rid                | search_dt  | fwd_days | time   | fwd_mins | back_mins | ps  |
 | /availability/searchraw |  (COM-ERB24hr-RID)  | next_day   |  0       | 19:00  | 150      |  150      | 1   |


