@qa-only
@Avail-Service-integration
Feature: Consumer Search - returns - default PointValue.

Background:



Scenario Outline: RESTAPI Search - returns - default PointValue.

     Given I use test restaurant "<RID>"
     When I perform metro search then single search for restaurant "<RID>" date "<search_day_offset>" time "<search_time>" partysize "2"
     Then I verify Consumer site returns "<p_value>" points for time slot "<search_time>"


@Region-NA
   Scenarios: search for a non POP restaurant
   | RID                 | search_day_offset | search_time    |  p_value |
   | (COM-SIMSearch-RID) | 2                 |  7:00 PM       |  100     |











