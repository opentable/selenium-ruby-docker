@Avail-Service-offer
@AvailService-production-test

Feature: Search API IncludeOffer flag test

Background:


Scenario Outline: Search API Request IncludeOffer flag = true - returns offerID

     Given I set test domain to "<domain>"
     When I call search API using rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
     Then I verify search returns OfferId for date "<day_offset>" days from today, search time "<time>"


@Region-EU
   Scenarios:
   | domain | RID                | day_offset |time     |  offer_flag |
   | .co.uk | (COUK-Offers-RID)  | 2          |  19:00  |    true     |


Scenario Outline: Search API Request IncludeOffer flag = false - returns NoofferID

      Given I set test domain to "<domain>"
      When I call search API using rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
      Then I verify search returns No offerId for date "<day_offset>" days from today, search time "<time>"


@Region-EU
   Scenarios:
   | domain | RID                | day_offset |time     |  offer_flag |
   | .co.uk | (COUK-Offers-RID)  | 2          |  19:00  |    false     |





