@Avail-Service
@avail-service-CreditCardPartySizeRule

Feature: Qualified Search brings availabiliy with CCRequiredflag true/false based on CCMinPS limit rule.

Background:


Scenario Outline: Qualified Search brings availabiliy with CCRequiredflag true when search is performed for PS => CCMinPS

     Given I set test restaurant "<RID>" Credit card required Min Party Size "<cc_min_ps>" limit
     When I call Search API using PS "<search_ps>"
     Then I verify search brings Availability with CreditCardRequired flag "<flag_value>"

@Region-NA @incomplete
   Scenarios: search with PS > CC_MinPSlimit
   | RID                     | cc_min_ps  | search_ps    |  flag_value |
   | (COM-SIMSearch-RID)     | 4          |  5           |  true       |

@Region-NA @incomplete
   Scenarios: search with PS = CC_MinPSlimit
   | RID                     | cc_min_ps  | search_ps    | flag_value |
   | (COM-SIMSearch-RID)     | 4          |  4           | true       |

 @Region-NA @incomplete
    Scenarios: search with PS < CC_MinPSlimit
    | RID                     | cc_min_ps  | search_ps    |  flag_value |
    | (COM-SIMSearch-RID)     | 4          |  3           |  false      |












