output "cluster_name" {
  description = "생성된 EKS 클러스터 이름"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "IRSA에 사용할 OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "ecr_repositories" {
  description = "서비스별 ECR 리포지토리 URL"
  value = {
    for name, repo in aws_ecr_repository.service : name => repo.repository_url
  }
}

output "reused_rds_endpoint" {
  description = "재사용하는 기존 RDS endpoint"
  value       = data.aws_db_instance.postgres.endpoint
}
