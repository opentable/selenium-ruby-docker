@AvailService-production-test

Feature: Call Availability Search API and check response block of qualified search

Background:

Scenario Outline: Verify Echoback in response block of qualified search
     1. Call Availability Qualified search
     2. verify response block -returns Echo back of start date, exact time, party size , ForwardDays,ForwardMinutes,BackwardMinutes
     3. verify it return availabile time

      Given I set test domain to "<domain>"
      When I call Search API using rid "<RID>", "<search_day_offset>" days from today, search time "<search_time>"
      Then I verify echoback data in response
      And I verify search brings Availability


@Region-NA
   Scenarios:  demoland rid - OTC
   | RID            | search_day_offset | search_time  |  domain |
   | (COM-POP2-RID) | 5                 |  17:00       |  .com   |

@Region-NA
   Scenarios:  demoland rid - ERB
   | RID               | search_day_offset | search_time  |  domain |
   | (COM-CreditCard-RID)  | 5                 |  17:00       |  .com   |

@Region-NA
   Scenarios:  demoland rid - Umami
   | RID                 | search_day_offset | search_time  |  domain |
   | (COM-UMAMI24hr-RID) | 5                 |  17:00       |  .com   |


@Region-EU
   Scenarios: demoland rid - OTC
   | RID               | search_day_offset | search_time  |  domain |
   | (COUK-Mobile-RID) | 5                 |  17:00       |  .co.uk |

@Region-EU
   Scenarios: demoland rid - ERB
   | RID                    | search_day_offset | search_time  |  domain |
   | (COUK-CreditCard-RID) | 5                 |  17:00       |  .co.uk |



@Region-Asia
   Scenarios:  demoland rid - OTC
   | RID               | search_day_offset | search_time  |  domain |
   | (JP-Mobile-RID)   | 5                 |  17:00       |  .jp    |

@Region-Asia
   Scenarios: demoland rid - ERB
   | RID               | search_day_offset | search_time  |  domain |
   | (JP-WebErb-RID)   | 5                 |  17:00       |  .jp    |
