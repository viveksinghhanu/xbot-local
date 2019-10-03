@fixture.aurora_postgres_cluster
@fixture.custom_cluster_parameters
@fixture.custem_instance_parameters
@fixture.postgres_public_schema
@fixture.postgresa_user

Feature: Aurora Postgres Database Management
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
        And RDS aurora postgres has custom cluster parameter group

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
        And RDS aurora postgres cluster parameters is enabled

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
        And RDS aurora postgres instances have custom instance parameter group

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
        And RDS aurora postgres instance parameters is enabled

    Scenario: Enforce public schema is revoked for RDS Aurora Postgres engines.
        Given RDS Aurora Postgres engines has public schema
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_public_schema_is_revoked" runs
        Then Revoked public schema for RDS Aurora Postgres engines
    #Positive
    Scenario: Test public schema is revoked for RDS Aurora Postgres engines.
        Given RDS Aurora Postgres engine does not have public schema
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgres_public_schema_is_revoked" runs
        Then Enforcement Test responds with a status of "No action taken"
        And Revoked public schema for RDS Aurora Postgres engines

    Scenario: Enforce to have postgresa user in rds aurora postgres.
        Given RDS aurora postgres doesnt have postgresa user
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgresa_user_exists" runs
        Then RDS aurora postgres has postgresa user
    #positive
    Scenario: Test to have postgresa user in rds aurora postgres.
        Given postgresa user exists in RDS aurora postgres
        And Resource with resource id in context attribute "aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_postgresa_user_exists" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora postgres has postgresa user
