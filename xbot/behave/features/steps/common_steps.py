# from behave import given, when, then
# from os import system
# from xbot.behave import util
# import xbot.config as config
# from xbot.vpcx.assurance.projectregionelb import ProjectRegionElbEnforcementTest
#
#
# @when('enforcement test "{enf_test_class_method}" runs')
# def step_impl(context, enf_test_class_method):
#     system(r'python -m unittest ' + enf_test_class_method)
#
#
# # @then('enforcement test "{enf_test_class_method}" takes no action')
# # def step_impl(context, enf_test_class_method):
# #     test_class_instance, method_name = (util.get_class_instance_and_method_name_from_full_method_path(enf_test_class_method))
# #     assert system(r'python -m unittest ' + enf_test_class_method) == 0
#
# @then('Enforcement Test responds with a status of "No action taken"')
# def step_impl(context, enf_test_class_method):
#     pass
