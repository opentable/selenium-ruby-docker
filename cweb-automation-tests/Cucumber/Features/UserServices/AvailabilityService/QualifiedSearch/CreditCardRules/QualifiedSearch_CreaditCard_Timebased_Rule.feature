@Avail-Service
@avail-service-CreditCardTimebasedRule

Feature:  Qualified Search brings availabiliy with CCRequiredflag true if search day/time/ps is set as CC required.

Background:

Scenario Outline:

    Given I set test "<RID>" CC day for "<cc_days_offset>" days ahead time window "<start_time>", "<end_time>" for PartySize above "<cc_ps_limit>"
    When I call Search API for searchdate "<search_days_offset>" days forward, Time "<stime>", partsize "<ps>"
    Then I verify search brings Availability with CreditCardRequired flag "<flag>" for time "<avail_time>" relative to exact time "<stime>"


@Region-NA @incomplete
   Scenarios: search using CC day/CC window/CC ps  - check a avail time that falls within CC window
   | RID                     | start_time | end_time | cc_ps_limit | cc_days_offset     | search_days_offset | stime    | ps | avail_time |flag  |
   | (COM-SIMSearch-RID)     | 20:00      | 21:00    |  3          |  1                 |  1                 | 20:00    | 3  |  20:00   | true |

@Region-NA @incomplete
   Scenarios: search using CC day/CC window/CC ps  - check a avail time that falls outside CC window
   | RID                     | start_time | end_time | cc_ps_limit | cc_days_offset     | search_days_offset  | stime    | ps | avail_time |flag   |
   | (COM-SIMSearch-RID)     | 20:00      | 21:00    |  3          |  1                 |  1                  | 20:00    | 3  |  19:00     | false |

@Region-NA @incomplete
   Scenarios: search using CC day/CC window but non CC PS - check a avail time that falls within CC window
   | RID                     | start_time | end_time | cc_ps_limit | cc_days_offset     | search_days_offset  | stime    | ps | avail_time |flag   |
   | (COM-SIMSearch-RID)     | 20:00      | 21:00    |  3          |  1                 |  1                  | 20:00    | 2  |  20:00     | false |

@Region-NA @incomplete
   Scenarios: search using NON CC day - check a avail time that falls within CC window
   | RID                     | start_time | end_time | cc_ps_limit | cc_days_offset     | search_days_offset  | stime    | ps | avail_time |flag   |
   | (COM-SIMSearch-RID)     | 20:00      | 21:00    |  3          |  1                 |  2                  | 20:00    | 3  |  20:00   | false |
















