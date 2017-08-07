@qa-only
@Avail-Service-integration
@avail-service-MultiDayCutoff

Feature: Consumer Search - returns No availability when search day falls withing Earlydays cutoff limits

Background:
    Then I start with a new browser
Scenario Outline: Consumer Search Search - returns No availability when search day falls withing Earlydays cutoff limits

     Given I setup test rid "<RID>" days cutoff limit "<cut_offdays_no>" days
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
     When I perform Consumer search using searchdate "<numDays>" days forward
     Then I verify Consumer site search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"

@Region-NA
   Scenarios: search with search date < multi DayCutoff
   | RID                      | cut_offdays_no  | numDays  | no_time_message                                                        | rname                |
   | (COM-SIMSearch-RID)      | 5               | 4        | does not allow reservations to be made within 5 days of the reservation  | (COM-SIMSearch-Name) |


Scenario Outline: search - returns availability when search day falls out of Earlydays cutoff limits

    Given I setup test rid "<RID>" days cutoff limit "<cut_offdays_no>" days
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList;GetRestaurantCutoffTimesCutoff;GetRestaurantCutoffTimesIndex" item
    When I perform Consumer search using searchdate "<numDays>" days forward
    Then I verify Consumer site search brings Availability

@Region-NA
Scenarios: Consumer Search with search date > multi DayCutoff
  | RID                      | cut_offdays_no     | numDays  |
  | (COM-SIMSearch-RID)      | 5                  | 6        |


@Region-NA
Scenarios: REST search with search date = multi DayCutof
    | RID                      | cut_offdays_no     | numDays  |
    | (COM-SIMSearch-RID)      | 5                  | 5        |

