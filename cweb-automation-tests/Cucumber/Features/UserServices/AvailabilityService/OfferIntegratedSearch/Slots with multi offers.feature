@Avail-Service-offer
Feature: Search API  - returns multi offerida as per Offer schedule
Background:


Scenario Outline: Search API  - returns multi offerida as per Offer schedule
     RID - 91506 has 2 offers with Offers schedule 13:00 to 14:45

     Given I set test domain to "<domain>"
     When I call search API using rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
     Then I verify search returns multi offers for date "<day_offset>" days from today, search time "<time1>"


@Region-EU
   Scenarios:
   | domain | RID                | day_offset |time     |  offer_flag |  time1 |
   | .co.uk | (COUK-Mobile-RID)  | 3          |  14:00  |    true     |  14:00 |











