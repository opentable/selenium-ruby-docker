@qa-only
@Avail-Service-integration
@avail-service-RestStateID
Feature:  Consumer search for a Non Active RID
Background:
    Then I start with a new browser

Scenario Outline: Consumer search for a Non Active RID - returns no availability and NoAvailReason as NotActive.

     Given I setup test restaurant "<RID>" with Restaurant status as "<RState>"
     And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
     When I access restaurant profile I should see message "<offline_message>" in place of serach module

@Region-NA
   Scenarios: search for a NonActive RID - brings no availability
   | RID                    | RState | offline_message                                |
   | (COM-SIMSearch-RID)    | 2      | Accepting OpenTable online reservations soon!  |



Scenario Outline: Consumer search for a Active RID brings availability.

    Given I setup test restaurant "<RID>" with Restaurant status as "<RState>"
    And I recache consumer website for "CacheRestaurantList;CacheRestaurantSearchList;CacheMetroAreaList" item
    When I perform Consumer search using searchdate "1" days forward
    Then I verify Consumer site search brings Availability

@Region-NA
     Scenarios: Consumer search for a Active RID brings availability.
       | RID                    | RState |
       | (COM-SIMSearch-RID)    | 1      |


#Scenario Outline: Qualified search for an Active but NonReachable RID - returns no availability and NoAvailReason as Offline.
#      1. Setup -  ERB is active but not reachable in DB, Listener is OFF
#
#      Given I setup test restaurant "<RID>" as Active but non Reachable
#      When I call Search API using default values
#      Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
#
#
#@Region-NA  @incomplete
#       Scenarios: ERB search for an Active but NonReachable RID
#       | RID                   | NoAvail_Reason |
#       | (COM-SIMSearch-RID)   | Offline        |


#Scenario Outline: Qualified search for an Active but NonReachable RID - returns no availability and NoAvailReason as Offline.
#      1. ERB is active and reachable in webdb but ERB is not responsing [ stop ERB Listener]
#      2. perform a direct ERB search -> gets NoAvail and NoAvail Reason will be "Offline"
#
#     Given I setup test restaurant "<RID>" as active, reachable but not responding ERB
#     When I call Search API using default values
#     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
#
#@Region-NA
#   Scenarios: search for a NonActive RID - brings no availability
#   | RID                    | NoAvail_Reason |
#   | (COM-SIMSearch-RID)    | Offline        |
#



