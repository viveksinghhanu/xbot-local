# BEFORE_ALL
  # setup xbot credentials from config settings file
  # context.target_account = <target account for test resources from config settings file>
@fixture.resource_group
  # create resource group in context.target_account
  # AWAIT resource group deployment
  # context.resource_group_id = <id of the newly created resource group>
@fixture.lambda_function
  # create a lambda function resource within the resource group pointed at by context.resource_group_id
  # AWAIT lambda function deployment
  # context.lambda_function_id = <id of the newly created lambda function>
Feature: Gxp Lambda

Scenario Outline: The lambda function with cross account permissions remediated by enforcement test
   Given The lambda function is configured to have "<num_versions>" versions
    # retrieve the lambda function resource configuration from cloud
    # reconfigure the lambda function to have num_versions versions
    # put the new lambda function configuration on the cloud
    # AWAIT new lambda function configuration
     And All versions of the lambda function are configured to have cross account permissions
    # retrieve the lambda function resource configuration from cloud
    # configure all available versions of the lambda function to have cross account permissions
    # put the new lambda function configuration on the cloud
    # AWAIT new lambda function configuration
     And Resource with resource id in context attribute "lambda_function_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.lambda_function_id
    When Enforcement Test "xbot.vpcx.assurance.projectregionfunction.ProjectRegionFunctionEnforcementTest.test_permissions_are_not_cross_account" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
    Then No version of the lambda function has any cross account permissions
    # RETRY LOOP, SLEEP 5 SECS, REPEAT 10 TIMES, FAIL IF GET TO END OF LOOP
    #   retrieve the lambda function resource configuration from cloud
    #   if none of the available versions of the lambda function have cross account permissions
    #      success, break out of the loop

 Examples: Different versions
   | num_versions |
   | 0            |
   | 1            |
   | 3            |

Scenario Outline: The lambda function without cross account permissions is reported as not triggering an action by enforcement test
   Given The lambda function is configured to have "<num_versions>" versions
    # retrieve the lambda function resource configuration from cloud
    # reconfigure the lambda function to have num_versions versions
    # put the new lambda function configuration on the cloud
    # AWAIT new lambda function configuration
     And All versions of the lambda function are configured to not have cross account permissions
    # retrieve the lambda function resource configuration from cloud
    # configure all available versions of the lambda function to not have any cross account permissions
    # put the new lambda function configuration on the cloud
    # AWAIT new lambda function configuration
     And Resource with resource id in context attribute "lambda_function_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.lambda_function_id
    When Enforcement Test "xbot.vpcx.assurance.projectregionfunction.ProjectRegionFunctionEnforcementTest.enforce_permissions_are_not_cross_account" runs
    # execute the configured enforcement test CLI
    # context.enforcement_test_output = <the output of the enforcement test CLI>
    Then Enforcement Test responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output
     And No version of the lambda function has any cross account permissions
    # RETRY LOOP, SLEEP 5 SECS, REPEAT 10 TIMES, FAIL IF GET TO END OF LOOP
    #   retrieve the lambda function resource configuration from cloud
    #   if none of the available versions of the lambda function have cross account permissions
    #      success, break out of the loop

 Examples: Different number of versions
   | num_versions |
   | 0            |
   | 1            |
   | 3            |

  # CLEANUP @fixture.lambda_function
  #   context.lambda_function_id = None

  # CLEANUP @fixture.resource_group
  #   delete resource group pointed at by context.resource_group_id
  #   context.resource_group_id = None
