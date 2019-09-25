import unittest


class ParametrizedTestCase(unittest.TestCase):
    # TestCase classes that want to be parametrized should
    # inherit from this class.

    @staticmethod
    def parametrize(test_case_class, test_names=None, params=None):

        # Create a suite containing all tests taken from the given
        # subclass, passing them the parameter 'param'.

        test_loader = unittest.TestLoader()
        suite = unittest.TestSuite()
        if not test_names:
            test_names = test_loader.getTestCaseNames(test_case_class)
        for name in test_names:
            suite.addTest(test_case_class(name, params=params))
        return suite


def enforce(fn):
    def enforce_on_failure(self, *args, **kwargs):
        try:
            # Run the test
            fn(self, *args, **kwargs)
        except AssertionError:
            # Test failed, try to run the enforcement action
            result = getattr(self, 'enforce_' + fn.__name__[5:])(*args, **kwargs)
            if not result:
                # Enforcement action failed, repurpose the exception to be handled by VPCx team
                print('exception to be handled by VPCx team')

                raise AssertionError
            else:
                # Enforcement succeeded, continue the test failure process
                raise
        except Exception:
            # Test had an error, continue the test error process
            raise Exception

    return enforce_on_failure
