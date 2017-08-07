Feature: Availability Service returns code 200 and 3 slots for non cached ERB searches
Background:

@Avail-Service-rawsearch

Scenario Outline:  Availability Service returns code 200 for success.
     1. ERB- non cached searches PS = 1 - 3 slots only


    Given I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify Availability Search response brings maximum three available slots

@Region-NA
  Scenarios:  ERB - 95164 - Non Cached serach ( PS = 1)
  | host         | port | api                     |  res_code | rid   | search_dt | fwd_days | time   | fwd_mins | back_mins | ps  |
  | int-na-svc   |      | /availability/searchraw |  200      | 2182 | next_day   |  0       | 19:00  | 150      |  150      | 1   |

