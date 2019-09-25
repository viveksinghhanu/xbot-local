from xbot import config
from behave.fixture import use_fixture_by_tag
import boto3
import pprint
import os
import random
import time
import boto
import boto.ec2.elb
import boto.ec2.elb.attributes
import boto.ec2.elb.loadbalancer
import boto.s3.connection
import boto.s3.bucket
from behave import fixture
from behave.fixture import use_fixture_by_tag


def before_all(context):
    context.elb_name = config.elb_name
    context.account_id = config.AWSAccessKey
    context.access_key = config.AWSSecretKey
    context.elb_zones = config.elb_zones
    context.elb_listeners = config.elb_listeners
    context.s3_bucket_name = config.s3_bucket_name
    context.bucket_policy = config.bucket_policy
    context.FunctionName = config.FunctionName


@fixture
def elastic_load_balancer(context):
    elb_conn = boto.connect_elb(context.account_id, context.access_key)
    elb_conn.create_load_balancer(context.elb_name, context.elb_zones, context.elb_listeners)
    print(f'Created Elastic Load Balancer by the name {context.elb_name}')

    yield
    elb_conn.delete_load_balancer(context.elb_name)
    print(f'Deleted Elastic Load Balancer by the name {context.elb_name}')


@fixture
def s3_bucket(context):
    s3conn = boto.s3.connection.S3Connection(context.account_id, context.access_key)
    s3conn.create_bucket(context.s3_bucket_name, {}, '', context.bucket_policy)
    print(f'Created S3 Bucket by the name {context.s3_bucket_name}')

    yield
    s3bucket = boto.s3.bucket.Bucket(s3conn,config.s3_bucket_name)
    bucket = s3conn.get_bucket(config.s3_bucket_name, validate=False)
    s3bucket.delete_keys(bucket.get_all_keys())
    s3conn.delete_bucket(context.s3_bucket_name)
    print(f'Deleted S3 Bucket by the name {context.s3_bucket_name}')


@fixture
def lambda_function(context):
    context.FunctionName = config.FunctionName
    client = boto3.client('lambda',
                          'us-east-2',
                          aws_access_key_id=config.AWSAccessKey,
                          aws_secret_access_key=config.AWSSecretKey
                          )
    with open(r'xbot\behave\features\code.zip', 'rb') as f:
        zipped_code = f.read()
    response = client.create_function(
        FunctionName=context.FunctionName,
        Runtime='python3.7',
        Role='arn:aws:iam::360752793804:role/LambdaRole',
        Code=dict(ZipFile=zipped_code),
        Handler='lambda_function.lambda_handler',
        Description='Some Description',
        Timeout=123,
        MemorySize=200,
        Publish=True
    )
    pprint.pprint(response)
    context.lambda_function_id = response['FunctionArn'] + ':' + response['Version']

    Cross_Account_cmd = f'aws lambda add-permission --function-name {context.lambda_function_id} ' \
        f'--action lambda:InvokeFunction --statement-id s3-account{random.randint(2, 100)} --principal ' \
        's3.amazonaws.com --source-arn arn:aws:s3:::amoddemobucket --source-account 420752799804 ' \
        '--output text'
    os.system(Cross_Account_cmd)
    print('Lambda Function Arn :', context.lambda_function_id)
    context.lambda_function_id = response['FunctionArn']

    yield
    client.delete_function(
        FunctionName=context.FunctionName,
    )

#======================================================= Amazon Aurora Fixtures ====================================================

#Creating a client for accessing Amazon Aurora using boto3 sdk
aurora_client  = boto3.client('rds')

@fixture
def aurora_mysql_cluster_parameter_group(context):
    response = aurora_client.create_db_cluster_parameter_group(
        DBClusterParameterGroupName='aurora-mysql-cluster-parameter-group',
        DBParameterGroupFamily='aurora5.6',
        Description='Aurora MySQL DB CLuster parameter group',
    )
    yield
    response = aurora_client.delete_db_cluster_parameter_group(
        DBClusterParameterGroupName='aurora-mysql-cluster-parameter-group'
    )


@fixture
def aurora_postgres_cluster_parameter_group(context):
    response = aurora_client.create_db_cluster_parameter_group(
        DBClusterParameterGroupName='aurora-postgres-cluster-parameter-group',
        DBParameterGroupFamily='aurora5.6',
        Description='Aurora MySQL DB CLuster parameter group',
    )
    yield
    response = aurora_client.delete_db_cluster_parameter_group(
        DBClusterParameterGroupName='aurora-postgres-cluster-parameter-group'
    )


@fixture
def aurora_mysql_cluster(context):
    response = aurora_client.create_db_cluster(
        AvailabilityZones=[
            'us-east-1a',
        ],
        DBClusterIdentifier='aurora-mysql-cluster',
        DBClusterParameterGroupName='aurora-mysql-cluster-parameter-group',
        DatabaseName='aurora-mysql-db',
        Engine='aurora',
        EngineVersion='5.6.10a',
        MasterUserPassword='admin123',
        MasterUsername='admin',
        Port=3306,
        StorageEncrypted=True,
        EnableCloudwatchLogsExports=[
            'error'
        ]
    )
    sleep_mode = True
    while sleep_mode:
        try:
            cluster_response = aurora_client.describe_db_clusters(
                DBClusterIdentifier='aurora-mysql-cluster',
            )
            for cluster in cluster_response['DBClusters']:
                if cluster['Status'] == 'creating':
                    time.sleep(5)
                elif cluster['Status'] == 'available':
                    sleep_mode = False
        except Exception:
            sleep_mode = False
    yield
    response = aurora_client.delete_db_cluster(
        DBClusterIdentifier='aurora-mysql-cluster',
        SkipFinalSnapshot=True,
    )
    sleep_mode = True
    while sleep_mode:
        try:
            cluster_response = aurora_client.describe_db_clusters(
                DBClusterIdentifier='aurora-mysql-cluster',
            )
            if cluster_response:
                time.sleep(5)
            else:
                sleep_mode = False
        except Exception:
            sleep_mode = False


@fixture
def aurora_postgres_cluster(context):
    print('aurora_cluster is being created...')
    response = aurora_client.create_db_cluster(
        AvailabilityZones=[
            'us-east-1a',
        ],
        DBClusterIdentifier='aurora-postgres-cluster',
        DBClusterParameterGroupName='aurora-postgres-cluster-parameter-group',
        DatabaseName='aurora-postgres-db',
        Engine='aurora',
        EngineVersion='5.6.10a',
        MasterUserPassword='admin123',
        MasterUsername='admin',
        Port=3306,
        StorageEncrypted=True,
        EnableCloudwatchLogsExports=[
            'error'
        ]
    )
    sleep_mode = True
    while sleep_mode:
        try:
            cluster_response = aurora_client.describe_db_clusters(
                DBClusterIdentifier='aurora-postgres-cluster',
            )
            for cluster in cluster_response['DBClusters']:
                if cluster['Status'] == 'creating':
                    time.sleep(5)
                elif cluster['Status'] == 'available':
                    sleep_mode = False
        except Exception:
            sleep_mode = False
    yield
    response = aurora_client.delete_db_cluster(
        DBClusterIdentifier='aurora-postgres-cluster',
        SkipFinalSnapshot=True,
    )
    sleep_mode = True
    while sleep_mode:
        try:
            cluster_response = aurora_client.describe_db_clusters(
                DBClusterIdentifier='aurora-postgres-cluster',
            )
            if cluster_response:
                time.sleep(5)
            else:
                sleep_mode = False
        except Exception:
            sleep_mode = False


@fixture
def aurora_mysql_db_instance(context):
    print('Database Instance is being created...')
    response = aurora_client.create_db_instance(
        DBInstanceIdentifier='aurora-mysql-db-id',
        DBInstanceClass='db.r4.large',
        Engine='aurora',
        DBClusterIdentifier='aurora-mysql-cluster',
    )
    sleep_mode = True
    while sleep_mode:
        try:
            instance_response = aurora_client.describe_db_instances(
                DBInstanceIdentifier='aurora-mysql-db-id',
            )
            for instance in instance_response['DBInstances']:
                if instance['DBInstanceStatus'] == 'creating':
                    time.sleep(10)
                elif instance['DBInstanceStatus'] == 'available':
                    sleep_mode = False
        except Exception:
            return False
    yield
    response = aurora_client.delete_db_instance(
        DBInstanceIdentifier='aurora-mysql-db-id',
        SkipFinalSnapshot=True,
        DeleteAutomatedBackups=True
    )
    sleep_mode = True
    while sleep_mode:
        try:
            instance_response = aurora_client.describe_db_instances(
                DBInstanceIdentifier='aurora-mysql-db-id',
            )
            if instance_response:
                time.sleep(5)
            else:
                sleep_mode = False
        except Exception:
            sleep_mode = False


@fixture
def aurora_postgres_db_instance(context):
    print('Database Instance is being created...')
    response = aurora_client.create_db_instance(
        DBInstanceIdentifier='aurora-postgres-db-id',
        DBInstanceClass='db.r4.large',
        Engine='aurora',
        DBClusterIdentifier='aurora-postgres-cluster',
    )
    sleep_mode = True
    while sleep_mode:
        try:
            instance_response = aurora_client.describe_db_instances(
                DBInstanceIdentifier='aurora-postgres-db-id',
            )
            for instance in instance_response['DBInstances']:
                if instance['DBInstanceStatus'] == 'creating':
                    time.sleep(10)
                elif instance['DBInstanceStatus'] == 'available':
                    sleep_mode = False
        except Exception:
            return False
    yield
    response = aurora_client.delete_db_instance(
        DBInstanceIdentifier='aurora-postgres-db-id',
        SkipFinalSnapshot=True,
        DeleteAutomatedBackups=True
    )
    sleep_mode = True
    while sleep_mode:
        try:
            instance_response = aurora_client.describe_db_instances(
                DBInstanceIdentifier='aurora-postgres-db-id',
            )
            if instance_response:
                time.sleep(5)
            else:
                sleep_mode = False
        except Exception:
            sleep_mode = False

#=======================================================================================================================================

fixture_registry = {
    "fixture.elastic_load_balancer": elastic_load_balancer,
    "fixture.s3_bucket": s3_bucket,
    "fixture.lambda_function": lambda_function,
    "fixture.aurora_mysql_cluster_parameter_group" : aurora_mysql_cluster_parameter_group,
    "fixture.aurora_postgres_cluster_parameter_group" : aurora_postgres_cluster_parameter_group,
    "fixture.aurora_mysql_cluster" : aurora_mysql_cluster,
    "fixture.aurora_postgres_cluster" : aurora_postgres_cluster,
    "fixture.aurora_mysql_db_instance" : aurora_mysql_db_instance,
    "fixture.aurora_postgres_db_instance" : aurora_postgres_db_instance

}

def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
