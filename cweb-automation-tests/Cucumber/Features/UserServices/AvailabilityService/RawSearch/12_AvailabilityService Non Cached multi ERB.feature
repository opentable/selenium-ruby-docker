Feature: Availability Service returns code 200 and 3 slots for non cached ERB searches
Background:

@Avail-Service-rawsearch

Scenario Outline:  Availability Service returns code 200 for success.
     1. ERB- non cached searches PS = 1 - 3 slots only


    Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify Availability Search response block

@Region-NA
  Scenarios: MIXED ERBs  [ 2182 - 3 slots 15 min interval, 95158 - no slots , 2396 - 3 slots 1 hour interval ]
  | host         | port  | api                     |  res_code | rid              | search_dt | fwd_days | time   | fwd_mins | back_mins | ps  |
  | int-na-svc   |       | /availability/searchraw |  200      | 2182,95158,94669  | next_day   |  0       | 19:00  | 150      |  150      | 1   |

@Region-NA
  Scenarios: MIXED ERBs [ 2182 - 3 slots 15 min interval, 95158 - no slots for ps 1, 2396 - 9pm/10 pm slots only ]
  | host         | port  | api                     |  res_code | rid              | search_dt | fwd_days | time   | fwd_mins | back_mins | ps  |
  | int-na-svc   |       | /availability/searchraw |  200      | 2182,95158,94669  | next_day   |  0       | 22:00  | 150      |  150      | 1   |

@Region-NA
  Scenarios: MIXED ERBs [ 2182 - 15 min interval, 95158 - 8/9/10 three slots , 2396 - 2 slots only 9pm/10pm  ]
  | host         | port  | api                     |  res_code | rid              | search_dt  | fwd_days | time    | fwd_mins  | back_mins  | ps   |
  | int-na-svc   |       | /availability/searchraw |  200      | 2182,95158,94669  | next_day   |  0       | 22:00  | 150      |  150      | 2   |

