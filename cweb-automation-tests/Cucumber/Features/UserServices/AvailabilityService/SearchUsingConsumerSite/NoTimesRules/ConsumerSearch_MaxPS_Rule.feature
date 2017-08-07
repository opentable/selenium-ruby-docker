@qa-only
@Avail-Service-integration
@avail-service-maxPS

Feature: Consumer Search - No availability for a search using PS > MaxPS

Background:
  And I start with a new browser

Scenario Outline: Consumer Search using PS > MaxPS - returns No availability and Reason "X"

     Given I setup test restaurant "<RID>" Max PartySize value "<maxPS>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
     When I perform consumer site search using PS "<PS_value>"
     Then I verify Consumer site search brings NoAvailability Reason as "<no_time_message>" for restaurant "<rname>"

@Region-NA  @Search_maxPS
   Scenarios: search with PS > MaxPS limit
   | RID                 | maxPS    | PS_value  | rname                | no_time_message           |
   | (COM-SIMSearch-RID) | 3        |  4        | (COM-SIMSearch-Name) | Your party size is larger |



Scenario Outline: Consumer Search using PS <= MaxPS - returns availability.

      Given I setup test restaurant "<RID>" Max PartySize value "<maxPS>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
      When I perform consumer site search using PS "<PS_value>"
      Then I verify Consumer site search brings Availability


  @Region-NA
     Scenarios: search with PS =  MaxPS limit
     | RID                  | maxPS    | PS_value  |
     | (COM-SIMSearch-RID)  | 3        |  3        |


  @Region-NA
     Scenarios: search with PS <  MaxPS limit
     | RID                  | maxPS    | PS_value  |
     | (COM-SIMSearch-RID)  | 3        |  2       |




