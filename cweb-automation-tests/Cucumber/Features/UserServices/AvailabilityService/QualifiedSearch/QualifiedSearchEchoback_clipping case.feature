@Avail-Service
Feature: Verify response block of qualified search - echoback Search Time - uses applied search time after clipping

Background:

@Avail-Service

Scenario Outline: Verify Time Clipping in Echo Back
     1. Call Availability Qualified search using a time say - 19:03
     2. verify it returns code -200 for success
     3. verify response block
        a. Verify Echo back - Exact Time is 19:15


      Given I use test restaurant "<RID>"
      When I call search API using search day "<search_day_offset>" days from today, search time "<search_time>", AllowPop "true"
      Then I verify echoback Exact Time is response is "<time>"

@Region-NA
   Scenarios:
   | RID                 | search_day_offset | search_time  | time  |
   | (COM-SIMSearch-RID) | 2                 |  19:03       | 19:15 |

@Region-NA
   Scenarios:
   | RID                 | search_day_offset | search_time  | time  |
   | (COM-SIMSearch-RID) | 2                 |  19:11      | 19:15  |

@Region-NA
   Scenarios:
   | RID                 | search_day_offset | search_time  | time  |
   | (COM-SIMSearch-RID) | 2                 |  19:17      | 19:30  |


