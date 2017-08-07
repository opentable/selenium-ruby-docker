@AvailService-BasicTest
@AvailService-production-test

Feature:  Service Availability service lbstatus check.

Background:

Scenario Outline:  Verify Availability service lbstatus API returns status as ON.

  Given I set test domain to "<domain>"
  When I call Search API lbstatus
  Then I verify response returns "<lb_status_on>"


@Region-NA
Scenarios:
 |  lb_status_on   |domain  |
 |  OTWEB_ON       |  .com  |

@Region-EU
Scenarios:
|  lb_status_on   |domain   |
|  OTWEB_ON       |  .co.uk |

@Region-Asia
Scenarios:
|  lb_status_on   |domain |
|  OTWEB_ON       |  .jp  |

