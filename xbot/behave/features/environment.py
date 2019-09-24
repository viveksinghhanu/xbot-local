import boto
import boto.ec2.elb
import boto.ec2.elb.attributes
import boto.ec2.elb.loadbalancer
import boto.s3.connection
import boto.s3.bucket
import xbot.config as config
from behave import fixture
from behave.fixture import use_fixture_by_tag


def before_all(context):
    context.elb_name = config.elb_name
    context.account_id = config.account_id
    context.access_key = config.access_key
    context.elb_zones = config.elb_zones
    context.elb_listeners = config.elb_listeners
    context.s3_bucket_name = config.s3_bucket_name
    context.bucket_policy = config.bucket_policy


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
    context.function_name = 'AWS-xbot-Function-Test'
    client = boto3.client('lambda', context.region_name, aws_access_key_id=context.access_key_id,
  aws_secret_access_key= context.secret_access_key)
    with open('./code.zip', 'rb') as f:
        zipped_code = f.read()
    response = client.create_function(
        FunctionName=FunctionName,
        Runtime='python2.7',
        Role='arn:aws:iam::345365594618:role/mypolicyrole',
        Code=dict(ZipFile=zipped_code),
        Handler='lambda_function.lambda_handler',
        Description='some desc',
        Timeout=123,
        MemorySize=200,
        Publish=True
    )
    os.system(Cross_Account_cmd)

    yield
    response = client.delete_function(
        FunctionName=FunctionName,
    )

fixture_registry = {
    "fixture.elastic_load_balancer": elastic_load_balancer,
    "fixture.s3_bucket": s3_bucket,
    "fixture.lambda_function": lambda_function
}


def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
