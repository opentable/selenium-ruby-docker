@qa-only
@Avail-Service-integration
@avail-service-minPS


Feature: Consumer Search returns No availability for a search using PS < MinPS

Background:
     Then I start with a new browser

Scenario Outline: Consumer search using PS < MinPS - returns No availability and Reason "BelowMinPartySize"

     Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
      And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
     When I perform consumer site search using PS "<PS_value>"
     Then I verify Consumer site search brings NoAvailability Reason as "<text>" for restaurant "<rname>"


@Region-NA
   Scenarios: search with PS < MinPS limit
   | RID                 | minPS    | PS_value  |   rname                |  text                                       |
   | (COM-SIMSearch-RID) | 2        |  1        | (COM-SIMSearch-Name)   |  minimum party size for online reservations |



Scenario Outline: Consumer search using PS >= MinPS - returns availability.

     Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
     When I perform consumer site search using PS "<PS_value>"
     Then I verify Consumer site search brings Availability

@Region-NA
   Scenarios: search with PS =  MinPS limit
   | RID                  | minPS    | PS_value  |
   | (COM-SIMSearch-RID)  | 2        |  2        |


@Region-NA
   Scenarios: search with PS >  MinPS limit
   | RID                  | minPS    | PS_value  |
   | (COM-SIMSearch-RID)  | 2        |  3        |


