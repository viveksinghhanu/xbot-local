from behave import given, when, then
from os import system
from xbot.vpcx.Lambdax import *


@given(u'The lambda function is configured to have "0" versions')
def step_impl(context):
    pass


@given(u'All versions of the lambda function are configured to have cross account permissions')
def step_impl(context):
    cross_account_cmd = f'aws lambda add-permission --function-name {context.lambda_function_id} ' \
        '--action lambda:InvokeFunction --statement-id s3-account --principal ' \
        's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 120752799804 ' \
        '--output text'
    os.system(cross_account_cmd)
    if list_cross_account_permission_sids(get_policy(context.lambda_function_id)):
        print(list_cross_account_permission_sids(get_policy(context.lambda_function_id)))
        pass


@given(u'Resource with resource id in context attribute "lambda_function_id" is set as target of enforcement test')
def step_impl(context):
    pass


@when(u'Enforcement Test '
      u'"xbot.vpcx.assurance.projectregionfunction.ProjectRegionFunctionEnforcementTest.test_permissions_'
      u'are_not_cross_account" runs')
def step_impl(context):
    system(r'python -m unittest xbot\vpcx\assurance\projectlambdafunction.py')
    pass


@then(u'No version of the lambda function has any cross account permissions')
def step_impl(context):
    pass


@given(u'The lambda function is configured to have "1" versions')
def step_impl(context):
    # existing lambda -> add a version
    pass


@given(u'The lambda function is configured to have "3" versions')
def step_impl(context):
    # existing lambda -> add 3 version
    pass