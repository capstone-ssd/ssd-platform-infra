terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "ssd"
      Environment = "dev"
      ManagedBy   = "terraform"
      Repository  = "ssd-platform-infra"
    }
  }
}
