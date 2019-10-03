fixture.aurora_cwlogs
Feature: CloudWatch logs for RDS aurora
    Scenario: Enforce to configure cloudwatch for RDS aurora lambda audit logs retention
        Given Cwlogs is configured to have 70 days retention period for aurora lambda
        And Resource with resource id in context attribute "aurora_cwlogs_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_lambda_cwlogs_retention" runs
        Then Cwlogs retention period is configured for 90 days for aurora lambda
    #positive
    Scenario: Test cloudwatch for RDS aurora lambda audit logs retention
        Given Cwlogs is configured to have 90 days retention period for aurora lambda
        And Resource with resource id in context attribute "aurora_cwlogs_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_lambda_cwlogs_retention" runs
        Then Enforcement Test responds with a status of "No action taken"
        And Cwlogs retention period is configured for 90 days for aurora lambda
