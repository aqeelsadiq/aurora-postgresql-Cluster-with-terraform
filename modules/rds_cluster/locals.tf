locals {
  name_prefix                 = "${var.project}-${var.environment}"
  cluster_instance_count      = local.enabled ? var.cluster_instance_size : 0
  deployed_cluster_identifier = local.enabled ? one(aws_rds_cluster.primary[*].id) : ""
  db_subnet_group_name        = one(aws_db_subnet_group.default[*].name)
  instance_class              = var.instance_type
  enabled                     = var.enabled
  is_regional_cluster         = var.cluster_type == "regional"
  enable_http_endpoint        = var.enable_http_endpoint
  ignore_admin_credentials    = var.replication_source_identifier != ""
}

