Feature: Availability srevice test with MULTI RID
Background:

@Avail-Service-rawsearch

Scenario Outline:  Availability Service returns code 200 for success.
     1. Multi search ( ERB 95158+ Console 95167 + Ummai - 102364 )


     Given I create AvailabilityService post data with values "95167,95158,(COM-UMAMI2-RID)","<search_dt>","<fwd_days>","<time>","<fwd_mins>","<back_mins>","<ps>"
     When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
     Then I verify time is AVAILABLE for rid "95167" searchday "[Search_date]" and time "<time>"
     And I verify time is AVAILABLE for rid "95158" searchday "[Search_date]" and time "<time>"
     And I verify time is AVAILABLE for rid "(COM-UMAMI2-RID)" searchday "[Search_date]" and time "<time>"
     And I verify time is NOT-AVAILABLE for rid "95167" searchday "[Search_date]" and time "<not_avail_time>"
     And I verify time is NOT-AVAILABLE for rid "95158" searchday "[Search_date]" and time "<not_avail_time>"

 @Region-NA
   Scenarios: console RID 95167 - preset for availability till 10 PM , no inventory after 10.
   | host         | port  | api                      |  res_code | rid                | search_dt | fwd_days | time  | fwd_mins | back_mins | ps  | not_avail_time |
   | int-na-svc   |       | /availability/searchraw  |  200      | 95167,95158,101188 | next_day  |  0       | 22:00 | 150      |  150      | 3   |  22:30          |



