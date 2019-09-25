from behave import given, when, then
from xbot.vpcx.aurora import *
import boto3, os, time

client = boto3.client('rds')
@given('RDS aurora does not have appropriate backup retention period')
def step_impl(context):
    context.Cluster = check_cluster('aurora-mysql-cluster')
    assert check_retention_period(context.Cluster) != 4


@when('enforcement test "test_backup_retention" runs')
def step_impl(context):
    os.system(f'python -m unittest xbot.vpcx.assurance.Aurora_enf.Aurora_enfTest.test_backup_retention')

    pass


@then('RDS aurora backup retention period is enabled')
def step_impl(context):
    context.Cluster = check_cluster('aurora-mysql-cluster')
    assert check_retention_period(context.Cluster) == 4


@given('RDS aurora audit log is not enabled')
def step_impl(context):
    context.Cluster = check_cluster('aurora-mysql-cluster')
    assert check_audit_logging(context.Cluster) != 'audit'


@when('enforcement test "test_audit_logging" runs')
def step_impl(context):
    os.system(f'python -m unittest xbot.vpcx.assurance.Aurora_enf.Aurora_enfTest.test_audit_logging')
    pass


@then('aurora audit log is enabled')
def step_impl(context):
    context.Cluster = check_cluster('aurora-mysql-cluster')
    if check_audit_logging(context.Cluster) == 'audit':
        pass
