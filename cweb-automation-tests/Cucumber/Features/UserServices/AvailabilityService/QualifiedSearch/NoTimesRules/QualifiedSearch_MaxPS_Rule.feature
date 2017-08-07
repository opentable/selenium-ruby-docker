@Avail-Service
@avail-service-maxPS

Feature: Availability Service - Qualified Search returns No availability for a search using PS > MaxPS

Background:

@Avail-Service

Scenario Outline: Qualified search using PS > MaxPS - returns No availability and Reason "X"

     Given I setup test restaurant "<RID>" Max PartySize value "<maxPS>"
     When I call Search API using PS "<PS_value>"
     Then I verify search brings No Availability and NoAvailability Reason as "<NoAvail_Reason>" on search date
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API using PS "<PS_value>"
     Then I verify slot-status returns NoTimesReasons as "<NoAvail_Reason>"

@Region-NA  @Search_maxPS @incomplete
   Scenarios: search with PS > MaxPS limit
   | RID                 | maxPS    | PS_value  | NoAvail_Reason    | const_name   | value |
   | (COM-SIMSearch-RID) | 3        |  4        | AboveMaxPartySize | MaxPartySize |  3    |



Scenario Outline: Qualified search using PS < MaxPS - returns availability

     Given I setup test restaurant "<RID>" Max PartySize value "<maxPS>"
     When I call Search API using PS "<PS_value>"
     Then I verify search brings Availability
     And I verify search brings constrain "<value>" for constrain name "<const_name>"
     When I call Slot-Status API using PS "<PS_value>"
     Then I verify slot-status returns empty NoTimesReasons

@Region-NA  @incomplete
Scenarios: search with PS =  MaxPS limit
  | RID                  | maxPS    | PS_value  | const_name   | value |
  | (COM-SIMSearch-RID)  | 2        |  2        | MaxPartySize |  2    |


@Region-NA  @incomplete
   Scenarios: search with PS <  MaxPS limit
   | RID                  | maxPS    | PS_value  | const_name   | value |
   | (COM-SIMSearch-RID)  | 3        |  2        | MaxPartySize |  3    |





