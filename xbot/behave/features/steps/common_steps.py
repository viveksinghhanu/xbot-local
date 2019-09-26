"""

Some common steps to be reused between various BDD steps, like running
enforcement tests, etc.

"""

from behave import given, when, then
from os import system


@given('Resource with resource id in context attribute "{attr_name}" is set as target of enforcement test')
def step_impl(context, attr_name):
    context.targetOfEnforcement = attr_name
    print('Printing Attribute name' + context.targetOfEnforcement)


@when('enforcement test "{enf_test_class_method}" runs')
def step_impl(context, enf_test_class_method):
    out = system(r'python -m unittest ' + enf_test_class_method)
    context.out = out
    context.enf_test_class_method = enf_test_class_method
    context.dict = {context.enf_test_class_method: context.out}


@then('enforcement Test responds with a status of "No action taken"')
def step_impl(context):
    assert context.out == context.dict[context.enf_test_class_method]


