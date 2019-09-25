@fixture.aurora_mysql_cluster_parameter_group
@fixture.aurora_postgres_cluster_parameter_group
@fixture.aurora_mysql_cluster
@fixture.aurora_postgres_cluster
Feature: Aurora Database Management
	
	@fixture.aurora_mysql_db_instance
    Scenario: Enforce the VPCx retention period for RDS aurora backups.
        Given RDS aurora does not have appropriate backup retention period
        When enforcement test "test_backup_retention" runs
        Then RDS aurora backup retention period is enabled
		
	@fixture.aurora_mysql_db_instance
    Scenario: Enforce auditing on RDS aurora instances.
        Given RDS aurora audit log is not enabled
        When enforcement test "test_audit_logging" runs
        Then aurora audit log is enabled