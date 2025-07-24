variable "zone_id" {
  type        = any
  default     = []
  description = <<-EOT
    Route53 DNS Zone ID as list of string (0 or 1 items). If empty, no custom DNS name will be published.
    If the list contains a single Zone ID, a custom DNS name will be pulished in that zone.
    Can also be a plain string, but that use is DEPRECATED because of Terraform issues.
    EOT
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnets" {
  type        = list(string)
  description = "List of VPC subnet IDs"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use"
}

variable "cluster_identifier" {
  type        = string
  default     = ""
  description = "The RDS Cluster Identifier. Will use generated label ID if not supplied"
}
variable "cluster_instance_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}


variable "db_name" {
  type        = string
  default     = ""
  description = "Database name (default is not to create a database)"
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "Database port"
}

variable "manage_admin_user_password" {
  type        = bool
  default     = false
  nullable    = false
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if master_password is provided"
}

variable "admin_user_secret_kms_key_id" {
  type        = string
  default     = null
  description = <<-EOT
    Amazon Web Services KMS key identifier is the key ARN, key ID, alias ARN, or alias name for the KMS key.
    To use a KMS key in a different Amazon Web Services account, specify the key ARN or alias ARN.
    If not specified, the default KMS key for your Amazon Web Services account is used.
    EOT
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "Username for the master DB user. Ignored if snapshot_identifier or replication_source_identifier is provided"
}


variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}


variable "engine" {
  type        = string
  default     = "postgres"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_mode" {
  type        = string
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "engine_version" {
  type        = string
  default     = "15.7"
  description = "The version of the database engine to use. See `aws rds describe-db-engine-versions` "
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = true
  description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to false."
}


variable "publicly_accessible" {
  type        = bool
  description = "Set to true if you want your cluster to be publicly accessible (such as via QuickSight)"
  default     = false
}


variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = true
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags to backup snapshots"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = true
}


variable "replication_source_identifier" {
  type        = string
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
  default     = ""
}


variable "cluster_type" {
  type        = string
  description = <<-EOT
    Either `regional` or `global`.
    If `regional` will be created as a normal, standalone DB.
    If `global`, will be made part of a Global cluster (requires `global_cluster_identifier`).
    EOT
  default     = "regional"

  validation {
    condition     = contains(["regional", "global"], var.cluster_type)
    error_message = "Allowed values: `regional` (standalone), `global` (part of global cluster)."
  }
}


variable "enable_http_endpoint" {
  type        = bool
  description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless"
  default     = false
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Additional security group IDs to apply to the cluster, in addition to the provisioned default security group with ingress traffic from existing CIDR blocks and existing security groups"

  default = []
}


variable "subnet_group_name" {
  description = "Database subnet group name. Will use generated label ID if not supplied."
  type        = string
  default     = ""
}


variable "network_type" {
  type        = string
  default     = "IPV4"
  description = "The network type of the cluster. Valid values: IPV4, DUAL."
}


variable "tags" {
  description = "Tags to apply to RDS cluster and associated resources"
  type        = map(string)
  default     = {}
}

variable "project" {}
variable "environment" {}

variable "enabled" {
  description = "Whether to enable this RDS cluster"
  type        = bool
  default     = true
}

variable "admin_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "serverlessv2_scaling_configuration" {
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default     = null
  description = "serverlessv2 scaling properties"
}