@Avail-Service-offer
Feature: Search API multi day search - returns offersid for mutiday as per Offer schedule
Background:


Scenario Outline: Search API multi day search - returns offersid for mutiday as per Offer schedule
     RID - 91506 has 2 offers with Offers schedule 13:00 to 14:45 everyday

     Given I set test domain to "<domain>"
     When I call search API using rid "<RID>" search date "<no>" days from today for multiday "<multi_days>" search time "<time>" with IncludeOffer "<offer_flag>"
     Then I verify search returns OfferId for date "3" days from today, search time "<time>"
     Then I verify search returns OfferId for date "4" days from today, search time "<time>"
     Then I verify search returns OfferId for date "5" days from today, search time "<time>"
@Region-EU
   Scenarios:
   | domain | RID                | no | time     |  offer_flag  |  multi_days |
   | .co.uk | (COUK-Mobile-RID)  | 3  |  14:00   |    true      |    2        |










