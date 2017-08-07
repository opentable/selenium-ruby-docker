@Avail-Service-ERB
Feature: Search - Omit_NoAvailable restaurant

Background: Search - Omit_NoAvailable restaurant


Scenario Outline: Search - Omit_NoAvailable restaurant

     Given I set test domain to "<domain>"
     When I call multi search API using rid_list "<rid_list>", OmitNotimeRest "<no_time_flag>", Offset "<result_offset>", limit "<result_limit>", time "<time>"
     Then I verify search response brings all restaurants in response


@Region-NA
   Scenarios: Search - Omit_NoAvailable as false
    | domain  |  rid_list                                                                 |   no_time_flag | result_offset |  result_limit |  time  |
    |  .com   | (COM-POP2-RID),(COM-SIMSearch2-RID),(COM-SIMSearch-RID),(COM-ERB24hr-RID) |     false      |               |               |  19:30 |



Scenario Outline: Search - Omit_NoAvailable restaurant

  Given I set test domain to "<domain>"
  When I call multi search API using rid_list "<rid_list>", OmitNotimeRest "<no_time_flag>", Offset "<result_offset>", limit "<result_limit>", time "<time>"
  Then I verify search response omits restaurants with no availability


@Region-NA
   Scenarios: Search - Omit_NoAvailable as true
    | domain  |  rid_list                                                                  |   no_time_flag | result_offset |  result_limit | time   |
    |  .com   | (COM-POP2-RID),(COM-SIMSearch2-RID),(COM-SIMSearch-RID), (COM-ERB24hr-RID) |     true       |               |               |  19:30 |








