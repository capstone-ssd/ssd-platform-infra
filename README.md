# ssd-platform-infra

SSD MSA 환경의 AWS 인프라를 Terraform으로 관리하는 저장소다.

## 목표

- 기존 VPC와 RDS를 재사용한다.
- `dev` 환경용 EKS 클러스터를 새로 생성한다.
- 서비스별 ECR 리포지토리를 생성한다.
- Secrets Manager를 통해 애플리케이션 민감 값을 관리한다.

## 관리 대상

- EKS 클러스터
- EKS 관리형 노드 그룹
- ECR 리포지토리
- IAM Role 및 IRSA 기반 ServiceAccount 연동용 역할
- Secrets Manager secret

## 재사용 대상

- 기존 VPC
- 기존 서브넷
- 기존 PostgreSQL RDS

## 현재 확인된 dev 네트워크

- VPC: `vpc-0387e9a2c02f1d5e9`
- Public subnet A: `subnet-0a8356d7c185d372b`
- Public subnet C: `subnet-0b1dfd6e1ed3e43ff`

현재 조회 기준으로 VPC 안에 private subnet이 확인되지 않았기 때문에, 1차 검증 환경은 public subnet 기반의 단순 EKS 구성을 전제로 한다.

## 검증용 단순화 정책

- EKS control plane 로그는 비활성화한다.
- 클러스터 secret encryption용 별도 KMS 키는 생성하지 않는다.
- 우선 EKS, 노드 그룹, ECR, Secrets Manager 생성에 집중한다.

## 구조

- `environments/dev`
  dev 환경용 진입점
- `modules`
  공통 모듈을 추가할 확장 지점

## 실행 예시

```bash
cd environments/dev
terraform init
terraform plan \
  -var="aws_region=ap-northeast-2" \
  -var="vpc_id=vpc-0387e9a2c02f1d5e9" \
  -var='private_subnet_ids=["subnet-xxxx","subnet-yyyy"]' \
  -var='public_subnet_ids=["subnet-aaaa","subnet-bbbb"]'
terraform apply
```

## destroy 원칙

이 저장소는 Terraform state에 포함된 리소스만 삭제한다.  
기존 VPC, 기존 RDS처럼 `data source`로 참조하는 자원은 destroy 대상이 아니다.
