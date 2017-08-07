Feature: Availability Service returns code 200 for success and 400 for bad data

Background:
@Avail-Service-rawsearch

Scenario Outline:  Availability Service returns code 200 for success. and mixed availability result in response.
    1. console RID 95167 - preset for availability till 10 PM , no inventory after 10.
    2. ERB - 95158 [ Mixed result set ] - preset for availability till 10 PM , no inventory after 10.
    3. Ummai - 102364 - - dinner shift ends at 11 PM


    Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify time is AVAILABLE for rid "<rid>>" searchday "[Search_date]" and time "<time>"
    Then I verify time is NOT-AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "<not_avail_time>"


@Region-NA
  Scenarios: console RID 95167 - preset for availability till 10 PM , no inventory after 10.
  | host         | port  | api                     |  res_code | rid   | search_dt | fwd_days | time  | fwd_mins | back_mins | ps  | not_avail_time  |
  | int-na-svc   |       | /availability/searchraw |  200      | 95167 | next_day  |  0       | 22:00 | 120     |  120       | 3  |  22:30          |


@Region-NA
  Scenarios:  ERB-SIM - 95158  - - preset for availability till 10 PM , no inventory after 10.

  | host         | port  | api                      |  res_code | rid   | search_dt   | fwd_days  | time  | fwd_mins | back_mins | ps  |  not_avail_time |
  | int-na-svc   |       | /availability/searchraw  |  200      | 95158  | next_day   |  0        | 22:00 | 120      |  120      | 2   |   22:30         |

@Region-NA
  Scenarios:  Ummai - 102364 - - Lunch ends at 3 PM.
  | host         | port  | api                     |  res_code | rid              | search_dt | fwd_days | time  | fwd_mins | back_mins | ps  |  not_avail_time   |
  | int-na-svc   |       | /availability/searchraw |  200      | (COM-UMAMI2-RID)  | next_day |  1        | 15:00 | 120      |  120      | 2   |   15:30         |


