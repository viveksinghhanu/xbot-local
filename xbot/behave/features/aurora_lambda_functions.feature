@fixture.s3_bucket
@fixture.aurora_audit_lambda_function
Feature: Lambda functions for aurora
    Scenario: Enforce to create RDS aurora audit lambda function
        Given The lambda function is not configured for aurora audit
        And And Resource with resource id in context attribute "aurora_audit_lambda_function_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_lambda_function" runs
        Then The RDS aurora audit lambda function is configured
    #positive
    Scenario: Test to create RDS aurora lambda function
        Given The lambda function is configured for aurora audit
        And And Resource with resource id in context attribute "aurora_audit_lambda_function_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_lambda_function" runs
        Then Enforcement Test responds with a status of "No action taken"
        And The RDS aurora audit lambda function is configured

    Scenario: Enforce to have invoke permission to RDS aurora lambda function
        Given The aurora audit lambda function is configured not to have invoke permission
        And And Resource with resource id in context attribute "aurora_audit_lambda_function_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_cwlogs_invoke_lambda_function" runs
        Then The aurora audit lambda function is configured with invoke permission
    #positive
    Scenario: Test to have invoke permission to RDS aurora lambda function
        Given The aurora audit lambda function is configured to have invoke permission
        And And Resource with resource id in context attribute "aurora_audit_lambda_function_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_cwlogs_invoke_lambda_function" runs
        Then Enforcement Test responds with a status of "No action taken"
        And The aurora audit lambda function is configured with invoke permission

    Scenario: Enforce to have subscription filter to RDS aurora lambda function
        Given The aurora audit lambda function is configured not to have subscription filter
        And And Resource with resource id in context attribute "aurora_audit_lambda_function_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_cwlogs_lambda_subscription_filters" runs
        Then The aurora audit lambda function is configured with subscription filter
    #positive
    Scenario: Test to have subscription filter to RDS aurora lambda function
        Given The aurora audit lambda function is configured to have subscription filter
        And And Resource with resource id in context attribute "aurora_audit_lambda_function_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_cwlogs_lambda_subscription_filters" runs
        Then Enforcement Test responds with a status of "No action taken"
        And The aurora audit lambda function is configured with subscription filter


