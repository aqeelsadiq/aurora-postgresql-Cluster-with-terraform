
# The name "primary" is poorly chosen. We actually mean standalone or regional.
# The primary cluster of a global database is actually created with the "secondary" cluster resource below.
resource "aws_rds_cluster" "primary" {
  count              = local.enabled && local.is_regional_cluster ? 1 : 0
  cluster_identifier = var.cluster_identifier == "" ? local.name_prefix : var.cluster_identifier
  database_name      = var.db_name
  # manage_master_user_password must be `null` or `true`. If it is `false`, and `master_password` is not `null`, a conflict occurs.
  manage_master_user_password   = var.manage_admin_user_password ? var.manage_admin_user_password : null
  master_user_secret_kms_key_id = var.admin_user_secret_kms_key_id
  master_username               = local.ignore_admin_credentials ? null : var.admin_user
  master_password               = local.ignore_admin_credentials || var.manage_admin_user_password ? null : var.admin_password
  backup_retention_period       = var.retention_period
  copy_tags_to_snapshot         = var.copy_tags_to_snapshot
  final_snapshot_identifier     = var.cluster_identifier == "" ? lower(local.name_prefix) : lower(var.cluster_identifier)
  apply_immediately             = var.apply_immediately
  skip_final_snapshot           = var.skip_final_snapshot
  vpc_security_group_ids        = var.security_groups
  network_type                  = var.network_type
  db_subnet_group_name          = join("", aws_db_subnet_group.default[*].name)
  tags                          = var.tags
  engine                        = var.engine
  engine_version                = var.engine_version
  allow_major_version_upgrade   = var.allow_major_version_upgrade
  engine_mode                   = var.engine_mode
  enable_http_endpoint          = local.enable_http_endpoint
  port                          = var.db_port

  depends_on = [
    aws_db_subnet_group.default,
  ]

  deletion_protection           = var.deletion_protection
  replication_source_identifier = var.replication_source_identifier

  
  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.serverlessv2_scaling_configuration[*]
    content {
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
    }
  }
}


resource "aws_rds_cluster_instance" "default" {
  count                = local.cluster_instance_count
  identifier           = "${local.name_prefix}-db-instance-${count.index + 1}"
  cluster_identifier   = local.deployed_cluster_identifier
  instance_class       = local.instance_class
  db_subnet_group_name = local.db_subnet_group_name
  publicly_accessible  = var.publicly_accessible
  tags                 = var.tags
  engine               = var.engine
  engine_version       = var.engine_version
  promotion_tier       = count.index == 0 ? 0 : 1
  apply_immediately = var.apply_immediately

  depends_on = [
    aws_db_subnet_group.default,
  ]

  lifecycle {
    ignore_changes        = [engine_version]
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "default" {
  count       = local.enabled ? 1 : 0
  name        = try(length(var.subnet_group_name), 0) == 0 ? "${local.name_prefix}-subnet-group" : var.subnet_group_name
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnets
  tags        = var.tags
}
