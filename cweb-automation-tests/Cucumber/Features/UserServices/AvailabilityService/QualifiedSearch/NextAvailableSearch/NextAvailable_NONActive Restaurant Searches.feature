@Avail-Service
@avail-service-RestStateID


Feature: Perform a search using NON active ERB/Console verify AllowNextAvail is false.
Background:

@Avail-Service

Scenario Outline: Perform a search using NON active ERB/Console verify AllowNextAvail is false.

      Given I setup test restaurant "<RID>" with Restaurant status as "<RState>"
      When I call Search API using PS "<ps>"
      Then I verify search brings AllowNextAvailable as "<value>"

@Region-NA @incomplete
Scenarios: using Non Active ERB
  | RID                  | ps     | value | RState |
  | (COM-SIMSearch-RID)  | 2      | false |   2    |








