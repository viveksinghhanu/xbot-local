import boto3
import boto.ec2.elb
import boto.ec2.elb.attributes
import boto.ec2.elb.loadbalancer
import xbot.config as config

elb_name = config.elb_name
s3_bucket_name = config.s3_bucket_name
account_id = config.AWSAccessKey
access_key = config.AWSSecretKey

# Logging emit interval is set in minutes and is either 5 or 60 minutes
LOGGING_EMIT_INTERVAL = 5


def get_elbs(accountid, accesskey):

    """
    Retrieve all ELBs for a particular project and region.

    Returns:
      dict: Dictionary of ELBs, where keys are the ELB names and the
        values are Boto LoadBalancer objects.

    """
    conn = boto.connect_elb(accountid, accesskey)
    elbs = conn.get_all_load_balancers()
    result = {}
    for lb in elbs:
        lb_name = lb.name
        result[lb_name] = lb

    return result


def get_access_log_attribute(accountid, accesskey, elb):

    conn = boto.connect_elb(accountid, accesskey)
    # Need to call get_all_lb_attributes, not get_lb_attribute as
    # get_lb_attribute only can return crossZoneLoadBalancing, not accessLog
    lb_attributes = conn.get_all_lb_attributes(elb_name)
    # Access log is not always set if logging is disabled

    if not lb_attributes.access_log:
        return None
    else:
        access_log = lb_attributes.access_log
        return access_log


def get_cross_zone_enabled(accountid, accesskey, elb):
    conn = boto.connect_elb(accountid, accesskey)
    # Check if the elb has cross zone balancing enabled or not
    lb_attributes = conn.get_lb_attribute(elb_name, 'crossZoneLoadBalancing')
    return lb_attributes


def logging_enabled(account_id, access_key, elb):
    # Get current access log configuration for ELB
    current_access_log = get_access_log_attribute(account_id, access_key, elb)
    # If logging attribute cannot be found, return False
    if not current_access_log:
        return False
    # Get the regional target logs bucket name for comparison with current configuration
    target_logs_bucket = s3_bucket_name
    LOGGING_EMIT_INTERVAL=60
    # Only return True if all logging conditions are met
    if(
        current_access_log.enabled and
        current_access_log.s3_bucket_name == target_logs_bucket and
        current_access_log.s3_bucket_prefix == "" and
        current_access_log.emit_interval == LOGGING_EMIT_INTERVAL
        ):
        return True
    # All logging conditions were not met, return False
    return False


def enable_logging(account_id, access_key, elb, enforce=True):
    # If enforcement is enabled, try enabling logging
    try:
        # Get the regional logs bucket name
        logs_bucket = s3_bucket_name
        # Configure an AccessLogAttribute with the regional logs bucket and 5 minute interval
        standard_logging = get_access_log_attribute(account_id, access_key, elb_name)
        LOGGING_EMIT_INTERVAL=60
        # If no logging attribute is available, create one
        if not standard_logging:
            standard_logging = boto.ec2.elb.attributes.AccessLogAttribute()
        else:
            standard_logging.enabled = True
            standard_logging.s3_bucket_name = logs_bucket
            standard_logging.s3_bucket_prefix = ""
            standard_logging.emit_interval = LOGGING_EMIT_INTERVAL
        # Attempt to apply logging policy to this ELB
        conn = boto.connect_elb(account_id, access_key)
        result = conn.modify_lb_attribute(elb, 'accessLog', standard_logging)
        print(f'Logging enabled for {elb_name}')
        return True
    except Exception as e:
        print(e)
        return False


def enable_cross_zone(account_id, access_key, elb):
    # If enforcement is enabled, try enabling cross-zone load balancing
    try:
        conn = boto.ec2.elb.ELBConnection(account_id, access_key)
        elb1 = boto.ec2.elb.loadbalancer.LoadBalancer(conn, elb)
        elb1.enable_cross_zone_load_balancing()
        print(f'Enabled cross-zone load balancing for elastic load balancer {elb} in project {account_id}')
        print('Inside cross zone True')
        return True

    except Exception as e:
        print(e)
        print(f'Could not enable cross-zone load balancing for elastic load balancer {elb} in project {account_id}')
        print('Inside cross zone False')
        return False


def describe_load_balancers(account_id, access_key, elb_name):
    conn = boto.connect_elb(account_id, access_key)
    # Need to call get_all_lb_attributes, not get_lb_attribute as
    # get_lb_attribute only can return crossZoneLoadBalancing, not accessLog
    lb_attributes = conn.get_all_lb_attributes(elb_name)
    # Access log is not always set if logging is disabled
    print(lb_attributes)
