@qa-only
@Avail-Service-integration
@avail-service-SameDayCutoff

Feature: RESTAPI search - returns No availability after same day cutoff time.

Background:

Scenario Outline: RESTAPI search - returns No availability after same day cutoff time.

     Given I setup test rid "<RID>" same day cutoff as PAST local time for dinner shift
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
     When I call REST API Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
     Then I verify REST API search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"


@Region-NA
   Scenarios:
   | RID                      |  no       | rtime    | no_time_message  |  rname |
   | (COM-ERB24hr-RID)        |  0          | 23:45     | cutoff time      |  (COM-SIMSearch-Name)|

Scenario Outline: RESTAPI search - returns availability before same day cutoff time.

    Given I setup test rid "<RID>" same day cutoff as FUTURE local time for dinner shift
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I call REST API Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify REST API search brings Availability


@Region-NA
   Scenarios:
   | RID                      |  no       | rtime    |
   | (COM-ERB24hr-RID)        |  0        | 23:30   |


Scenario Outline: RESTAPI search returns availability for next-day search when same-day cutoff limit exists

    Given I setup test rid "<RID>" same day cutoff as PAST local time for dinner shift
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I call REST API Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify REST API search brings Availability

  @Region-NA
  Scenarios:
    | RID                   |   no      | rtime    |
    | (COM-ERB24hr-RID)     |   1       | 22:00    |


Scenario Outline: RESTAPI search - returns availability when no cutoff limit exist

    Given I remove same day cutoff restriction for test rid "<RID>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I call REST API Search API for restaurant "<RID>" passing searchdate "<no>" days forward, Time "<rtime>"
    Then I verify REST API search brings Availability

  @Region-NA
  Scenarios:
    | RID                   |  no      | rtime    |
    | (COM-ERB24hr-RID)     |  0       | 23:45    |


