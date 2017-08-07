@Team-Infra
@Web-bat-tier-1
Feature: Anonymous user makes a DIP reso, Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser
  @Attribution

  @Attribution-OT-DIP-Make

  Scenario Outline:   Anonymous User access OT Dip Landing page Then performs a single rest search from start page
  user gets Dip slots completes Reso, Verify Attribution values
  Points = 1000, BillingType = DIPReso, PrimarySourceType = None
  Manual Case(s): Anonymous OT DIP - Make

    Given I set test domain to "<domain>"
    And  I navigate to url "<Dip_Page>"
    Then I select restaurant "<rest_name>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "DIPReso"
    Then I verify Attribution "PrimarySourceType" equal to "None"
    Then I verify Attribution "ResPoints" equal to "1000"



  @Region-EU    @Domain-CO.UK
  Scenarios:
    | domain | Dip_Page           | rest_name        | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | diprogram.aspx?m=1 | (COUK-POP2-Name) |    2     | 2 people | 22:00 | webdb-eu-primary | automation/aut0m8er |

  @Region-NA @Domain-COM
  Scenarios:
    | domain | Dip_Page           | rest_name       | days_fwd | party_sz | time    | database         | login               |
    | .com   | diprogram.aspx?m=1 | (COM-POP1-Name) |    2     | 2 people | 9:30 PM | webdb-na-primary | automation/aut0m8er |