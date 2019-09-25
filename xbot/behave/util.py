import importlib

def get_class_instance_and_method_name_from_full_method_path(method_path):
    """
    Given something like
    'xbot.vpcx.assurance_enforcement.test_vnet.TestNICs.test_nic_has_no_publicip'
    would return an instance of TestNICs() class and the name of the method,
    in the example above 'test_nic_has_no_publicip'

    Args:
    method_path (str): fully qualified path of a method of a class

    Returns:
    (class_instance, str): instance of the passed in class and the method name

    """
    module_name, class_name, method_name = method_path.rsplit('.',2)
    module_object = importlib.import_module(module_name)
    class_instance = getattr(module_object, class_name)()
    return class_instance, method_name