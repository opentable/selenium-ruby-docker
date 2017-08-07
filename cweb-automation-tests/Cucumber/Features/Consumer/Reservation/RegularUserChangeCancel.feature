@Web-bat-tier-0
Feature:

  Scenario Outline: Regular user can change reservation from view page

   # Given I am a regular user have upcoming reservation in "<domain>"
    Given I am a regular user have upcoming reservation in restarant "<rid>" in "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    And I login and navigate to view page
    When I click on modify link on view page
    Then I should be navigated to change page

  @Domain-COM
  Scenarios:
    | domain |rid2 |rid  |
    | .com   |95149 |(COM-GuestCenterRest-RID) |

  @Domain-COUK
  Scenarios:
    | domain | rid2 | rid |
    | .co.uk |91506 |(COUK-GuestCenterRest-RID) |

  @Domain-JP
  Scenarios:
    | domain | rid2 |rid |
    | .jp    |18113 | (JP-GuestCenterRest-RID)|

  @Domain-JP
  Scenarios:
    | domain | rid2 | rid |
    | .jp/en-US |18113 |(JP-GuestCenterRest-RID)|


  @Domain-DE
  Scenarios:
    | domain | rid2 |rid |
    | .de    | 91638 |(DE-GuestCenterRest-RID)|

  @Domain-COMMX
  Scenarios:
    | domain  | rid2 |rid |
    | .com.mx |95146 |(MX-GuestCenterRest-RID) |


  Scenario Outline: Regular user can cancel reservation from view page

    #Given I am a regular user have upcoming reservation in "<domain>"
    Given I am a regular user have upcoming reservation in restarant "<rid>" in "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    And I login and navigate to view page
    When I click on cancel link on view page
    Then I should be navigated to cancel page
  @Domain-COM
  Scenarios:
    | domain |rid2 |rid  |
    | .com   |95149 |(COM-GuestCenterRest-RID) |

  @Domain-COUK
  Scenarios:
    | domain | rid2 | rid |
    | .co.uk |91506 |(COUK-GuestCenterRest-RID) |

  @Domain-JP
  Scenarios:
    | domain | rid2 |rid |
    | .jp    |18113 | (JP-GuestCenterRest-RID)|

  @Domain-JP
  Scenarios:
    | domain | rid2 | rid |
    | .jp/en-US |18113 |(JP-GuestCenterRest-RID)|


  @Domain-DE
  Scenarios:
    | domain | rid2 |rid |
    | .de    | 91638 |(DE-GuestCenterRest-RID)|

  @Domain-COMMX
  Scenarios:
    | domain  | rid2 |rid |
    | .com.mx |95146 |(MX-GuestCenterRest-RID) |

  Scenario Outline: Verify reservation parameters on the view page

    #Given I am a regular user have upcoming reservation in "<domain>"
    Given I am a regular user have upcoming reservation in restarant "<rid>" in "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    When I login and navigate to view page
    Then I verify reservation parameters date, time, party size and points on view page
    When I click on restaurant name
    Then I should be navigated to restaurant page

  @Domain-COM
  Scenarios:
    | domain |rid2 |rid  |
    | .com   |95149 |(COM-GuestCenterRest-RID) |



  Scenario Outline: Regular user make reservation and verify UI on the view page

    Given I am a regular user have upcoming reservation in restarant "<rid>" in "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    When I login and navigate to view page
    #Then I should see the restaurant static image
    And I should see the View larger map
    When I click on View Hours, Transportation and other Details
    Then I should be navigated to restaurant page

  @Domain-COM
  Scenarios:
    | domain |rid2 |rid  |
    | .com   |95149 |(COM-GuestCenterRest-RID) |

  @Domain-COUK
  Scenarios:
    | domain | rid2 | rid |
    | .co.uk |91506 |(COUK-GuestCenterRest-RID) |


  Scenario Outline: As a regular user I can make CC reservation on new details page


    Given I am regular user in domain "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    And I do search on "<credit_card_rest>" profile page for tomorrow for time "<time>" and party of "<ps>" and select a slot
    And I navigate to new details pci page and login on details
    When I fill in phone number, CC number "<card_number>" CVV "<cvv>" and exp date and complete the reservation
    Then I should be on view page
    And I should see credit card "<card_number>" last 4 digits and conf number on view page




  @Domain-COM
  Scenarios:

    | domain | credit_card_rest    | time    | ps | card_number      | cvv  |
    | .com   | (COM-CreditCard-RID)| 7:00 PM | 6  | 4111111111111111 | 123  |
    | .com   |(COM-CreditCard-RID) | 7:00 PM | 6  | 372358916473285  | 1234 |
    | .com   | (COM-CreditCard-RID)| 7:00 PM | 6  | 5523948602846385 | 333  |
    | .com   | (COM-CreditCard-RID)| 7:00 PM | 6  | 6011111111111117 | 543  |
    | .com   | (COM-CreditCard-RID)| 7:00 PM | 6  | 30569309025904   | 432  |
    | .com   | (COM-CreditCard-RID)| 7:00 PM | 6  | 3530111333300000 | 234  |



  @Domain-COUK
  Scenarios:
    | domain | credit_card_rest | time    | ps | card_number      | cvv  |
    | .co.uk | (COUK-CreditCard-RID) | 7:00 PM | 4  | 4111111111111111 | 123  |
    | .co.uk | (COUK-CreditCard-RID) | 7:00 PM | 4  | 372358916473285  | 1234 |
    | .co.uk | (COUK-CreditCard-RID) | 7:00 PM | 4  | 5523948602846385 | 333  |

  @Domain-DE
  Scenarios:
    | domain | credit_card_rest | time  | ps | card_number      | cvv  |
    | .de    | (DE-CreditCard-RID)           | 19:00 | 4  | 4111111111111111 | 123  |

  @Domain-COMMX
  Scenarios:
    | domain  | credit_card_rest | time  | ps | card_number      |cvv  |
    | .com.mx | (MX-CreditCard-RID)            | 19:00 | 4  | 4111111111111111 |123  |


  #DKrish Adding Successful Modification and cancellation of reservation..
  Scenario Outline: As a regular user I should be able to modify a credit card reservation that was done

    Given I start new browser with re-design cookie for domain "<domain>"
    And I am a regular user logged-in to  "<domain>" site
    And I do search on "<credit_card_rest>" profile page for nine days ahead for time "<time>" and party of "<ps>" and select a slot
    # DKrish - commenting below and adding the old step because it is cleaner and has no reference to CVV
    When I fill in phone number, CC number "<card_number>" CVV "<cvv>" and exp date and complete the reservation
  #  When I fill in phone number CC number "<card_number>" and exp date and complete the reservation
    Then I should be on view page
    When I modify reservation to number of days from today "2", at time "<time>", with party size "<ps>"
    Then I should be on view page


  @Domain-COM
  Scenarios:
    | domain | credit_card_rest | time    | ps | card_number      | cvv  |
    | .com   | (COM-CreditCard-RID)            | 7:00 PM | 6  | 4111111111111111 | 123  |

  @Domain-COUK
  Scenarios:
    | domain | credit_card_rest     | time    | ps | card_number      | cvv  |
    | .co.uk | (COUK-CreditCard-RID)| 19:00  | 4  | 4111111111111111 | 123  |
    | .co.uk | (COUK-CreditCard-RID) | 19:00  | 4  | 372358916473285  | 1234 |

  @Domain-DE
  Scenarios:
    | domain | credit_card_rest | time  | ps | card_number      |cvv |
    | .de    | (DE-CreditCard-RID)           | 19:00 | 4  | 4111111111111111 |123 |

  @Domain-COMMX
  Scenarios:
    | domain  | credit_card_rest | time  | ps | card_number      |
    | .com.mx |(MX-CreditCard-RID)        | 19:00 | 4  | 4111111111111111 |


  Scenario Outline: As a regular user I should be able to cancel a credit card reservation that was done

    Given I start new browser with re-design cookie for domain "<domain>"
    And I am a regular user logged-in to  "<domain>" site
    And I do search on "<credit_card_rest>" profile page for nine days ahead for time "<time>" and party of "<ps>" and select a slot
    When I fill in phone number, CC number "<card_number>" CVV "<cvv>" and exp date and complete the reservation
    Then I should be on view page
    When I click on cancel link on view page
    Then I should be navigated to cancel page

  @Domain-COM
  Scenarios:
    | domain | credit_card_rest | time    | ps | card_number      | cvv  |
    | .com   | (COM-CreditCard-RID)         | 7:00 PM | 4  | 5454545454545454 | 123  |

  @Domain-COUK
  Scenarios:
    | domain | credit_card_rest | time    | ps | card_number      | cvv  |
    | .co.uk | (COUK-CreditCard-RID)       | 19:00  | 4  | 4111111111111111 | 123  |

  @Domain-DE
  Scenarios:
    | domain | credit_card_rest | time  | ps | card_number      |cvv |
    | .de    | (DE-CreditCard-RID)         | 19:00 | 4  | 4111111111111111 |123 |

  @Domain-COMMX
  Scenarios:
    | domain  | credit_card_rest | time  | ps | card_number      |
    | .com.mx | (MX-CreditCard-RID)            | 19:00 | 4  | 4111111111111111 |


## DKrish adding test to convert a Non CC reservation to CC reservation by changing party size.
  Scenario Outline: As a regular user I should be able to convert non cc reso to cc reso

    Given I start new browser with re-design cookie for domain "<domain>"
    And I am a regular user logged-in to  "<domain>" site
    And I do search on "<credit_card_rest>" profile page for nine days ahead for time "<time>" and party of "<smallps>" and select a slot
    When I fill in phone number, and complete the reservation
    Then I should be on view page
    When I change reservation to number of days from today "2", at time "<time>", with party size "<ps>", and provide CC number "<card_number>" and exp date and complete the reservation
    Then I should be on view page
  @Domain-COM
  Scenarios:
    | domain | credit_card_rest | time    |smallps| ps | card_number    |
    | .com   | (COM-CreditCard-RID)         | 7:00 PM |2      | 4  | 5454545454545454 |

  @Domain-COUK
  Scenarios:
    | domain | credit_card_rest | time    | smallps|ps | card_number      |
    | .co.uk   | (COUK-CreditCard-RID)        | 19:00  | 2      |4  | 5454545454545454 |

  @Domain-DE
  Scenarios:
    | domain | credit_card_rest  | time  | smallps|ps | card_number      |
    | .de    | (DE-CreditCard-RID)          | 19:00 | 2      |4  | 5454545454545454 |

  @Domain-COMMX
  Scenarios:
    | domain  | credit_card_rest | time  | smallps|ps | card_number      |
    | .com.mx | (MX-CreditCard-RID)            | 19:00 | 2      |4  | 4111111111111111 |


   ####### DKrish adding negative TC scenario for CCs
  Scenario Outline: As a regular user I cannot make reservation with invalid or empty CC on new details page

    Given I am regular user in domain "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    And I do search on "<credit_card_rest>" profile page for tomorrow for time "<time>" and party of "<ps>" and select a slot
    And I navigate to new details pci page and login on details
    When I fill in phone number, InvalCC number "<invalcard_number>" and exp date and complete the reservation
    Then I should be on details pci page
    And I should see <invalErrortxt> on details pci page

# DKRISH ADDED invalid and empty card for .com, .co.uk and .de alone

  @Domain-COMMX
  Scenarios:
    | domain | credit_card_rest | time    | ps | invalcard_number |invalErrortxt |
    | .com.mx  |  (MX-CreditCard-RID)           | 7:00 PM | 4  | 8111111111111111 |La tarjeta de crédito ingresada no es válida. Asegúrese que el número y tipo de la tarjeta sean correctos.|
    | .com.mx  |  (MX-CreditCard-RID)           | 7:00 PM | 4  |                  |The credit card number is blank. Please provide a valid credit card.|
  @Domain-COM
  Scenarios:
    | domain | credit_card_rest | time    | ps | invalcard_number |invalErrortxt |
    | .com   | (COM-CreditCard-RID)            | 7:00 PM | 6  | 8111111111111111 |The credit card entered is not valid.  Please make sure the card number and card type are correct.|
    | .com   | (COM-CreditCard-RID)            | 7:00 PM | 6  |                  |The credit card number is blank. Please provide a valid credit card.|

  @Domain-COUK
  Scenarios:
    | domain | credit_card_rest | time    | ps | invalcard_number |invalErrortxt |
    | .co.uk   |  (COUK-CreditCard-RID)           | 7:00 PM | 4  | 8111111111111111 |The credit card entered is not valid. Please make sure the card number and card type are correct.|
    | .co.uk   |  (COUK-CreditCard-RID)           | 7:00 PM | 4  |                  |The credit card number is blank. Please provide a valid credit card.|

  @Domain-DE
  Scenarios:
    | domain | credit_card_rest | time    | ps | invalcard_number |invalErrortxt |
    | .de   |  (DE-CreditCard-RID)           | 7:00 PM | 4  | 8111111111111111 |Die eingegebene Kreditkarte ist ungültig. Vergewissern Sie sich, dass Kartennummer und Kartentyp richtig sind.|
    | .de   |  (DE-CreditCard-RID)           | 7:00 PM | 4  |                  |Bitte geben Sie eine Kreditkartennummer an.|




    ##Die eingegebene Kreditkarte ist ungültig. Vergewissern Sie sich, dass Kartennummer und Kartentyp richtig sind - invalid DE
  #Bitte geben Sie eine Kreditkartennummer an. - empty cc field.. Note that at this time the message is showing up in english.. Bug
### DKrish Negative Test for Expired card..
  Scenario Outline: As a regular user I cannot make reservation with expired year on new details page

    Given I am regular user in domain "<domain>"
    And I start new browser with re-design cookie for domain "<domain>"
    And I do search on "<credit_card_rest>" profile page for tomorrow for time "<time>" and party of "<ps>" and select a slot
    And I navigate to new details pci page and login on details
    When I fill in phone number, CC number "<card_number>" "<cvv>"and Expired date and complete the reservation
    Then I should be on details pci page
    And I should see <invalErrortxt> on details pci page

  @Domain-COM
  Scenarios:
    | domain | credit_card_rest | time    | ps | card_number      | cvv  | invalErrortxt |
    | .com   | (COM-CreditCard-RID)            | 7:00 PM | 6  | 4111111111111111 | 123  |The credit card entered is not valid. Please make sure the card number and card type are correct.|
    | .com   | (COM-CreditCard-RID)            | 7:00 PM | 6  | 372358916473285  | 1234 |The credit card entered is not valid. Please make sure the card number and card type are correct.|
