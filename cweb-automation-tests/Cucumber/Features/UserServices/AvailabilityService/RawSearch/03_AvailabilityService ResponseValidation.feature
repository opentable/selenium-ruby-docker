Feature: Availability Service returns code 200 on success. Verify response block

Background:

  @Avail-Service-rawsearch

Scenario Outline: Availability Service returns code 200 on success. Verify response block
     1. Call Availability raw search
     2. verify it returns code -200 for success
     3. verify response block is constructed as defined in specs
        a. Verify Echo back of start date, exact time, party size
        b. Verify Available must return Day object for each searched day using ForwardDays value
        c. Verify RIDset includes each RID (even if no availability) requested
        d. verify BackwardMinutes/ForwardMinutes boundary followed.

    Given I create post data in JSON for AvailabilityService using default values
    When I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"
    Then I verify Availability Search response block

@Region-NA
  Scenarios:
  | host         | port   | api                    |  res_code |
  | int-na-svc   |        | /availability/searchraw |  200      |


