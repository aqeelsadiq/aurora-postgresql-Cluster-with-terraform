output "database_name" {
  value       = var.db_name
  description = "Database name"
}

output "master_username" {
  value       = join("", aws_rds_cluster.primary[*].master_username)
  description = "Username for the master DB user"
  sensitive   = true
}

output "cluster_identifier" {
  value       = join("", aws_rds_cluster.primary[*].cluster_identifier)
  description = "Cluster Identifier"
}


output "cluster_security_groups" {
  value       = aws_rds_cluster.primary[*].vpc_security_group_ids
  description = "Default RDS cluster security groups"
}

