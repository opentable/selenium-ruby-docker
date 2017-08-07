@Avail-Service-ERB
@avail-service-ERBBlacklist

Feature:  Direct ERB Search are not allowed for a black listed ERB
Background:



Scenario Outline:
     1. Black list an ERB
     2. Perform raw search using PS = 1
     3. verify search brings No availability


    Given I setup my test ERB "<rid>" as blacklisted
    And I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify NO Time is available in response

@Region-NA
  Scenarios:  ERB - 95164 - Non Cached serach ( PS = 1)
  | host         | port | api                     |  res_code | rid                 | search_dt | fwd_days | time   | fwd_mins | back_mins | ps  |
  | int-na-svc   |      | /availability/searchraw |  200      | (COM-ERB24hr-RID)   | next_day   |  0       | 19:00  | 150      |  150      | 1   |


  Scenario Outline:

  Given I setup my test ERB "<rid>" as blacklisted
  And I create AvailabilityService post data with values "<rid>","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
  When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
  Then I verify Availability Search response brings more than three slots

@Region-NA
Scenarios:  ERB - 95164 - Non Cached serach ( PS = 1)
  | host         | port | api                     |  res_code | rid                 | search_dt | fwd_days | time   | fwd_mins | back_mins | ps  |
  | int-na-svc   |      | /availability/searchraw |  200      | (COM-ERB24hr-RID)   | next_day   |  0       | 19:00  | 150      |  150      | 2   |

