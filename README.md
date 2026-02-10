# Armageddon 2026 — APPI-Compliant Cross-Region Medical System

## What This Is

Multi-region AWS infrastructure for a Japanese medical organization.
Tokyo hosts all patient data (RDS). Sao Paulo runs stateless compute only.
Connected via Transit Gateway peering. APPI compliant — PHI never leaves Japan.

## Architecture

```
Doctor (Sao Paulo) --> ALB (TLS/WAF) --> EC2 (private subnet)
    --> Transit Gateway (SP) --> TGW Peering --> Transit Gateway (Tokyo)
    --> Tokyo VPC --> Tokyo RDS (all patient data stored here)
```

## Repo Structure

```
armageddon_2026/
├── README.md
├── .gitignore
├── tokyo/                    # Data authority region (ap-northeast-1)
│   ├── main.tf               # VPC, EC2, RDS, IAM, Secrets, Parameters, CloudWatch, SNS
│   ├── bonus_a.tf            # VPC Endpoints + least-privilege IAM
│   ├── bonus_b.tf            # ALB + TLS + WAF + Dashboard
│   ├── bonus_b_route53.tf    # Route53 + ACM DNS validation
│   ├── bonus_b_logging_route53_apex.tf  # Bonus D: ALB access logs + zone apex
│   ├── bonus_b_waf_logging.tf           # Bonus E: WAF logging to CloudWatch
│   ├── bonus_b_variables.tf  # Bonus B/C/D/E variables
│   ├── tokyo_tgw.tf          # Transit Gateway + peering request
│   ├── tokyo_routes.tf       # TGW routes to SP
│   ├── rds_sg_sp.tf          # RDS SG rule for cross-region access
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── versions.tf
│   ├── user_data.sh          # Flask app bootstrap
│   └── terraform.tfvars.example
│
└── saopaulo/                 # Stateless compute region (sa-east-1)
    ├── main.tf               # VPC, EC2, IAM (NO RDS, NO local DB)
    ├── bonus_a.tf            # VPC Endpoints + least-privilege IAM
    ├── bonus_b.tf            # ALB + TLS + WAF + Dashboard
    ├── bonus_b_route53.tf    # Route53 + ACM DNS validation
    ├── bonus_b_logging_route53_apex.tf  # Bonus D: ALB access logs
    ├── bonus_b_waf_logging.tf           # Bonus E: WAF logging to CloudWatch
    ├── bonus_b_variables.tf  # Bonus B/C/D/E variables
    ├── sp_tgw.tf             # Transit Gateway + accept peering
    ├── sp_tg_routes.tf       # TGW routes to Tokyo
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── versions.tf
    ├── user_data.sh          # Flask app bootstrap
    └── terraform.tfvars.example
```

## Labs Completed

- Lab 1A: EC2 + RDS + Secrets Manager (manual console build)
- Lab 1B: Parameter Store, CloudWatch, Alarms, Incident Response
- Lab 1C: Everything in Terraform (IaC)
- Bonus A: VPC Endpoints + private EC2 + least-privilege IAM
- Bonus B: ALB + TLS (ACM) + WAF + CloudWatch Dashboard
- Bonus C: Route53 + ACM DNS validation
- Bonus D: ALB access logs to S3 + zone apex record
- Bonus E: WAF logging to CloudWatch Logs
- Bonus F: CloudWatch Logs Insights queries (WAF triage)
- Lab 3A: Transit Gateway cross-region peering (Tokyo <-> Sao Paulo)
- Lab 3B: APPI audit evidence pack

## How to Deploy

1. Copy `terraform.tfvars.example` to `terraform.tfvars` in each region
2. Fill in your values (AMI ID, password, email, domain)
3. Deploy in order:

```bash
# Phase 1: Sao Paulo first (creates TGW)
cd saopaulo/
terraform init && terraform apply

# Phase 2: Tokyo (creates TGW + peering request)
cd ../tokyo/
terraform init && terraform apply

# Phase 3: Back to Sao Paulo (accept peering + routes)
cd ../saopaulo/
terraform apply
```

4. Update hardcoded TGW IDs after each phase (see notes in tgw files)

## Notes

- TGW IDs are hardcoded because Tokyo and SP are separate Terraform roots
- After deploying, update the IDs in the tgw and route files with your new values
- The professor's TODO comments are left in for reference
- Bonus F has no Terraform — it's Logs Insights queries run in the CloudWatch console
- terraform.tfvars is in .gitignore — never commit your passwords

## Team

- Group project for CDL Cloud Architecture course
