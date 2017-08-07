@Avail-Service-ERB
Feature: Availability Service - Time clipping should be applied on PAST time slots

Background:


Scenario Outline: search - Singe Day search - returns NO availability for PAST Time

    Given I setup test restaurant "<RID>"
    When I call search API using search day "<searchStartDayOffset>" days from today, search time "<searchTimeOffsetMinutes>" minutes from now
    Then I verify search brings no slot in Past time
    And I verify search brings "<no>" of slots in backward window

@Region-NA
  Scenarios: search single day - should not bring any PAST time slots
  | RID                     | searchStartDayOffset   | searchTimeOffsetMinutes   |  no |
  | (COM-ERB24hr-RID)       |                    0   |                       60  |  3  |


Scenario Outline: search - multi Day search - returns NO availability for PAST Time

    Given I setup test restaurant "<RID>"
    When I call Search API using search day "<searchDayOffset>", search days "<multi_days>" search time "<timeoffset>" from now
    Then I verify search brings no slot in Past time
    And I verify search brings "<no>" of slots in backward window
    And I verify TimeSlot clipping not applied to next day

@Region-NA
  Scenarios:  search multi day - should not bring any PAST time slots
  | RID                     | searchDayOffset   | timeoffset   |  no |  multi_days  |
  | (COM-ERB24hr-RID)       |             0     |         60   |  3  |  3           |

