from behave import given, then
from xbot.vpcx import elb

''' 
Below are the Steps for the Scenario: Enforce to enable cross zone for elastic load balancer by enforcement test 
'''


@given('The elastic load balancer is configured to have cross zone disabled')
def step_impl(context):
    assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == False


@given('Resource with resource id in context attribute "elb_id" is set as target of enforcement test')
def step_impl(context):
    pass


@then('The elastic load balancer has cross zone enabled')
def step_impl(context):
    assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == True

''' 
Below are the Steps for the Scenario: cross zone for elastic load balancer is enabled
'''


@given('The elastic load balancer is configured to have cross zone enabled')
def step_impl(context):
    assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == True


# @then('enforcement test "xbot.vpcx.assurance.projectregionelb.ProjectRegionElbEnforcementTest.test_cross_zone_enabled" takes no action')
# def step_impl(context):
#     assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == True


''' 
Below are the Steps for the Scenario: Enforce to enable logging for elastic load balancer by enforcement test 
'''


@given('The elastic load balancer is configured to have logging disabled')
def step_impl(context):
    assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == False


@then('The elastic load balancer has logging enabled')
def step_impl(context):
    assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == True


''' 
Below are the Steps for the Scenario: Logging is enabled for elastic load balancer 
'''


@given('The elastic load balancer is configured to have logging enabled')
def step_impl(context):
    assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == True


# @then('enforcement test "xbot.vpcx.assurance.projectregionelb.ProjectRegionElbEnforcementTest.test_logging_enabled" takes no action')
# def step_impl(context):
#     assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == True
