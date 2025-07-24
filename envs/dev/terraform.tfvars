aws_region = "us-east-2"

#########################
# VPC
#########################
project = "mydemo"
environment = "dev"

vpc_configs = {
    cidr                    = "10.0.0.0/16"
    azs                     = ["us-east-2a", "us-east-2b"]
    public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets         = ["10.0.101.0/24", "10.0.102.0/24"]
    enable_dns_hostnames    = true
    enable_dns_support      = true
    enable_ipv6             = false
    create_vpc              = true
    create_igw              = true
    single_nat_gateway      = false
    one_nat_gateway_per_az  = false
    map_public_ip_on_launch = true
    enable_nat_gateway      = true
}


###############
# rds cluster
###############

rds_cluster_config = {
  availability_zones                    = ["us-east-2a", "us-east-2b", "us-east-2c"]
  instance_type                         = "db.serverless"
  cluster_family                        = "aurora-postgresql16"
  engine                                = "aurora-postgresql"
  engine_mode                           = "provisioned"
  engine_version                        = "16.6"
  deletion_protection                   = false
  db_name                               = "mydb"
  admin_user                            = "root"
  intra_security_group_traffic_enabled = true
  db_port                               = 5432
  cluster_instance_size                 = 1
  retention_period                      = 7
  cluster_identifier                    = ""
  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 2
}
  serverlessv2_scaling_configuration = {
  min_capacity = 1
  max_capacity = 2
}
  security_group_ingress = [
    {
      description = "Allow from internal SG"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      self        = true
    },
    {
      description = "Allow from my IP"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow from my IP"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/24"]
    }
  ]
}
