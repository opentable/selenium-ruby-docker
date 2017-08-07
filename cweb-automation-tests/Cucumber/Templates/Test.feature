@Web-bat-tier-[add_tier_number]
# Example: @Web-bat-tier-[0,1,3]
# Example: @CHARM-bat-tier-[0,1,3]

Feature: [Enter name of manual test]

  Scenario Outline:

  Given I need to implement this feature file

  @Region-NA @Domain-COM @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-NA @Domain-COM.fr-CA @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-NA @Domain-COM.MX @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-NA @Domain-COM.MX.en-US @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-EU @Domain-DE @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-EU @Domain-DE.en-GB @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-EU @Domain-CO.UK @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-Asia @Domain-JP @incomplete
  Scenarios:
    | domain |
    | .com   |

  @Region-Asia @Domain-JP.en-GB @incomplete
  Scenarios:
    | domain |
    | .com   |
