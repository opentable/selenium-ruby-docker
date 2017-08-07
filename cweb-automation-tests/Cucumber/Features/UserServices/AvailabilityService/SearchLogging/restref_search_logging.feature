@Avail-Service-logging
Feature:

Background:  SearchLogging - RestRef Search


Scenario Outline: SearchLogging - RestRef Search

     Given I call flushlogger API then capture high watermark
     When I call restref search API using single rid "<RID>"
     And I call flushlogger
     Then I verify search stats are logged and searchType is logged as "<searchType>"


@Region-NA
   Scenarios: search is logged as RestaurantSearch (Type - 3)
   | RID                 | searchType |
   | (COM-SIMSearch2-RID) | 3         |











