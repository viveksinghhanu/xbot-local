from xbot import config
from behave.fixture import use_fixture_by_tag
import boto3
import pprint
import os
import random
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
                          aws_access_key_id=config.AWSAccessKey,
                          aws_secret_access_key=config.AWSSecretKey
                          )
    with open(r'xbot\behave\features\code.zip', 'rb') as f:
        zipped_code = f.read()
    response = client.create_function(
        FunctionName=context.FunctionName,
        Runtime='python3.7',
        Role=f'arn:aws:iam::{config.account_id}:role/mypolicyrole',
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
        's3.amazonaws.com --source-arn arn:aws:s3:::kunwardemo --source-account 420752799804 ' \
        '--output text'
    os.system(Cross_Account_cmd)
    print('Lambda Function Arn :', context.lambda_function_id)
    context.lambda_function_id = response['FunctionArn']

    yield
    client.delete_function(
        FunctionName=context.FunctionName,
    )


fixture_registry = {
    "fixture.elastic_load_balancer": elastic_load_balancer,
    "fixture.s3_bucket": s3_bucket,
    "fixture.lambda_function": lambda_function
}


def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
