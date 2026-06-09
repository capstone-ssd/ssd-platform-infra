data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_db_instance" "postgres" {
  db_instance_identifier = "ssd-dev-postgres"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.17"

  cluster_name    = var.cluster_name
  cluster_version = "1.33"

  vpc_id                   = data.aws_vpc.existing.id
  subnet_ids               = var.cluster_subnet_ids
  control_plane_subnet_ids = var.cluster_subnet_ids
  cluster_enabled_log_types = []
  cluster_encryption_config = {}
  create_kms_key            = false
  create_cloudwatch_log_group = false

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      name           = "ssd-dev-default"
      instance_types = var.node_instance_types
      desired_size   = var.desired_size
      min_size       = var.min_size
      max_size       = var.max_size
      subnet_ids     = var.cluster_subnet_ids
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Workload = "ssd-msa"
  }
}

resource "aws_ecr_repository" "service" {
  for_each = toset(var.service_repository_names)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_secretsmanager_secret" "application" {
  for_each = toset(var.secret_names)

  name                    = each.value
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "placeholder" {
  for_each = aws_secretsmanager_secret.application

  secret_id = each.value.id
  secret_string = jsonencode({
    message = "replace-me"
  })
}
