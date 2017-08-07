@Reservations
@ReservationAPI
@Web-bat-tier-0
@Team-WarMonkeys

Feature: Make and cancel reservations on different restaurant types using API calls

  @api-make-cancel
  Scenario Outline: Registered user makes and cancel reservations on different restaurant types using API calls

    Given I am an existing "registered" user with "no" loginname and "<email>" email and have upcoming reservation in "<days_fwd>" at restaurant "<rest_rid>" in "<domain>"
    Then I modify the reservation to "<change_days>" using api
    Then I cancel my reservation using api

##################################################################################################################################################
##Connect 2 restaurants below
  @Region-NA @Domain-COM
  Scenarios:
    | domain |     rest_rid       | email                  | days_fwd | change_days |
    | .com   | (COM-Connect2-RID) | otprodtester@gmail.com |   3      |      4      |

  @Region-NA @Domain-COM.MX
  Scenarios:
    | domain  |     rest_rid      | email                    | days_fwd | change_days |
    | .com.mx | (MX-Connect2-RID) | otprodtestermx@gmail.com |   3      |      4      |

  @Region-EU @Domain-CO.UK
  Scenarios:
    | domain |     rest_rid        | email                    | days_fwd | change_days |
    | .co.uk | (COUK-Connect2-RID) | otprodtesteruk@gmail.com |   3      |      4      |

  @Region-EU @Domain-DE
  Scenarios:
    | domain |     rest_rid      | email                    | days_fwd | change_days |
    | .de    | (DE-Connect2-RID) | otprodtesterde@gmail.com |   3      |      4      |

  @Region-Asia @Domain-JP
  Scenarios:
    | domain |     rest_rid      | email                    | days_fwd | change_days |
    | .jp    | (JP-Connect2-RID) | otprodtesterjp@gmail.com |   3      |      4      |

  @Region-EU @Domain-IE
  Scenarios:
    | domain |     rest_rid      | email                    | days_fwd | change_days |
    | .ie    | (IE-Connect2-RID) | otprodtesterie@gmail.com |   3      |      4      |

  @Region-Asia @Domain-AU
  Scenarios:
    | domain  |     rest_rid      | email                    | days_fwd | change_days |
    | .com.au | (AU-Connect2-RID) | otprodtesterau@gmail.com |    3     |     4       |

###################################################################################################################################################
##ERB restaurants below
  @Region-NA @Domain-COM @incomplete
  Scenarios:
    | domain |     rest_rid            | email                  | days_fwd | change_days |
    | .com   | (COM-CWAutoTestERB-RID) | otprodtester@gmail.com |   3      |      4      |

  @Region-NA @Domain-COM.MX  @incomplete
  Scenarios:
    | domain  |       rest_rid         | email                    | days_fwd | change_days |
    | .com.mx | (MX-CWAutoTestERB-RID) | otprodtestermx@gmail.com |   3      |      4      |

  @Region-EU @Domain-CO.UK  @incomplete
  Scenarios:
    | domain |        rest_rid          | email                    | days_fwd | change_days |
    | .co.uk | (COUK-CWAutoTestERB-RID) | otprodtesteruk@gmail.com |   3      |      4      |

  @Region-EU @Domain-DE  @incomplete
  Scenarios:
    | domain |        rest_rid        | email                    | days_fwd | change_days |
    | .de    | (DE-CWAutoTestERB-RID) | otprodtesterde@gmail.com |   3      |      4      |

  @Region-Asia @Domain-JP  @incomplete
  Scenarios:
    | domain |        rest_rid        | email                    | days_fwd | change_days |
    | .jp    | (JP-CWAutoTestERB-RID) | otprodtesterjp@gmail.com |   3      |      4      |

   ###################################################################################################################################################
   ##Restaurant API restaurants below
   ## No availability
  @Region-Asia @Domain-AU @incomplete
  Scenarios:
    | domain  |     rest_rid         | email                    | days_fwd | change_days |
    | .com.au | (AU-RestApiRest-RID) | otprodtesterau@gmail.com |    3     |     4       |