@fixture.aurora_mysql_database
@fixture.aurora_mysql_database_user_dba
Feature: Aurora Postgres Database Management

    Scenario: Enforce RDS aurora mysql databases are owned by account dbas
        Given RDS aurora MySQL database is configured not to have account DBAs as owner
        And Resource with resource id in context attribute "mysql_aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_mysql_databases_are_owned_by_account_dbas" runs
        Then RDS aurora MySQL database is owned by account DBAs
    #positive
    Scenario: Test RDS aurora mysql databases are owned by account dbas
        Given RDS aurora MySQL database is configured to have account DBAs as owner
        And Resource with resource id in context attribute "mysql_aurora_id" is set as target of enforcement test
        When enforcement test "vpcx.assurance.projectregiondatabase.test_aurora_mysql_databases_are_owned_by_account_dbas" runs
        Then Enforcement Test responds with a status of "No action taken"
        And RDS aurora MySQL database is owned by account DBAs

