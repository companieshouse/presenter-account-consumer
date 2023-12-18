# Define all hardcoded local variable and local variables looked up from data resources
locals {
  stack_name                 = "identity" # this must match the stack name the service deploys into
  name_prefix                = "${local.stack_name}-${var.environment}"
  global_prefix              = "global-${var.environment}"
  service_name               = "presenter-account-consumer"
  container_port             = "3000" # default port required here until prod docker container is built allowing port change via env var
  docker_repo                = "presenter-account-consumer"
  lb_listener_rule_priority  = 12
  lb_listener_paths          = ["/presenter-account-consumer/*"]
  healthcheck_path           = "/presenter-account-consumer/healthcheck" #healthcheck path for presenter-account-consumer
  healthcheck_matcher        = "200"
  application_subnet_ids     = data.aws_subnets.application.ids
  kms_alias                  = "alias/${var.aws_profile}/environment-services-kms"
  service_secrets            = jsondecode(data.vault_generic_secret.service_secrets.data_json)
  stack_secrets              = jsondecode(data.vault_generic_secret.stack_secrets.data_json)
  application_subnet_pattern = local.stack_secrets["application_subnet_pattern"]
  use_set_environment_files  = var.use_set_environment_files
  app_environment_filename   = "presenter-account-consumer.env"
  vpc_name                   = data.aws_ssm_parameter.secret[format("/%s/%s", local.name_prefix, "vpc-name")].value

  # Enable Eric
  use_eric_reverse_proxy  = true
  eric_port               = "3001" # container port plus 1
  eric_version            = "latest"

  # create a map of secret name => secret arn to pass into ecs service module
  # using the trimprefix function to remove the prefixed path from the secret name
  secrets_arn_map = {
    for sec in data.aws_ssm_parameter.secret :
    trimprefix(sec.name, "/${local.name_prefix}/") => sec.arn
  }

  service_secrets_arn_map = {
    for sec in module.secrets.secrets :
    trimprefix(sec.name, "/${local.service_name}-${var.environment}/") => sec.arn
  }

  global_secret_list = flatten([for key, value in local.global_secrets_arn_map :
    { "name" = upper(key), "valueFrom" = value }
  ])

  global_secrets_arn_map = {
    for sec in data.aws_ssm_parameter.global_secret :
    trimprefix(sec.name, "/${local.global_prefix}/") => sec.arn
  }

  service_secret_list = flatten([for key, value in local.service_secrets_arn_map :
    { "name" = upper(key), "valueFrom" = value }
  ])

  ssm_service_version_map = [
    for sec in module.secrets.secrets : {
      name  = "${replace(upper(local.service_name), "-", "_")}_${var.ssm_version_prefix}${replace(upper(basename(sec.name)), "-", "_")}",
      value = tostring(sec.version)
    }
  ]

  ssm_global_version_map = [
    for sec in data.aws_ssm_parameter.global_secret : {
      name  = "GLOBAL_${var.ssm_version_prefix}${replace(upper(basename(sec.name)), "-", "_")}",
      value = tostring(sec.version)
    }
  ]

  # secrets to go in list
  task_secrets = concat(local.global_secret_list, local.service_secret_list)

  task_environment = concat(local.ssm_global_version_map,local.ssm_service_version_map)

  # Eric secrets config
  eric_secrets = [
    { "name" : "AES256_KEY" , "valueFrom" : "${local.service_secrets_arn_map.aes256_key}" },
    { "name" : "API_KEY" , "valueFrom" : "${local.service_secrets_arn_map.api_key}" },
    { "name" : "CACHE_URL" , "valueFrom" : "${local.service_secrets_arn_map.cache_url}" }
  ]

  eric_environment = [
    { "name": "LOGLEVEL", "value": "${var.log_level}" },
    { "name": "MODE", "value": "api" },
    { "name": "ACCOUNT_API_URL", "value" : "${var.account_api_url}" },
    { "name": "DEVELOPER_HUB_URL", "value" : "${var.developer_hub_url}" }
  ]
}