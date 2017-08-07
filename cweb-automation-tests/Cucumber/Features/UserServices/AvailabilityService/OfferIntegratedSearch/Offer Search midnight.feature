@Avail-Service-offer
Feature: Search APIIncludeOffer - midnight case

Background:


Scenario Outline: Search APIIncludeOffer - midnight case - search time 11:45 PM  [ Offers time for rest - 11 PM to 1 AM ]

     Given I set test domain to "<domain>"
     When I call search API using rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
     Then I verify search returns OfferId for date "<day_offset>" days from today, search time "<time1>"
     And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time2>"
     And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time3>"
     And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time4>"
     And I verify search returns No offerId for date "<day_offset>" days from today, search time "<time5>"


@Region-EU
   Scenarios: search for a non POP restaurant - without passing POPFlag
   | domain | RID             | day_offset |time     |  offer_flag |  time1 |  time2 | time3 | time4 | time5 |
   | .co.uk |(COUK-FRN-RID)  | 1          | 23:45  |    true      |  23:45 |  00:00 | 00:15 | 01:00 | 01:15 |


Scenario Outline: Search APIIncludeOffer - midnight case - search time 00:15 AM  [ Offers time for rest - 11 PM to 1 AM ]

      Given I set test domain to "<domain>"
      When I call search API using rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
      Then I verify search returns OfferId for date "<day_offset>" days from today, search time "<time1>"
      And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time2>"
      And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time3>"
      And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time4>"
      And I verify search returns No offerId for date "<day_offset>" days from today, search time "<time5>"


 @Region-EU
    Scenarios: search for a non POP restaurant - without passing POPFlag
      | domain  | RID             | day_offset |time     |  offer_flag |  time1 |  time2 | time3 | time4 | time5 |
      | .co.uk  | (COUK-FRN-RID)  | 2          | 00:15  |    true      |  23:45 |  00:00 | 00:15 | 01:00 | 01:15 |







