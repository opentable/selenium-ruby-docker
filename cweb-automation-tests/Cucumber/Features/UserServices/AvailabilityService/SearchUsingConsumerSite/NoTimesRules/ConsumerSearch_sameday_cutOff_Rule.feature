@qa-only
@Avail-Service-integration
@avail-service-SameDayCutoff

Feature: Consumer search - returns No availability after same day cutoff time.

Background:
    Then I start with a new browser

Scenario Outline: Consumer search - returns No availability after same day cutoff time.

     Given I setup test rid "<RID>" same day cutoff as PAST local time for dinner shift
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
     When I perform consumer site search for restaurant "<RID>" date "<search_days_offset>" time "<stime>" partysize "2"
     Then I verify Consumer site search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"

@Region-NA
   Scenarios:
   | RID                      |  search_days_offset   | stime    | no_time_message  |  rname |
   |  (COM-ERB24hr-RID)       |  0                    | 11:30 PM | cutoff time      |  (COM-SIMSearch-Name)|

Scenario Outline: RESTAPI search - returns availability before same day cutoff time.

    Given I setup test rid "<RID>" same day cutoff as FUTURE local time for dinner shift
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I perform consumer site search for restaurant "<RID>" date "<search_days_offset>" time "<stime>" partysize "2"
    Then I verify Consumer site search brings Availability


@Region-NA
   Scenarios:
   | RID                     |  search_days_offset |stime     |
   |  (COM-ERB24hr-RID)      |  0                  | 11:30 PM |


Scenario Outline: RESTAPI search returns availability for next-day search when same-day cutoff limit exists

    Given I setup test rid "<RID>" same day cutoff as PAST local time for dinner shift
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I perform consumer site search for restaurant "<RID>" date "<search_days_offset>" time "<stime>" partysize "2"
    Then I verify Consumer site search brings Availability

  @Region-NA
  Scenarios:
    | RID                     |   search_days_offset  | stime    |
    |  (COM-ERB24hr-RID)      |  1                    | 11:30 PM |


Scenario Outline: RESTAPI search - returns availability when no cutoff limit exist

    Given I remove same day cutoff restriction for test rid "<RID>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I perform consumer site search for restaurant "<RID>" date "<search_days_offset>" time "<stime>" partysize "2"
    Then I verify Consumer site search brings Availability

  @Region-NA
  Scenarios:
    | RID                   |  search_days_offset  | stime    |
    | (COM-ERB24hr-RID)     |  0                   | 11:30 PM |


