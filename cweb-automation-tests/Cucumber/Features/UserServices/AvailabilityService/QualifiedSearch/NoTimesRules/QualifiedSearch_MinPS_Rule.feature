@Avail-Service
@avail-service-minPS

Feature: Availability Service - Qualified Search returns No availability for a search using PS < MinPS

Background:

@Avail-Service

Scenario Outline: Qualified search using PS < MinPS - returns No availability and Reason "BelowMinPartySize"

     Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
     When I call Search API using PS "<PS_value>"
     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API using PS "<PS_value>"
     Then I verify slot-status returns NoTimesReasons as "<NoAvail_Reason>"

@Region-NA  @incomplete
   Scenarios: search with PS < MinPS limit
   | RID                 | minPS    | PS_value  | NoAvail_Reason    |  const_name     |  value |
   | (COM-SIMSearch-RID) | 2        |  1        | BelowMinPartySize |    MinPartySize |   2    |



Scenario Outline: Qualified search using PS >= MinPS - returns availability.

     Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
     When I call Search API using PS "<PS_value>"
     Then I verify search brings Availability
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API using PS "<PS_value>"
     Then I verify slot-status returns empty NoTimesReasons

@Region-NA  @incomplete
   Scenarios: search with PS =  MinPS limit
   | RID                  | minPS    | PS_value  |  const_name     |  value |
   | (COM-SIMSearch-RID)  | 2        |  2        |  MinPartySize   |   2    |


@Region-NA @incomplete
   Scenarios: search with PS >  MinPS limit
   | RID                  | minPS    | PS_value  | const_name     |  value |
   | (COM-SIMSearch-RID)  | 2        |  3        | MinPartySize   |   2    |


