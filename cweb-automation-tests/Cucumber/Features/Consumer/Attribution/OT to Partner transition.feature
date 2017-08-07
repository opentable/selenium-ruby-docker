@Team-Infra
@Web-bat-tier-1
Feature: Anonymous user makes a Reservation using metromix.opentable.com Site and Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution-OT-To-Partner-Make

  Scenario Outline:  Anonymous User access metromix.opentable.com site and makes a reso, verify points and attribution values
  Points = 100, BillingType = OTReso, PrimarySourceType = None
  Manual Case(s): Anonymous OT Path - Make

    Given I set test domain to "<domain>"
    And I navigate to url "<start_from>"
    Then I select restaurant "<rest_name>"
    And I click "Find a Table"
    And I navigate to url "<Partner_Site>"
    And I set reservation date to "<days_fwd>" days from today
    Then I select restaurant "<rest_name>"
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "OTReso"
    Then I verify Attribution "PrimarySourceType" equal to "None"
    Then I verify Attribution "ResPoints" equal to "100"



  @Region-NA @Domain-COM
  Scenarios:
    | domain | start_from     | Partner_Site                                 | rest_name       | days_fwd | party_sz | time    | database         | login               |
    | .com   | start.aspx?m=1 | http://metromix.opentable.com/start.aspx?m=1 | (COM-POP2-Name) | 2        | 2 people | 5:00 PM | webdb-na-primary | automation/aut0m8er |