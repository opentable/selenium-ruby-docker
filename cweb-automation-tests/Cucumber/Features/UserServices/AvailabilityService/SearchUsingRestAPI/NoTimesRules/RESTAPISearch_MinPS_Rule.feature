@qa-only
@Avail-Service-integration
@avail-service-minPS


Feature: REST API Search - No availability for a search using PS < MinPS

Background:
     Then I start with a new browser

Scenario Outline: REST API Search - No availability for a search using PS < MinPS

     Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
     When I perform REST API search using PS "<PS_value>"
     Then I verify REST API search brings NoAvailability Reason as "<text>" for restaurant "<rname>"


@Region-NA
   Scenarios: search with PS < MinPS limit
   | RID                 | minPS    | PS_value  |   rname                |  text                                       |
   | (COM-SIMSearch-RID) | 2        |  1        | (COM-SIMSearch-Name)   |  minimum party size for online reservations |



Scenario Outline: REST API Search - Availability for a search using PS >= MinPS.

    Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
    When I perform REST API search using PS "<PS_value>"
    Then I verify REST API search brings Availability


@Region-NA
   Scenarios: search with PS =  MinPS limit
   | RID                  | minPS    | PS_value  |
   | (COM-SIMSearch-RID)  | 2        |  2        |


@Region-NA
   Scenarios: search with PS >  MinPS limit
   | RID                  | minPS    | PS_value  |
   | (COM-SIMSearch-RID)  | 2        |  3        |


