@AvailService-BasicTest
Feature: Call Availability Search API and check response block of qualified search

Background:



Scenario Outline: Verify Echoback in response block of qualified search
     1. Call Availability Qualified search
     2. verify response block -returns Echo back of start date, exact time, party size , ForwardDays,ForwardMinutes,BackwardMinutes
     3. verify it return availabile time and points.

      Given I set test domain to "<domain>"
      And I use test restaurant "<RID>"
      When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
      Then I verify echoback data in response
      And I verify search brings availability for date "<day_offset>" at time "<time1>" with points "<p_value1>"


@Region-NA
   Scenarios:
   | RID                 | search_day_offset | search_time  |  domain | day_offset  |  p_value1 |  time1 |
   | (COM-SIMSearch-RID) | 5                 |  17:00       |  .com   | 5           |  100      | 19:00  |

@Region-EU
   Scenarios:
   | RID               | search_day_offset | search_time  |  domain | day_offset  |  p_value1 |  time1 |
   | (COUK-Mobile-RID) | 5                 |  17:00       |  .co.uk | 5           |  100      | 19:00  |

@Region-Asia
   Scenarios:
   | RID               | search_day_offset | search_time  |  domain | day_offset  |  p_value1 |  time1 |
   | (JP-Mobile-RID)   | 5                 |  17:00       |  .jp    | 5           |  100      | 19:00  |
