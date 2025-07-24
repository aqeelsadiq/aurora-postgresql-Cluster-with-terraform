#####################
# VPCs
#####################

module "vpc" {
  source = "../../modules/vpc"

  vpc_name                = "${local.identifier}-vpc"
  cidr                    = var.vpc_configs.cidr
  azs                     = var.vpc_configs.azs
  public_subnets          = var.vpc_configs.public_subnets
  private_subnets         = var.vpc_configs.private_subnets
  enable_dns_hostnames    = var.vpc_configs.enable_dns_hostnames
  enable_dns_support      = var.vpc_configs.enable_dns_support
  enable_ipv6             = var.vpc_configs.enable_ipv6
  create_vpc              = var.vpc_configs.create_vpc
  create_igw              = var.vpc_configs.create_igw
  single_nat_gateway      = var.vpc_configs.single_nat_gateway
  one_nat_gateway_per_az  = var.vpc_configs.one_nat_gateway_per_az
  map_public_ip_on_launch = var.vpc_configs.map_public_ip_on_launch
  enable_nat_gateway      = var.vpc_configs.enable_nat_gateway
}




###########################
# rds-cluster
##########################

module "rds_cluster" {
  source = "../../modules/rds_cluster"

  engine                = var.rds_cluster_config.engine
  engine_mode           = var.rds_cluster_config.engine_mode
  admin_user            = var.rds_cluster_config.admin_user
  engine_version        = var.rds_cluster_config.engine_version
  admin_password        = random_password.rds_admin_password[0].result
  db_name               = var.rds_cluster_config.db_name
  cluster_instance_size = var.rds_cluster_config.cluster_instance_size
  instance_type         = var.rds_cluster_config.instance_type
  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.private_subnet_ids
  security_groups       = [aws_security_group.default.id]
  deletion_protection   = var.rds_cluster_config.deletion_protection
  cluster_identifier    = "${local.identifier}-cluster"
  retention_period      = var.rds_cluster_config.retention_period
  project               = var.project
  environment           = var.environment
  db_port               = var.rds_cluster_config.db_port
  serverlessv2_scaling_configuration = var.rds_cluster_config.serverlessv2_scaling_configuration
}
