@Avail-Service-logging
@avail-service-MultiDayCutoff
Feature:  SearchLogging - No Availability due to multiDayCutOff Limit

Background:


Scenario Outline: SearchLogging - No Availability due to multiDayCutOff Limit

    Given I setup test rid "<RID>" days cutoff limit "<cut_offdays_no>" days
    And I call flushlogger API then capture high watermark
    When I call search API using single rid "<RID>" for "<days>" days in the future
    And I call flushlogger
    Then I verify Status_NoAvailability  "<v1>" is logged for RID "<RID>"
    Then I verify Status_CuttOffs  "<v2>" is logged for RID "<RID>"


@Region-NA
   Scenarios: search within cutoff limit brings NO availability
   | RID                  |  cut_offdays_no | days  |   v1  |  v2  |
   | (COM-SIMSearch2-RID)  |  5              | 4     |   1   |   1  |
@Region-NA
Scenarios: search beyond cutoff limit brings availability
  | RID                  |  cut_offdays_no| days  |   v1   |  v2  |
  | (COM-SIMSearch2-RID)  | 5              | 6     |   0    |  0   |











