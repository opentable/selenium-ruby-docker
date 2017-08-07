@Avail-Service-logging
Feature:

Background:

Scenario Outline: Availability Service - Qualified Search returns - default pointType and PointValue.

     Given I call flushlogger API then capture high watermark
     When I call search API using single rid "<RID>"
     And I call flushlogger
     Then I verify search stats are logged and searchType is logged as "<searchType>"


@Region-NA
   Scenarios: search is logged as SingleSearch (Type - 1)
   | RID                 | searchType |
   | (COM-SIMSearch2-RID) | 1         |











