from behave import given, when, then
import random
import time
import os
from xbot.vpcx.Lambdax import *


# @given(u'The lambda function is configured to have {num_versions} versions')
# def step_impl(context, num_versions):
#     if num_versions == '0' and context.lambda_function_id:
#         pass
#
#     elif num_versions == '1' or num_versions == '3':
#         update_lambda_function_and_add_cross_account_permissions(context.lambda_function_id)*num_versions
#         response = list_versions(context.lambda_function_id)
#         for key, value in response.items():
#           if key != '$LATEST':
#             Cross_Account_cmd = f"aws lambda add-permission --function-name {value['FunctionArn']} " \
#                 f'--action lambda:InvokeFunction --statement-id s3-account{random.randint(1, 100)} --principal ' \
#                 's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 420752799804 ' \
#                 '--output text'
#             os.system(Cross_Account_cmd)
#         if len(list_versions(context.lambda_function_id).keys()) > 0:
#             pass

@given(u'The lambda function is configured to have "0" versions')
def step_impl(context):
    if context.lambda_function_id:
        pass


@given(u'The lambda function is configured to have "1" versions')
def step_impl(context):
    update_lambda_function_and_add_cross_account_permissions(context.lambda_function_id)
    response = list_versions(context.lambda_function_id)
    for key, value in response.items():
        if key != '$LATEST':
            Cross_Account_cmd = f"aws lambda add-permission --function-name {value['FunctionArn']} " \
                f'--action lambda:InvokeFunction --statement-id s3-account{random.randint(1, 100)} --principal ' \
                's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 420752799804 ' \
                '--output text'
            os.system(Cross_Account_cmd)

    if len(list_versions(context.lambda_function_id).keys()) > 0:
        pass


@given(u'The lambda function is configured to have "3" versions')
def step_impl(context):
    update_lambda_function_and_add_cross_account_permissions(context.lambda_function_id)
    update_lambda_function_and_add_cross_account_permissions(context.lambda_function_id)
    update_lambda_function_and_add_cross_account_permissions(context.lambda_function_id)
    response = list_versions(context.lambda_function_id)
    for key, value in response.items():
        if key != '$LATEST':
            Cross_Account_cmd = f"aws lambda add-permission --function-name {value['FunctionArn']} " \
                f'--action lambda:InvokeFunction --statement-id s3-account{random.randint(1, 100)} --principal ' \
                's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 420752799804 ' \
                '--output text'
            os.system(Cross_Account_cmd)
    if len(list_versions(context.lambda_function_id).keys()) > 0:
        pass


@given(u'All versions of the lambda function are configured to have cross account permissions')
def step_impl(context):
    pass
    # TODO: Check the execution of above by checking cross account permissions of each version of function.


# @given(u'Resource with resource id in context attribute "lambda_function_id" is set as target of enforcement test')
# def step_impl(context):
#     pass
#     # TODO: Check the context attribute and how to implement this.


@then(u'No version of the lambda function has any cross account permissions')
def step_impl(context):
    pass
    # TODO: Again Run list cross account permission command