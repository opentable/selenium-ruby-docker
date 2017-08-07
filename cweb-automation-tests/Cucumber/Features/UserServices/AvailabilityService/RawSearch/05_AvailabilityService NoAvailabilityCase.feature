Feature: Availability Service returns code 200 and NO availability when no time available for searched window.

Background:

@Avail-Service-rawsearch

Scenario Outline:  Availability Service returns code 200 for success. and no availability when no time avail for serched window.
     1. console RID - 95152 - no avail on monday BF Shift
     2. ERB - 2182   -  no avail for PS > 6
     3. Umami - 101185  - no avail on monday BF Shift


     Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
     When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
     Then I verify NO Time is available in response



@Region-NA
   Scenarios: console RID 95152 - monday BF shift closed
   | host         | port  | api                     |  res_code | rid                         | search_dt    | fwd_days     | time    | fwd_mins | back_mins | ps  |
   | int-na-svc   |       | /availability/searchraw |  200      | (COM-NextAvailable-Name)     | next_monday  |  0           | 07:00   | 120      |  120      | 3   |

@Region-NA
  Scenarios: ERB - 2182 - no slots available for PS > 6.
  | host         | port  | api                      |  res_code | rid                          | search_dt | fwd_days    | time    | fwd_mins | back_mins | ps  |
  | int-na-svc   |       | /availability/searchraw  |  200      | (COM-ERB24hr-Name)     | next_day  |  0          | 19:00   | 120      |  120      | 7   |

  @Region-NA
  Scenarios: Umami 102361 - No Dinner shift
  | host         | port  | api                    |  res_code | rid                     | search_dt    | fwd_days | time    | fwd_mins | back_mins | ps  |
  | int-na-svc   |       | /availability/searchraw|  200      |(COM-OneSlotUMAMI-RID)  | next_day     |  0       | 19:00   | 120      |  120     | 2   |


