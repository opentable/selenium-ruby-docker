@Team-Infra
@Web-bat-tier-1
Feature: User Access Multi RID ISM. makes Reso in first rest then second and Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser
  @Attribution

  @Attribution-ISM-multiRID-Make

  Scenario Outline:  User visits Restaurants site, site uses Multi RID ISM , user makes a reservation in RID1 then RID 2 and
  Verify points and attribution values,  Points = 0 ( Restref point suppressed), BillingType = RestRefReso, PrimarySourceType = RestRef
  Manual Case : Attribution - RestRef Multi RID ISM Reso


    Given I set test domain to "<domain>"
    And I navigate to url "<ISM url>"
    And I select "Restaurant" item "<rest_name_rid1>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RestRef"
    Then I verify Attribution "ResPoints" equal to "0"
    And I navigate to url "<ISM url>"
    And I select "Restaurant" item "<rest_name_rid2>"
    And I set reservation date to "3" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RestRef"
    Then I verify Attribution "ResPoints" equal to "0"


  @Region-NA @Domain-COM
  Scenarios:
    | domain | ISM url                                                                                | rest_name_rid1  | rest_name_rid2          | days_fwd | party_sz | time    | database         | login               |
    | .com   | http://www.opentable.com/ism/singlerest.aspx?rid=(COM-POP2-RID),(COM-AlwaysOnline-RID) | (COM-POP2-Name) | (COM-AlwaysOnline-Name) | 2        | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er |

#  @Region-EU @Domain-CO.UK
#  Scenarios:
#    | domain | ISM url                                                                                    | rest_name_rid1   | rest_name_rid2           | days_fwd | party_sz | time  | database         | login               |
#    | .co.uk | http://www.opentable.co.uk/ism/singlerest.aspx?rid=(COUK-POP2-RID),(COUK-AlwaysOnline-RID) | (COUK-POP2-Name) | (COUK-AlwaysOnline-Name) | 1        | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |
