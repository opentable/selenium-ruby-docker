@Avail-Service

Feature: Perform a multi Day search using ERB / console [cached PS], to test NextAvailable Search.
Background:


Scenario Outline: Perform a multi Day search using ERB / console [cached PS], to test NextAvailable Search.

  Given I use test restaurant "<RID1>"
  When I call Search API passing searchdate "<numDays>" days forward, search_days "<multi_days>"
  Then I verify search brings availability all days

@Region-NA
Scenarios: using console RID  (COM-POP2-RID)
  | RID1                     |   numDays  |  multi_days |
  | (COM-SIMSearch-RID)      |  1         |  5         |











