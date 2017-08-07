@Avail-Service-logging
@avail-service-minPS
Feature: Search returns Status_MinPartySizeRestriction for searches below minPS.

Background:



Scenario Outline: Search returns Status_MinPartySizeRestriction for searches below minPS.

     Given I setup test restaurant "<RID>" Min PartySize value "<minPS>"
     And I call flushlogger API then capture high watermark
     When I call search API using single rid "<RID>" for party size "<ps>"
     And I call flushlogger
     Then I verify Status_MinPartySizeRestriction "<bit>" is logged for RID "<RID>"

@Region-NA
   Scenarios: search with PS < MIn PS limit
     | RID                  |  minPS  |  ps |  bit |
     | (COM-SIMSearch2-RID)  |   2     |  1  |   1  |













