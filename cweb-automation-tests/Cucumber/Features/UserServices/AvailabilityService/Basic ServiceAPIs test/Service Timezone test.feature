@AvailService-BasicTest
Feature: Search API - TimeZone test

Background:


Scenario Outline: search for past time - returns no availability
     1. Call Availability Qualified search - search time as 15 min passed local restaurant time.
     2. verify it return No availabile and NoAvailability reason as - NotFarEnoughInAdvance

      Given I set test domain to "<domain>"
      And I use test restaurant "<RID>"
      When I call serach API using search time as past local time for restaurant "<RID>"
      Then I verify search brings No Availability

@Region-NA @incomplete
   Scenarios:
   | RID                 | domain |
   | (COM-SIMSearch-RID) | .com   |

@Region-EU @incomplete
   Scenarios:
   | RID                   |domain |
   | (COUK-CreditCard-RID) |.co.uk |

@Region-Asia @incomplete
   Scenarios:
   | RID             |  domain |
   | (JP-FRN-RID)    |  .jp    |


Scenario Outline: search for future time - returns availability for Future time but NO availability for PAST Time

     Given I set test domain to "<domain>"
     And I setup test restaurant "<RID>"
     When I call search API for today searchTime "<searchTimeOffsetMinutes>" minutes from current Restaurant Time
     Then I verify search brings no slot in Local restaurant Past time
     #And I verify search brings minimum "<no>" slots in backward window of search time

@Region-NA
   Scenarios: search single day - should not bring any PAST time slots
   | RID                     | domain | searchTimeOffsetMinutes   |
   | (COM-ERB24hr-RID)       |  .com  |                    60     |

@Region-EU
   Scenarios:
   | RID                   |  domain | searchTimeOffsetMinutes |
   | (COUK-CreditCard-RID) |  .co.uk |                      60 |

@Region-Asia
   Scenarios:
   | RID          |  domain |   searchTimeOffsetMinutes   |
   | (JP-FRN-RID) |  .jp    |                         60  |

