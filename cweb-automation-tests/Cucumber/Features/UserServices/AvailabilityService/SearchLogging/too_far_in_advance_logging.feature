@Avail-Service-logging
@avail-service-AdvanceBooking
Feature:  Testing SearchLogging - AdvanceBooking restricton

Background:

Scenario Outline: Testing SearchLogging - AdvanceBooking restricton

    Given I setup test restaurant "<RID>" with AdvanceBooking limit "<max_advance_option_id>"
    And I call flushlogger API then capture high watermark
    When I call search API using single rid "<RID>" for "<d>" days in the future
    And I call flushlogger
    Then I verify Status_AdvancedBookingRestriction "<v>" is logged for RID "<RID>"

@Region-NA
   Scenarios: (Note: max_advance_option_id = 10 translates to a 14 day limit)
   | RID                  |  max_advance_option_id | d  |   v  |
   | (COM-SIMSearch2-RID)  |  10                    | 60 |   1  |
@Region-NA
Scenarios: search within AdvanceBooking Restriction limit
  | RID                  |  max_advance_option_id | d  |   v  |
  | (COM-SIMSearch2-RID)  | 10                     | 8  |  0   |











