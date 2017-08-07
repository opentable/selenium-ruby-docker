@Avail-Service
@avail-service-CreditCardAllDayRule

Feature:  Qualified Search brings availabiliy with CCRequiredflag true if search day is set as CC day


Scenario Outline: Search brings availabiliy with CCRequiredflag true if search day is set as CC day

    Given I set CC day for "<cc_day_offset_from_today>" days from today for test restaurant "<RID>"
    When I call Search API for search day "<search_day_offset>" days from today
    Then I verify search brings Availability with CreditCardRequired flag "<cc_flag_value>"

@Region-NA @incomplete
   Scenarios: search for CC day
   | RID                     | cc_day_offset_from_today |search_day_offset  | cc_flag_value |
   | (COM-SIMSearch-RID)     | 2                        |   2               | true          |

@Region-NA @incomplete
   Scenarios: search for non CC day
   | RID                     | cc_day_offset_from_today |search_day_offset  | cc_flag_value |
   | (COM-SIMSearch-RID)     | 2                        |   1               | false         |
@Region-NA @incomplete
   Scenarios: search for non CC day
   | RID                     | cc_day_offset_from_today |search_day_offset  | cc_flag_value |
   | (COM-SIMSearch-RID)     | 2                        |   3               | false          |













