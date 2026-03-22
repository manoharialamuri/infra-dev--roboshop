locals {
  common_tags = {
    project = var.project
    enviornment = var.environment
    terraform = "true"
  }

 cachingDisabled = data.aws_cloudfront_cache_policy.cachingDisabled.id
 cachingOptimized = data.aws_cloudfront_cache_policy.cachingOptimized.id
 acm_certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value

}