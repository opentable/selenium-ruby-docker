Feature: Availability Service returns code 400 when bad data is passed.

@Avail-Service-rawsearch

Scenario Outline:  Availability Service returns code 400 when bad data is passed.

      When I create post data in JSON for AvailabilityService passing field "<field>" as "<value>"
      And I call JSON POST API "<api>" host "<host>" "<port>" and get response "<res_code>"


  @Region-NA
    Scenarios:  BadData Case: partysize -ve value.
    | host         | port   | api                      |  res_code | field      | value |
    | int-na-svc   |        | /availability/searchraw  |  400      | PartySize  | -2    |

   @Region-NA
    Scenarios:  BadData Case: RIDset : null
    | host         | port  | api                      |  res_code | field      | value |
    | int-na-svc   |        | /availability/searchraw |  400       | RID        |       |

  @Region-NA
    Scenarios:  BadData Case: start date not in ISO format
    | host         | port  | api                      |  res_code | field      | value            |
    | int-na-svc   |       | /availability/searchraw |  400      | StartDate  |  non-iso-format    |

  @Region-NA
      Scenarios:  BadData Case: searchTime not in ISO format
      | host         | port  | api                      |  res_code | field      | value    |
      | int-na-svc   |        | /availability/searchraw |  400       | ExactTime  | 7:00 PM  |

  @Region-NA
      Scenarios:   BadData Case: ForwardDays - -ve value
      | host         | port  | api                      |  res_code | field        | value |
      | int-na-svc   |       | /availability/searchraw |  400      | ForwardDays   | -2     |

  @Region-NA
      Scenarios: BadData Case: ForwardMinutes - -ve value
      | host         | port  | api                      |  res_code | field           | value |
      | int-na-svc   |        | /availability/searchraw |  400      | ForwardMinutes  | -120  |

  @Region-NA
      Scenarios: BadData Case: BackwardMinutes - -ve value
      | host         | port  | api                      |  res_code | field           | value |
      | int-na-svc   |       | /availability/searchraw |  400      | BackwardMinutes  | -120  |



