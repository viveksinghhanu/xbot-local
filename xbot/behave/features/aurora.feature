#@fixture.aurora_mysql_cluster_parameter_group
#@fixture.aurora_postgres_cluster_parameter_group
#@fixture.aurora_mysql_cluster
#@fixture.aurora_postgres_cluster
#Feature: Aurora Database Management
#
#	@fixture.aurora_mysql_db_instance
#    Scenario: Enforce the VPCx retention period for RDS aurora backups.
#        Given RDS aurora does not have appropriate backup retention period
#        When enforcement test "test_backup_retention" runs
#        Then RDS aurora backup retention period is enabled
#
#	@fixture.aurora_mysql_db_instance
#    Scenario: Enforce auditing on RDS aurora instances.
#        Given RDS aurora audit log is not enabled
#        When enforcement test "test_audit_logging" runs
#        Then aurora audit log is enabled

@fixture.aurora_postgres_database
@fixture.aurora_mysql_database

Feature: Aurora Database Management

    Scenario: Enforce to have backup retention perion for aws aurora database.
        Given RDS aurora is configured not to have backup retention period
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_backup_retention_period" runs
        Then RDS aurora has backup retention period
    #positive
    Scenario: Backup retention perion is configured for aws aurora database.
        Given RDS aurora is configured to have backup retention period
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_backup_retention_period" runs
        Then Enforcement Test responds with a status of "No action taken"

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

    Scenario: Enforce to have custom cluster parameter group to RDS Aurora postgres cluster.
        Given RDS aurora postgres cluster configured not to have custom cluster parameter group
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_has_custom_cluster_parameter_group" runs
        Then RDS aurora postgres has custom cluster parameter group
    #positve
    Scenario: Test RDS Aurora postgres cluster has custom cluster parameter group.
        Given RDS aurora postgres cluster configured to have custom cluster parameter group
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.enforce_aurora_postgres_has_custom_cluster_parameter_group" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce to have custom instance parameter group to RDS Aurora postgres instances.
        Given RDS aurora postgres instances are configured not to have custom instance parameter group
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_has_custom_instance_parameter_group" runs
        Then RDS aurora postgres instances have custom instance parameter group
    #positive
    Scenario: Test RDS Aurora postgres instances have custom instance parameter group.
        Given RDS aurora postgres instances are configured to have custom instance parameter group
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_has_custom_instance_parameter_group" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce audit log is enabled on RDS aurora instances.
        Given RDS aurora is configured to have audit log disabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_audit_logging_enabled" runs
        Then RDS aurora audit log is enabled
    #positive
    Scenario: Test audit log is enabled on RDS aurora instances.
        Given RDS aurora is configured to have audit log enabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_audit_logging_enabled" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce aurora postgres cluster parameters is enabled.
        Given RDS aurora postgres cluster is configured to have cluster parameters disabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_cluster_parameters_enabled" runs
        Then RDS aurora postgres cluster parameters is enabled
    #positive
    Scenario: Test aurora postgres cluster parameters is enabled.
        Given RDS aurora postgres cluster is configured to have cluster parameters enabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_cluster_parameters_enabled" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce aurora postgres instance parameters is enabled.
        Given RDS aurora postgres instance is configred to have instance parameters disabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_instance_parameters_enabled" runs
        Then RDS aurora postgres instance parameters is enabled
    #positive
    Scenario: Test aurora postgres instance parameters is enabled.
        Given RDS aurora postgres instance is configred to have instance parameters enabled
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_instance_parameters_enabled" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce that no extra users are included in audits or users removed from audit.
        Given extra users are configured to include in audits
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_no_include_exclude_users" runs
        Then no extra users are included in audits
    #positive
    Scenario: Test that no extra users are included in audits or users removed from audit.
        Given extra users are not configured to include in audits
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_audit_no_include_exclude_users" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce public schema is revoked for RDS Aurora Postgres engines.
        Given RDS Aurora Postgres engines has public schema
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_public_schema_is_revoked" runs
        Then Revoked public schema for RDS Aurora Postgres engines
    #Positive
    Scenario: Test public schema is revoked for RDS Aurora Postgres engines.
        Given RDS Aurora Postgres engine does not have public schema
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_public_schema_is_revoked" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce to have postgresa user in rds aurora postgres.
        Given RDS aurora postgres doesnt have postgresa user
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_postgre_sa_user_exists" runs
        Then RDS aurora postgres has postgresa user
    #positive
    Scenario: Test to have postgresa user in rds aurora postgres.
        Given postgresa user exists in RDS aurora postgres
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_postgre_sa_user_exists" runs
        Then Enforcement Test responds with a status of "No action taken"

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

    Scenario: Enforce cloudwatch logs retention to 90 days for aurora clusters
        Given RDS aurora cluster is configured not to have cloudwatch log retention for 90 days
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_cluster_cwlogs_retention" runs
        Then RDS aurora cluster has cloudwatch log retention for 90 days
    #positive
    Scenario: Test cloudwatch logs retention to 90 days for aurora clusters
        Given RDS aurora cluster is configured to have cloudwatch log retention for 90 days
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_cluster_cwlogs_retention" runs
        Then Enforcement Test responds with a status of "No action taken"

    Scenario: Enforce RDS aurora mysql databases are owned by account dbas
        Given RDS aurora MySQL database is configured not to have account DBAs as owner
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_mysql_databases_are_owned_by_account_dbas" runs
        Then RDS aurora MySQL database is owned by account DBAs
    #positive
    Scenario: Test RDS aurora mysql databases are owned by account dbas
        Given RDS aurora MySQL database is configured to have account DBAs as owner
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_mysql_databases_are_owned_by_account_dbas" runs
        Then Enforcement Test responds with a status of "No action taken"

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