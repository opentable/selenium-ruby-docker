Feature: Access AvailabilityService status page and check page content

  Background:


Scenario Outline:  Access AvailabilityService status page and check page content ( Service Name)
  When I navigate to url "http://<host_port>/"
  Then I should be able to view source and find text "ServiceName" in the html for the "label" tag
  And I should be able to view source and find text "<service_name>" in the html for the "span" tag





@Region-NA @Domain-COM
Scenarios:
  |  host_port        |  service_name |
  | int-na-svc:2604   |  AvailabilityService   |

