@Avail-Service-ERB
Feature:

Background: Search - paging


Scenario Outline: Search - paging

     Given I set test domain to "<domain>"
     When I call multi search API using rid_list "<rid_list>", OmitNotimeRest "<no_time_flag>", Offset "<result_offset>", limit "<result_limit>", time "<time>"
     Then I verify search brings restaurants starting offset "<result_offset>" and result limit "<result_limit>"
     And I verify search response last value is "<last>"

@Region-NA
   Scenarios: Search - Omit_NoAvailable restaurant
    | domain  |  rid_list                                                                  |   no_time_flag   | result_offset |  result_limit |  time  |  last |
    |  .com   | (COM-POP2-RID),(COM-SIMSearch2-RID),(COM-SIMSearch-RID),(COM-ERB24hr-RID)  |     false        |   0           |      2        |  19:30 |   3   |


@Region-NA
   Scenarios: Search - Omit_NoAvailable restaurant
    | domain  |  rid_list                                                                  |   no_time_flag   | result_offset |  result_limit |  time  |  last |
    |  .com   | (COM-POP2-RID),(COM-SIMSearch2-RID),(COM-SIMSearch-RID),(COM-ERB24hr-RID)  |     false        |   1           |      2        |  19:30 |   3   |


@Region-NA
   Scenarios: Search - Omit_NoAvailable restaurant
    | domain  |  rid_list                                                                  |   no_time_flag   | result_offset |  result_limit |  time  |  last |
    |  .com   | (COM-POP2-RID),(COM-SIMSearch2-RID),(COM-SIMSearch-RID),(COM-ERB24hr-RID)  |     false        |   1           |      1        |  19:30 |   3   |



Scenario Outline: Search - paging with Omit_NoAvailable restaurant

  Given I set test domain to "<domain>"
  When I call multi search API using rid_list "<rid_list>", OmitNotimeRest "<no_time_flag>", Offset "<result_offset>", limit "<result_limit>", time "<time>"
  Then I verify search brings restaurants starting offset "<result_offset>" and OmitNotimeRest "<no_time_flag>"
  And I verify search brings total restaurant "<result_limit>"
  And I verify search response last value is "<last>"

@Region-NA
   Scenarios: Search - Omit_NoAvailable restaurant
    | domain  |  rid_list                                                                  |   no_time_flag   | result_offset |  result_limit |  time  |  last |
    |  .com   | (COM-POP2-RID),(COM-SIMSearch2-RID),(COM-SIMSearch-RID),(COM-ERB24hr-RID)  |     true         |   1           |      1        |  19:30 |   1   |






