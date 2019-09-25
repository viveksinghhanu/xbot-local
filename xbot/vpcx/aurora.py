import boto3

aurora_client = boto3.client('rds')


def check_cluster(cluster_identifier):
    cluster_response = aurora_client.describe_db_clusters(
        DBClusterIdentifier=cluster_identifier,
    )
    try:
        if cluster_response:
            for clusters in cluster_response['DBClusters']:
                return clusters['DBClusterIdentifier']
    except Exception:
        return False


def check_retention_period(cluster_identifier):
    cluster_response = aurora_client.describe_db_clusters(
        DBClusterIdentifier=cluster_identifier,
    )
    for clusters in cluster_response['DBClusters']:
        retention_period = clusters['BackupRetentionPeriod']
        return retention_period


def update_retention_period(cluster_identifier):
    try:
        cluster_response = aurora_client.modify_db_cluster(
            DBClusterIdentifier=cluster_identifier,
            BackupRetentionPeriod=4,
        )
        if cluster_response:
            return True
        else:
            return False
    except Exception:
        return False


def check_audit_logging(cluster_identifier):
    cluster_response = aurora_client.describe_db_clusters(
        DBClusterIdentifier=cluster_identifier,
    )
    for clusters in cluster_response['DBClusters']:
        logged = clusters['EnabledCloudwatchLogsExports']
        for Logs in logged:
            if Logs == 'audit':
                return Logs
            else:
                return False


def update_audit_logging(cluster_identifier):
    try:
        cluster_response = aurora_client.modify_db_cluster(
            DBClusterIdentifier=cluster_identifier,
            CloudwatchLogsExportConfiguration={
                'EnableLogTypes': [
                    'audit',
                ]
            }
        )
        if cluster_response:
            return True
        else:
            return False
    except Exception:
        return False
