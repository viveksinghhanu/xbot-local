
#@fixture.resource_group

@fixture.elb
@fixture.s3

Feature: Gxp ELB
  Scenario: Enforce to enable cross zone for elastic load balancer by enforcement test
    Given The elastic load balancer is configured to have cross zone disabled
    And Resource with resource id in context attribute "elb_id" is set as target of enforcement test
    When enforcement test "xbot.vpcx.assurance.projectregionelb.test_cross_zone_enabled" runs
    Then The elastic load balancer has cross zone enabled

  #positive scenario
  Scenario: cross zone for elastic load balancer is enabled
    Given The elastic load balancer is configured to have cross zone enabled
    And Resource with resource id in context attribute "elb_id" is set as target of enforcement test
    When enforcement test "xbot.vpcx.assurance.projectregionelb.test_cross_zone_enabled" runs
    Then Enforcement Test responds with a status of "No action taken"

  Scenario: Enforce to enable logging for elastic load balancer by enforcement test
    Given The elastic load balancer is configured to have logging disabled
    And Resource with resource id in context attribute "elb_id" is set as target of enforcement test
    When enforcement test "xbot.vpcx.assurance.projectregionelb.test_logging_enabled" runs
    Then The elastic load balancer has logging enabled

  #positive Scenario
  Scenario: Logging is enabled for elastic load balancer
    Given The elastic load balancer is configured to have logging enabled
    And Resource with resource id in context attribute "elb_id" is set as target of enforcement test
    When enforcement test "xbot.vpcx.assurance.projectregionelb.test_logging_enabled" runs
    Then Enforcement Test responds with a status of "No action taken"

