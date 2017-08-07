Feature: Availability Service brings slots for midnight searches

  Background:

  @Avail-Service-rawsearch

  Scenario Outline:  Availability Service returns code 200 for success.
  1. Midnight case - ERB - 2182 - rest set with 24 hour shift
  2. Midnight case - for Umami - 102358 - rest set with 24 hour shift

    Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify time is AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "<time>"
    Then I verify time is AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "23:45"
    Then I verify time is AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "00:00"

  @Region-NA
  Scenarios:
    | host       | port | api                     | res_code | rid  | search_dt | fwd_days | time  | fwd_mins | back_mins | ps |
    | int-na-svc |      | /availability/searchraw | 200      | 2182 | next_day  | 0        | 23:30 | 120      | 120       | 3  |

  @Region-NA
    Scenarios:
      | host       | port | api                     | res_code | rid                  | search_dt | fwd_days | time  | fwd_mins | back_mins | ps |
      | int-na-svc |      | /availability/searchraw | 200      | (COM-UMAMI24hr-RID)  | next_day  | 0        | 23:30 | 120      | 120       | 2  |


  @Avail-Service-rawsearch
  Scenario Outline:  Availability Service returns code 200 for success.
  1. Midnight case - ERB -2182
  2. Midnight case - for Umami

    Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify time is AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "<time>"
    Then I verify time is AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "23:45"
    Then I verify time is AVAILABLE for rid "<rid>" searchday "[Search_date]" and time "00:15"

  @Region-NA
  Scenarios:
    | host       | port | api                     | res_code | rid  | search_dt | fwd_days | time  | fwd_mins | back_mins | ps |
    | int-na-svc |      | /availability/searchraw | 200      | 2182 | next_day  | 0        | 00:00 | 120      | 120       | 3  |


  @Region-NA
  Scenarios:
      | host       | port | api                     | res_code | rid                  | search_dt | fwd_days | time  | fwd_mins | back_mins | ps |
      | int-na-svc |      | /availability/searchraw | 200      | (COM-UMAMI24hr-RID)  | next_day  | 0        | 00:00 | 120      | 120       | 2  |




