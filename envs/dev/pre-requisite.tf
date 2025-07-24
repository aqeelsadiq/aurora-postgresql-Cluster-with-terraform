resource "random_password" "rds_admin_password" {
  count            = var.create_rds ? (var.rds_password == null || var.rds_password == "") ? 1 : 0 : 0
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}:;,<>.?~"
  upper            = true
  lower            = true
  numeric          = true
}

resource "aws_secretsmanager_secret" "rds_admin_password" {
  name  = "${local.identifier}/admin-password"
}

resource "aws_secretsmanager_secret_version" "rds_admin_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_admin_password.id
  secret_string = jsonencode({
    password = random_password.rds_admin_password.result
  })
}




#################################
# securoty group for rds cluster
#################################
resource "aws_security_group" "default" {
  name        = "${local.identifier}-aurora-postgresql-sg"
  description = "Allow inbound and outbound traffic"
  vpc_id      = module.vpc.vpc_id

  # Dynamic ingress rules
  dynamic "ingress" {
    for_each = var.rds_cluster_config.security_group_ingress
    content {
      description      = lookup(ingress.value, "description", null)
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", [])
      self             = lookup(ingress.value, "self", true)
    }
  }

  egress {
    description = "Allow all outbound traffic (IPv4)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
