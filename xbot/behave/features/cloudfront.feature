<<<<<<< Updated upstream
# BEFORE_ALL
# setup xbot credentials from config settings file
# context.target_account = <target account for test resources from config settings file>
 
 
@fixture.s3
  # create a s3 bucket to use as the origin for the CloudFront distribution
  # AWAIT S3 bucket creation
  # context.s3_id = <id of the newly created S3 bucket> 
 
 
@fixture.CloudFront
# create a CloudFront distribution with the above created S3 bucket as origin
  # AWAIT CloudFront deployment
  # context.cloudfront_distribution_id = <id of the newly created cloudfront distribution> 

  
Feature:GxP CloudFront
Scenario: Enforce CloudFront distribution min TTL to be equal to VPCx min TTL by enforcement test
   Given The distribution has minimum TTL greater than VPCx min ttl
   # retrieve the CloudFront distribution configuration from cloud

   And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
   # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

   When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
   Then Minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #      success
	
	
Scenario: The CloudFront distribution TTL time is configured to be less than or equal to VPCx min TTL 
    Given The distribution has minimum TTL equal to VPCx min ttl
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in min TTL takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is equal to VPCx min TTL
    #      success
	 
	 
Scenario: CloudFront configured with invalid logging bucket remediated by enforcement test
    Given The logging bucket of CloudFront distribution is not the valid VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Logging is enabled in CloudFront distribution
    #  enable logging before enforcing VPCx logging bucket 
   
    And Logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #      success
	
	
Scenario: CloudFront configured with valid VPCx logging bucket
    Given Logging bucket of CloudFront distribution is VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in logging bucket takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is VPCx logging bucket
    #      success
	 
	 
=======
# BEFORE_ALL
# setup xbot credentials from config settings file
# context.target_account = <target account for test resources from config settings file>
 
 
@fixture.s3
  # create a s3 bucket to use as the origin for the CloudFront distribution
  # AWAIT S3 bucket creation
  # context.s3_id = <id of the newly created S3 bucket> 
 
 
@fixture.CloudFront
# create a CloudFront distribution with the above create dS3 bucket as origin
  # AWAIT CloudFront deployment
  # context.cloudfront_distribution_id = <id of the newly created cloudfront distribution> 

  
Feature:GxP CloudFront
Scenario: Minimum TTL of CloudFront distribution less than or equal to VPCx min TTL 
   Given The distribution has minimum TTL less than or equal to VPCx min ttl
   # retrieve the CloudFront distribution configuration from cloud

   And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
   # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

   When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
   Then Minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #      success
	
	
Scenario: Minimum TTL of CloudFront distribution equal to VPCx min TTL 
    Given The distribution has minimum TTL equal to VPCx min ttl
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in min TTL takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is equal to VPCx min TTL
    #      success
	 
	 
Scenario: Logging bucket of CloudFront distribution is configured to not have the valid VPCx logging bucket
    Given The logging bucket of CloudFront distribution is not the valid VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Logging is enabled in CloudFront distribution
    #  enable logging before enforcing VPCx logging bucket 
   
    And Logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #      success
	
	
Scenario: Logging bucket of CloudFront distribution is configured to have the valid VPCx logging bucket
    Given Logging bucket of CloudFront distribution is VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in logging bucket takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is VPCx logging bucket
    #      success
	 

# BEFORE_ALL
# setup xbot credentials from config settings file
# context.target_account = <target account for test resources from config settings file>
 
 
@fixture.s3
  # create a s3 bucket to use as the origin for the CloudFront distribution
  # AWAIT S3 bucket creation
  # context.s3_id = <id of the newly created S3 bucket> 
 
 
@fixture.CloudFront
# create a CloudFront distribution with the above create dS3 bucket as origin
  # AWAIT CloudFront deployment
  # context.cloudfront_distribution_id = <id of the newly created cloudfront distribution> 

  
Feature:GxP CloudFront
Scenario: Minimum TTL of CloudFront distribution less than or equal to VPCx min TTL 
   Given The distribution has minimum TTL less than or equal to VPCx min ttl
   # retrieve the CloudFront distribution configuration from cloud

   And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
   # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

   When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
   Then Minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #      success
	
	
Scenario: Minimum TTL of CloudFront distribution equal to VPCx min TTL 
    Given The distribution has minimum TTL equal to VPCx min ttl
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in min TTL takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is equal to VPCx min TTL
    #      success
	 
	 
Scenario: Logging bucket of CloudFront distribution is configured to not have the valid VPCx logging bucket
    Given The logging bucket of CloudFront distribution is not the valid VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Logging is enabled in CloudFront distribution
    #  enable logging before enforcing VPCx logging bucket 
   
    And Logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #      success
	
	
Scenario: Logging bucket of CloudFront distribution is configured to have the valid VPCx logging bucket
    Given Logging bucket of CloudFront distribution is VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in logging bucket takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is VPCx logging bucket
    #      success
	 

# BEFORE_ALL
# setup xbot credentials from config settings file
# context.target_account = <target account for test resources from config settings file>
 
 
@fixture.s3
  # create a s3 bucket to use as the origin for the CloudFront distribution
  # AWAIT S3 bucket creation
  # context.s3_id = <id of the newly created S3 bucket> 
 
 
@fixture.CloudFront
# create a CloudFront distribution with the above create dS3 bucket as origin
  # AWAIT CloudFront deployment
  # context.cloudfront_distribution_id = <id of the newly created cloudfront distribution> 

  
Feature:GxP CloudFront
Scenario: Minimum TTL of CloudFront distribution less than or equal to VPCx min TTL 
   Given The distribution has minimum TTL less than or equal to VPCx min ttl
   # retrieve the CloudFront distribution configuration from cloud

   And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
   # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

   When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
   Then Minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is updated to VPCx min TTL
    #      success
	
	
Scenario: Minimum TTL of CloudFront distribution equal to VPCx min TTL 
    Given The distribution has minimum TTL equal to VPCx min ttl
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_min_ttl_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in min TTL takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if minimum TTL of CloudFront distribution is equal to VPCx min TTL
    #      success
	 
	 
Scenario: Logging bucket of CloudFront distribution is configured to not have the valid VPCx logging bucket
    Given The logging bucket of CloudFront distribution is not the valid VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Logging is enabled in CloudFront distribution
    #  enable logging before enforcing VPCx logging bucket 
   
    And Logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is updated to VPCx logging bucket
    #      success
	
	
Scenario: Logging bucket of CloudFront distribution is configured to have the valid VPCx logging bucket
    Given Logging bucket of CloudFront distribution is VPCx logging bucket
    # retrieve the CloudFront distribution configuration from cloud

    And Resource with resource id in context attribute "cloudfront_distribution_id" is set as target of enforcement test
    # context.target_of_enforcement_test_resource_id = context.cloudfront_distribution_id

    When Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" runs
    # execute the configured enforcement test CLI and makes sure it exits successfully
    # context.enforcement_test_output = <the output of the enforcement test CLI>
   
    Then Enforcement Test "xbot.vpcx.assurance.projectdistribution.ProjectDistributionEnforcementTest.test_cloudfrontx_distribution_logging_bucket_is_valid" responds with a status of "No action taken"
    # assert "No action taken" in context.enforcement_test_output

    And No change in logging bucket takes place
    #   retrieve the CloudFront distribution configuration from cloud
    #   if logging bucket of CloudFront distribution is VPCx logging bucket
    #      success

>>>>>>> Stashed changes
