variable "aws_region" {
  description = "배포 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "capstone"
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "ssd-dev-eks"
}

variable "vpc_id" {
  description = "재사용할 기존 VPC ID"
  type        = string
}

variable "cluster_subnet_ids" {
  description = "EKS control plane과 node group이 사용할 subnet 목록"
  type        = list(string)
}

variable "node_instance_types" {
  description = "관리형 노드 그룹 인스턴스 타입"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "기본 노드 수"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "최소 노드 수"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "최대 노드 수"
  type        = number
  default     = 2
}

variable "service_repository_names" {
  description = "생성할 ECR 리포지토리 목록"
  type        = list(string)
  default = [
    "ssd-api-gateway",
    "ssd-auth-service",
    "ssd-member-service",
    "ssd-document-service",
    "ssd-review-service",
    "ssd-ai-orchestrator"
  ]
}

variable "secret_names" {
  description = "생성할 Secrets Manager 시크릿 이름"
  type        = list(string)
  default = [
    "ssd/dev/common",
    "ssd/dev/auth",
    "ssd/dev/member",
    "ssd/dev/document",
    "ssd/dev/review",
    "ssd/dev/ai"
  ]
}
