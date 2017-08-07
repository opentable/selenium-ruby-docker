@Avail-Service-offer
Feature: Search APIIncludeOffer  - multi rid search

Background:


Scenario Outline: Search API Request IncludeOffer flag = true - returns offerID

     Given I set test domain to "<domain>"
     When I call search API using multi rid "<RID>" date "<day_offset>" days from today, search time "<time>" with IncludeOffer "<offer_flag>"
     Then I verify search returns OfferId for rid "<rid1>" date "<day_offset>" days from today, search time "<time>"
     Then I verify search returns OfferId for rid "<rid2>" date "<day_offset>" days from today, search time "<time>"

@Region-EU
   Scenarios: search for a non POP restaurant - without passing POPFlag
     | domain | RID                                | day_offset |time     |  offer_flag | rid1               |  rid2          |
     | .co.uk | (COUK-Connect-RID),(COUK-FRN-RID)  | 2          |  19:00  |    true     | (COUK-Connect-RID) | (COUK-FRN-RID) |










