@qa-only
@Avail-Service-integration
Feature: RESTAPI Search - returns - default PointValue.

Background:


Scenario Outline: RESTAPI Search - returns - default PointValue.

     Given I use test restaurant "<RID>"
     When I call REST API Search API for restaurant "<RID>" passing searchdate "<search_day_offset>" days forward, Time "<search_time>"
     Then I verify REST API returns "<p_value>" for time slot "<time>"


@Region-NA
   Scenarios: search for a non POP restaurant
   | RID                 | search_day_offset | search_time  |  p_value | time  |
   | (COM-SIMSearch-RID) | 2                 |  19:00       |  100     | ExactPoints |











