@Avail-Service-offer
Feature: Search API  - returns offerid as per Offer schedule
Background:


Scenario Outline: Search API  - returns offerid as per Offer schedule
     RID - 91506 has Offers schedule 13:00 to 14:45

     Given I set test domain to "<domain>"
     When I call search API using rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
     Then I verify search returns No offerId for date "<day_offset>" days from today, search time "<time1>"
     And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time2>"
     And I verify search returns OfferId for date "<day_offset>" days from today, search time "<time3>"
     And I verify search returns No offerId for date "<day_offset>" days from today, search time "<time4>"

@Region-EU
   Scenarios: search for a non POP restaurant - without passing POPFlag
   | domain | RID                | day_offset |time     |  offer_flag |  time1 | time2 | time3 | time4 |
   | .co.uk | (COUK-Mobile-RID)  | 3          |  13:00  |    true     |  12:45 | 13:00 | 14:45 | 15:00 |











