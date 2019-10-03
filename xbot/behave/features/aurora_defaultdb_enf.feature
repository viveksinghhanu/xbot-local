@fixture.default_aurora_database
@fixture.custom_parameter_group
@fixture.aurora_database_extra_users
@fixture.aurora_database_sa_users
Feature: Aurora Database Management

TYPO -- s/perion/period, its in a few places
    Scenario: Enforce to have backup retention perion for aws aurora database.
REWORD, HERE AND ELSEWHERE WHERE RETENTION PERIOD IS MENTIONED
        Given RDS aurora is configured to have backup of 70 days retention period
        Given RDS aurora is configured to have backup retention period of 70 days
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_backup_retention_period" runs
        Then RDS aurora has backup of 90 days retention period
    #positive
    Scenario: Backup retention perion is configured for aws aurora database.
        Given RDS aurora is configured to have backup of 90 days retention period
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_backup_retention_period" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora has 90 days backup retention period

    Scenario: Enforce to have custom parameter groups to aws aurora database.
        Given RDS aurora is configured not to have custom parameter groups
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_has_custom_parameter_group" runs
        Then RDS aurora has custom parameter groups
    #positive
    Scenario: Test RDS aurora has custom parameter group.
        Given RDS aurora is configured to have custom parameter groups
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_has_custom_parameter_group" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora has custom parameter groups

    Scenario: Enforce audit log is enabled on RDS aurora instances.
        Given RDS aurora is configured to have audit log disabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_logging_enabled" runs
        Then RDS aurora audit log is enabled
    #positive
    Scenario: Test audit log is enabled on RDS aurora instances.
        Given RDS aurora is configured to have audit log enabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_logging_enabled" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora audit log is enabled

    Scenario: Enforce that no extra users are included in audits or users removed from audit.
        Given extra users are configured to include in audits
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_no_include_exclude_users" runs
        Then No extra users are included in audits
    #positive
    Scenario: Test that no extra users are included in audits or users removed from audit.
        Given extra users are not configured to include in audits
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_no_include_exclude_users" runs
        Then Enforcement Test responds with a status of "No action taken"
        And No extra users are included in audits

    Scenario: Enforce the IAM role is associated with RDS aurora instance.
        Given RDS aurora instance is configred not to have iam role
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_iam_role_association" runs
        Then RDS aurora instance has IAM role associated
    #positive
    Scenario: Test the IAM role is associated with RDS aurora instance.
        Given RDS aurora instance is configured with iam role
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_iam_role_association" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora instance has IAM role associated

    Scenario: Enforce RDS aurora SA user exists
        Given RDS aurora is configured not to have aurora SA user
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurorasa_user_exists" runs
        Then RDS aurora is configured to have aurora SA user
    #positive
    Scenario: Test RDS aurora SA user exists
        Given RDS aurora is configured to have aurora SA user
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurorasa_user_exists" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora is configured to have aurora SA user