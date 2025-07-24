variable "aws_region" {}

################################################################################
# VPC
################################################################################
variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
variable "vpc_configs" {
  description = "Map of VPC configurations"
  type = object({
    cidr                    = string
    azs                     = list(string)
    public_subnets          = list(string)
    private_subnets         = list(string)
    enable_dns_hostnames    = bool
    enable_dns_support      = bool
    enable_ipv6             = bool
    create_vpc              = bool
    create_igw              = bool
    single_nat_gateway      = bool
    one_nat_gateway_per_az  = bool
    map_public_ip_on_launch = bool
    enable_nat_gateway      = bool
  })
}




############################
#rds-cluster
############################
variable "identifier" {}
variable "env" {}

variable "rds_cluster_config" {
  description = "Configuration for the RDS cluster"
  type = object({
    availability_zones                    = list(string)
    instance_type                         = string
    cluster_instance_size                 = number
    db_name                               = string
    admin_user                            = string
    cluster_family                        = string
    engine                                = string
    engine_mode                           = string
    engine_version                        = string
    deletion_protection                   = bool
    intra_security_group_traffic_enabled = bool
    db_port                               = number
    cluster_identifier                    = string
    retention_period                      = number
    serverlessv2_scaling_configuration = object({
      min_capacity = number
      max_capacity = number
    })
    security_group_ingress = list(object({
      description      = optional(string)
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      self             = optional(bool)
    }))
  })
}
variable "create_rds" {
  type    = bool
  default = true
}

variable "rds_password" {
  type      = string
  default   = null
  sensitive = true
}

