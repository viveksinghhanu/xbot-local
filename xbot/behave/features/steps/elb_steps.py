"""

Module containing BDD tests for Feature: Gxp ELB

"""

from behave import given, then
from xbot.vpcx import elb


@given('The elastic load balancer is configured to have cross zone disabled')
def step_impl(context):
    assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == False

#
# @given('Resource with resource id in context attribute "elb_id" is set as target of enforcement test')
# def step_impl(context):
#     pass


@then('The elastic load balancer has cross zone enabled')
def step_impl(context):
    assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == True

'''
Below are the Steps for the Scenario: cross zone for elastic load balancer is enabled
'''


@given('The elastic load balancer is configured to have cross zone enabled')
def step_impl(context):
    assert elb.get_cross_zone_enabled(context.account_id, context.access_key, context.elb_name) == True


@given('The elastic load balancer is configured to have logging disabled')
def step_impl(context):
    assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == False


@then('The elastic load balancer has logging enabled')
def step_impl(context):
    assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == True


@given('The elastic load balancer is configured to have logging enabled')
def step_impl(context):
    assert elb.logging_enabled(context.account_id, context.access_key, context.elb_name) == True
