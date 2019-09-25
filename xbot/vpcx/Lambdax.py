import boto3
import os
import pprint
import ast
import random
from xbot import config

client = boto3.client('lambda')


def list_functions():
    """
        Retrieve the list of lambda functions along with their attributes,
        such as runtime, description, and memory size.

        Args:
        info_or_id (str or dict): Project ID or info dictionary.
        region (str): Project's region.

        Returns:
        dict: Lambda function names as keys and their respective attributes
        as values. Empty dict if no functions or the connection to Lambda
        fails.

    """

    lambda_fns = client.list_functions()['Functions']

    # All functions are returned as a list of dictionaries, but for
    # easier handling, store all function information as a single
    # dictionary with the function names as keys.

    lambda_fns_dict = {function['FunctionName']: function for function in lambda_fns}
    # Remove redundant function name keys
    for fn_name in lambda_fns_dict.keys():
        lambda_fns_dict[fn_name].pop('FunctionName')

    return lambda_fns_dict


def get_policy(function_name, qualifier=None):
    """
      Retrieve the policy statements for a particular function. Initially,
      the policy statements are returned as a string, so we convert to a
      dictionary for easier handling.

      Args:
        function_name (str): Name of the lambda function
        qualifier (str, optional): Alias or version name of the given
          function. This is not the full ARN, but instead only the alias,
          e.g. my_alias, or version, e.g. $LATEST, 1. Default is None.

      Returns:
        list of dict: List of policy statements formatted as dictionaries.
          Empty list if client connection fails or the policy does not
          exit.

    """
    if qualifier:
        policy_string = client.get_policy(FunctionName=function_name, Qualifier=qualifier)
    else:
        policy_string = client.get_policy(FunctionName=function_name)

    # The policy statement is returned as a string, which makes it very
    # difficult to handle. Fortunately, it comes in perfect dictionary
    # form, so we can convert it and be on our way.
    formatted_policy = ast.literal_eval(policy_string['Policy'])
    policy_statements = formatted_policy.get('Statement')
    return policy_statements


'''
[{'Action': 'lambda:InvokeFunction',
  'Condition': {'ArnLike': {'AWS:SourceArn': 'arn:aws:s3:::my-bucket-1234'},
                'StringEquals': {'AWS:SourceAccount': '123456123456'}},
  'Effect': 'Allow',
  'Principal': {'Service': 's3.amazonaws.com'},
  'Resource': 'arn:aws:lambda:us-east-1:345365594618:function:Kunwar_LambdaFunction',
  'Sid': 's3-account'},
 {'Action': 'lambda:InvokeFunction',
  'Condition': {'ArnLike': {'AWS:SourceArn': 'arn:aws:execute-api:us-east-1:345365594618:2pqrip54tb/*/*/Kunwar_LambdaFunction'}},
  'Effect': 'Allow',
  'Principal': {'Service': 'apigateway.amazonaws.com'},
  'Resource': 'arn:aws:lambda:us-east-1:345365594618:function:Kunwar_LambdaFunction',
  'Sid': 'lambda-5b2b5efc-8ab6-47b5-8dd7-a32ea4f9c95a'}]'''


def list_cross_account_permission_sids(policy_statements):

    my_id = '345365594618'

    permissions_list = []
    for statement in policy_statements:
        # For any permissions that use an AWS account ID, it will always
        # be stored in Condition->StringEquals->AWS:SourceAccount. We also
        # need to check if the AWS account ID belongs to this project as
        # some types of permissions, e.g. S3, will list the account ID even
        # if the function belongs to the account.
        if 'AWS:SourceAccount' in statement.get('Condition', {})\
                                           .get('StringEquals', {}):
            source_account_id = (
                statement['Condition']['StringEquals']['AWS:SourceAccount'])
            # If we find an account ID, see if it's the same account

            if source_account_id != my_id:
                permissions_list.append(statement['Sid'])
    return permissions_list


def remove_permissions(function_name, statement_id, qualifier=None):

    """
        Remove a permission from a function's policy by its statement ID.
        Args:
            function_name (str): Name of the lambda function
            statement_id (str): Statement ID (SID) of permission to remove.
            qualifier : Value
        Returns:
            bool: True if permission is removed, False otherwise.

    """
    try:
        if qualifier:
            client.remove_permission(FunctionName=function_name,
                                     StatementId=statement_id, Qualifier=qualifier)
        else:
            client.remove_permission(FunctionName=function_name,
                                     StatementId=statement_id)
    except Exception as e:
        print(f"Failed to remove {statement_id} permission from {function_name}" + f"Error: {e}")
        return False
    print(f"Removed {statement_id} permission from {function_name} ")
    return True


def publish_version(function_name):
    response = client.publish_version(
        FunctionName=function_name
    )
    pprint.pprint(response)


def add_cross_account_permissions(function_name):
    cross_account_cmd = f'aws lambda add-permission --function-name {function_name} ' \
        '--action lambda:InvokeFunction --statement-id s3-account --principal ' \
        's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 120752799804 ' \
        '--output text'
    os.system(cross_account_cmd)
    print('Cross Account permissions are added for function - ' + function_name)


def list_aliases(function_name, version=None):
    """
        Retrieve the list of aliases for a lambda function along with their
        ARNs, description, and version.

    Args:
        function_name (str): Function to list aliases for.
        version (str, optional): Function version to list aliases for.
          Default is None.

    Returns:
        dict: Alias names as keys and their respective attributes as
          values. Empty dict if no aliases or the connection to Lambda
          fails.

    """
    if not client:
        print("Could not connect to Lambda")
        return {}

    # TODO Specifying a version currently results in no aliases being
    # returned, even if there are aliases for that version.
    try:
        if version:
            aliases = client.list_aliases(FunctionName=function_name, FunctionVersion=version)['Aliases']
        else:
            aliases = client.list_aliases(FunctionName=function_name)['Aliases']

            # All aliases are returned as a list of dictionaries, but for
            # easier handling, store all alias information as a single
            # dictionary with the alias names as keys.
            alias_dict = {alias['Name']:alias for alias in aliases}
            # Remove redundant alias name keys
            for alias_name in alias_dict.keys():
                alias_dict[alias_name].pop('Name')
            return alias_dict
    except Exception as error:
        print(error)
        return {}


def list_versions(function_name):
    """
        Retrieve the list of versions for a lambda function along with their
        attributes, such as runtime, description, and memory size.

    Args:
        info_or_id (str or dict): Project ID or info dictionary.
        region (str): Project's region.
        function_name (str): Function to list versions for.

    Returns:
        dict: Version names as keys and their respective attributes as
          values. Empty dict if no versions or the connection to Lambda
          fails.

    """
    if not client:
        print("Could not connect to Lambda")
        return {}
    try:
        versions = (client.list_versions_by_function(FunctionName=function_name)['Versions'])
        # All versions are returned as a list of dictionaries, but for
        # easier handling, store all version information as a single
        # dictionary with the version names as keys.
        versions_dict = {version['Version']:version for version in versions}
        # Remove redundant version name keys
        for version_name in versions_dict.keys():
            versions_dict[version_name].pop('Version')
        return versions_dict
    except Exception as error:
        print(error)
        return {}


def update_lambda_function_and_add_cross_account_permissions(function_name):
    """
    :param function_name: takes function name
    :return: Nothing, but in AWS it updates the description of a lambda function
    and helps us in publishing a new version
    """
    response = client.update_function_configuration(
        FunctionName=function_name,
        Description=f'Some Update {random.randint(1, 10000)}'
    )
    response = client.publish_version(
        FunctionName=function_name
    )
    updated_arn = response['FunctionArn']

    # Cross_Account_cmd = f'aws lambda add-permission --function-name {updated_arn} ' \
    #     f'--action lambda:InvokeFunction --statement-id s3-account{random.randint(2, 100)} --principal ' \
    #     's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 420752799804 ' \
    #     '--output text'
    # os.system(Cross_Account_cmd)


def delete_all_function():
    lambda_fns = client.list_functions()['Functions']
    for item in lambda_fns:
        print(item['FunctionName']+ ':is being deleted')
        client.delete_function(
                FunctionName=item['FunctionName'],
            )
    # pprint.pprint(lambda_fns)


def permissions_are_not_cross_account():
    """
    Assures that any lambda function, version does not have cross-account permissions (policies).
    Currently, these can only be added through the CLI.
    """
    # For any functions with cross account permissions, store the
    # function name as the key and list of statement IDs as the value.
    cross_functions = {}
    FunctionName = 'Sheep4'
    versions = list_versions(FunctionName)
    # Need to check for this function and its aliases and versions,
    # as each one have their own permissions.
    policy_statements = get_policy(FunctionName)
    # pprint.pprint(policy_statements)
    cross_account_permissions = (list_cross_account_permission_sids(policy_statements))
    # pprint.pprint(cross_account_permissions)
    if cross_account_permissions:
        cross_functions[FunctionName] = cross_account_permissions
    # pprint.pprint(cross_functions)

    # Build a list of qualifiers (versions) to get policies for.
    qualifiers = versions.keys()
    pprint.pprint(qualifiers)
    for qualifier in qualifiers:
        if qualifier != '$LATEST':
            print(qualifier)
            policy_statements = get_policy(FunctionName, qualifier)
            pprint.pprint(policy_statements)
            # cross_account_permissions = (
            #     list_cross_account_permission_sids(policy_statements))
            #
            # if cross_account_permissions:
            #     qualified_name = FunctionName + ":" + qualifier
            #     # Add qualifier to function name before storing
            #     cross_functions[qualified_name] = cross_account_permissions
    # pprint.pprint(cross_functions)
