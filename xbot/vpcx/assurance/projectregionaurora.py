from xbot.vpcx.assurance import enforce,ParametrizedTestCase
import xbot.vpcx.aurora as aurora
import boto3
import time


class Aurora_enfTest(ParametrizedTestCase):
    @classmethod
    def setUpClass(self):
        self.client = boto3.client('rds')
        self.Account_id = '<Enter the Account ID>'
        self.Access_Key = '<Enter the Account Access Key>'
        self.db_cluster = 'aurora-mysql-cluster'
        self.cluster = aurora.check_cluster(self.db_cluster)
        if not self.cluster:
            self.skipTest('Cluster not found!')

    @enforce
    def test_backup_retention(self):
        retention_period = aurora.check_retention_period(self.cluster)
        if retention_period != 4:
            aurora.update_retention_period(self.cluster)
        sleep = True
        while sleep:
            try:
                cluster_response = self.client.describe_db_clusters(
                    DBClusterIdentifier='aurora-mysql-cluster',
                )
                for cluster in cluster_response['DBClusters']:
                    if cluster['Status'] != 'available':
                        time.sleep(5)
                    else:
                        sleep = False
            except Exception:
                sleep = False
        self.assertNotEqual(aurora.check_retention_period(self.cluster),4)

    @enforce
    def test_audit_logging(self):
        audit_logging = aurora.check_audit_logging(self.cluster)
        if audit_logging != 'audit':
            aurora.update_audit_logging(self.cluster)
        sleep = True
        while sleep:
            try:
                cluster_response = self.client.describe_db_clusters(
                    DBClusterIdentifier='aurora-mysql-cluster',
                )
                for cluster in cluster_response['DBClusters']:
                    if cluster['Status'] != 'available':
                        time.sleep(5)
                    else:
                        sleep = False
            except Exception:
                sleep = False
        sleep_instance = True
        while sleep_instance:
            try:
                instance_response = self.client.describe_db_instances(
                    DBInstanceIdentifier='aurora-mysql-db-id',
                )
                for instance in instance_response['DBInstances']:
                    if instance['DBInstanceStatus'] != 'available':
                        time.sleep(10)
                    else:
                        sleep_instance = False
            except Exception:
                return False
        self.assertNotEqual(aurora.check_audit_logging(self.cluster),'audit')

    def enforce_backup_retention(self):
        return aurora.update_retention_period(self.cluster)

    def enforce_audit_logging(self):
        return aurora.update_audit_logging(self.cluster)
