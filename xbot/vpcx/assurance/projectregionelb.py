from xbot.vpcx.assurance import enforce, ParametrizedTestCase
import xbot.vpcx.elb as elb
import xbot.config as config


# class ProjectRegionElbTest(ParametrizedTestCase):
#
#     def setUp(self):
#         self.account_id = 'AKIAVA2LEYH5KHFIV7GZ'
#         self.access_key = 'v5AVnFpADk4TbU0/GKf+Uf2fc+6GOKjU9unWVBzJ'
#         self.elb_name = 'kunwarsinghlb'
#         self.elbs = elb.get_elbs(self.account_id, self.access_key)
#         self.elb = self.elbs.get(self.elb_name)
#         if not self.elb:
#             self.skipTest('Elastic load balancer not found.')


class ProjectRegionElbEnforcementTest(ParametrizedTestCase):
    def setUp(self):
        self.account_id = config.account_id
        self.access_key = config.access_key
        self.elb_name = config.elb_name
        self.elbs = elb.get_elbs(self.account_id, self.access_key)
        self.elb = self.elbs.get(self.elb_name)
        if not self.elb:
            self.skipTest('Elastic load balancer not found.')

    @enforce
    def test_logging_enabled(self):
        # Check logging is enabled
        self.assertTrue(elb.logging_enabled(self.account_id, self.access_key, self.elb_name))

    def enforce_logging_enabled(self):
        return elb.enable_logging(self.account_id, self.access_key, self.elb_name)

    @enforce
    def test_cross_zone_enabled(self):
        # Check cross-zone load balancing is enabled
        if self.elb_name in elb.get_elbs(self.account_id, self.access_key):
            self.assertTrue(self.elb.is_cross_zone_load_balancing())
        else:
            self.skipTest('ELB is not present in the Account')

    def enforce_cross_zone_enabled(self):
        return elb.enable_cross_zone(self.account_id, self.access_key, self.elb_name)


# class ProjectRegionElbAssuranceTest(ProjectRegionElbTest):
#     pass