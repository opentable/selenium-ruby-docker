@AvailService-BasicTest
Feature: Availability service - creates search log.

Background:

Scenario Outline:

     Given I set test domain to "<domain>"
     And I call flushlogger API then capture high watermark
     When I call search API using single rid "<RID>"
     And I call flushlogger
     Then I verify search stats are logged and searchType is logged as "<searchType>"


@Region-NA @incomplete
   Scenarios: search is logged as SingleSearch (Type - 1)
   | RID                 | searchType |  domain |
   | (COM-SIMSearch-RID) | 1          |  .com   |

@Region-EU @incomplete
   Scenarios:
   | RID               | searchType  |   domain  |
   | (COUK-Mobile-RID) | 1           |  .co.uk   |

@Region-Asia @incomplete
   Scenarios:
   | RID               |  searchType | domain  |
   | (JP-Mobile-RID)   | 1           |  .jp    |










