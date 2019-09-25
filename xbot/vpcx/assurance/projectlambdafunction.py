"""
Assurance module for Lambda functions.
"""
from xbot.vpcx.assurance import enforce, ParametrizedTestCase
from xbot.vpcx.Lambdax import *
from xbot import config


class ProjectRegionFunctionEnforcementTest(ParametrizedTestCase):
    def setUp(self):
        self.account_id = config.account_id
        self.FunctionName = config.FunctionName
        if not self.FunctionName:
            self.skipTest('Function not found.')
        # Get any aliases and versions for this function if they exist
        self.versions = list_versions(self.FunctionName)

    @enforce
    def test_permissions_are_not_cross_account(self):
        """
        Assures that any lambda function, version does not have cross-account permissions (policies).
        Currently, these can only be added through the CLI.
        """
        # For any functions with cross account permissions, store the
        # function name as the key and list of statement IDs as the value.
        self.cross_functions = {}
        # Need to check for this function and its aliases and versions,
        # as each one have their own permissions.

        qualifiers = self.versions.keys()
        if len(qualifiers) > 1:
            for qualifier in qualifiers:
                if qualifier != '$LATEST':
                    policy_statements = get_policy(self.FunctionName, qualifier=qualifier)
                    cross_account_permissions = (
                        list_cross_account_permission_sids(policy_statements))

                    if cross_account_permissions:
                        qualified_name = self.FunctionName + ":" + qualifier
                        # Add qualifier to function name before storing
                        self.cross_functions[qualified_name] = cross_account_permissions
        else:
            policy_statements = get_policy(self.FunctionName)
            cross_account_permissions = (list_cross_account_permission_sids(policy_statements))

            if cross_account_permissions:
                self.cross_functions[self.FunctionName] = cross_account_permissions


        self.assertEqual(self.cross_functions, {})

    def enforce_permissions_are_not_cross_account(self):
        """
        Remove any cross-account permissions (policies) from this function,
        including any permissions from its versions and aliases.

        """
        for function_name, sids in self.cross_functions.items():
            for sid in sids:
                # Check if it's a version
                if ":" in function_name:
                    qualifier = function_name.split(":")[1]
                    result = remove_permissions(function_name, sid, qualifier=qualifier)
                else:
                    result = remove_permissions(function_name, sid)
                if not result:
                    print("Failed to enforce removal")
                    return False
        return True


