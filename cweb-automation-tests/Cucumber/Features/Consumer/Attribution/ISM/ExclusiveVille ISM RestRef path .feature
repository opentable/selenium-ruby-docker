@Team-Infra
@Web-bat-tier-0
@Web-bat-tier-1
Feature: User Access RestRef path ( ISM )ExlusiveVille Restaurant and makes Reso, Verify Attribution values

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @Attribution

  @Attribution-RestRef-Make

  Scenario Outline:  User visits Restaurants site, site uses ISM , user makes a reservation there
  Verify points and attribution values,  Points = 0 ( Restref point suppressed), BillingType = RestRefReso, PrimarySourceType = RestRef
  Manual Case : Attribution - RestRef ISM Reso

    Given I set test domain to "<domain>"
    And I navigate to url "<ISM url>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click Find a Table Button and fill in anonymous user info
    And I complete reservation
    Then I connect to database "<database>" as "<login>"
    Then I verify Attribution "BillingType" equal to "RestRefReso"
    Then I verify Attribution "PrimarySourceType" equal to "RestRef"
    Then I verify Attribution "ResPoints" equal to "0"


  #Commenting this test out as test rid is not configured correctly to redirect to https
#  @Region-NA @Domain-COM
#  Scenarios:
#    | domain | ISM url                                                              | days_fwd | party_sz | time    | database         | login               |
#    | .com   | http://www.opentable.com/ism/singlerest.aspx?rid=(COM-Exclusive-RID) |     2    | 2 people | 7:00 PM | webdb-na-primary | automation/aut0m8er |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | ISM url                                                                 | days_fwd | party_sz | time  | database         | login               |
    | .co.uk | http://www.opentable.co.uk/ism/singlerest.aspx?rid=(COUK-Exclusive-RID) | 1        | 2 people | 19:00 | webdb-eu-primary | automation/aut0m8er |