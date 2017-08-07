Feature: Availability Service returns code 200 and cached ERB searches brings more than 3 slots
Background:

@Avail-Service-rawsearch
Scenario Outline:  Availability Service returns code 200 for success.
     1. ERB- cached searches - PS = 2 brings more than 3 slots.


    Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify Availability Search response brings more than three slots


@Region-NA
  Scenarios:  ERB - 95164 - Non Cached serach ( PS = 1)
  | host         | port  | api                     |  res_code | rid   | search_dt | fwd_days | time   | fwd_mins | back_mins | ps  |
  | int-na-svc   |        | /availability/searchraw |  200      | 2182 | next_day   |  0       | 19:00  | 150      |  150      | 2   |

