@Web-bat-tier-1
@PopReservation


Feature: [DIP Reservation Make - From DIP Landing Page]

  Background:
  # Add setup steps to run before each Scenario
    Then I start with a new browser

  @DIP-reservation-make-from-dip-landing-page
  Scenario Outline: Regular registered user makes DIP Reservation from Dip landing page

    Given I set test domain to "<domain>"
    And I have registered regular user with random email
    Then I login as registered user
    Then I navigate to url "<dip_landingpage>"
    And I set reservation date to "<days_fwd>" days from today
    And I set party size to "<party_sz>"
    And I set reservation time to "<time>"
    And I click "Find a Table"
    And I click any POP time slot for any restaurant
    And I fill in "Phone" with "415-555-6565"
    And I should see text "<points_text>" in page source
    And I complete reservation
    When I get reservation anomalies report from CHARM
    Then I verify reservation Anomalies is ""
    Then I verify reservation BillingType is "DIPReso"
    Then I verify reservation ResPoints is "1000"
    Then I verify reservation ZeroReason is "<zero_reason>"
    Then I verify reservation BillableSize is "<party_size>"
    Then I verify reservation PartnerID is "<partner_id>"
    And I cancel reservation

  @Region-NA @Domain-COM
  Scenarios:
    | domain | dip_landingpage    | days_fwd | party_sz | time    |  zero_reason | party_size | partner_id |                           points_text                                    |
    | .com   | diprogram.aspx?m=4 | 2       | 2 people | 6:00 PM  |              | 2          | 1          | You will earn <span class="points-value">1,000</span> points upon dining |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain | dip_landingpage     | days_fwd | party_sz | time  |  zero_reason | party_size | partner_id |                              points_text                                   |
    | .co.uk | diprogram.aspx?m=72 |  3       | 2 people | 17:00 |             | 2          | 1           | You will earn <span class="points-value">1,000</span> points upon dining   |