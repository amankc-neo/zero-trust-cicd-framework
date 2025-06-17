# 🏗️ AWS Terraform Setup – Zero Trust CI/CD Infrastructure

This directory provisions essential AWS infrastructure to support a Zero-Trust CI/CD pipeline built with:

- **SPIFFE/SPIRE** for identity-based authentication
- **HashiCorp Vault** for dynamic secret delivery
- **GitHub Actions** as the CI/CD orchestrator

---

## 📦 What This Terraform Code Does

This module provisions the following AWS resources:

| Resource              | Purpose                                               |
|-----------------------|-------------------------------------------------------|
| VPC (`aws_vpc`)       | Isolated network environment for secure infrastructure |
| Subnet (`aws_subnet`) | Logical subnet for SPIRE and Vault                    |
| EC2 Instance          | Runs the SPIRE Server, SPIRE Agent, and Vault         |

---

## 🧩 Tech Stack & Design Choices

- **Terraform**: Declarative IaC tool to manage AWS infrastructure reproducibly.
- **Amazon EC2 (Ubuntu/AL2)**: Chosen for flexibility in running SPIRE and Vault binaries.
- **Minimal IAM/Security Groups**: For Zero-Trust demonstration only. Extendable for production.

---

## 🛠️ Files and What They Do

| File               | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| `main.tf`          | Main infrastructure definition (VPC, subnet, EC2 instance)                 |
| `variables.tf`     | All input variables (e.g., region, AZ, AMI)                                 |
| `outputs.tf`       | Outputs like EC2 public IP for remote provisioning                          |
| `user-data.sh`     | (You must create this) Bash script to bootstrap SPIRE/Vault on the instance |

---

## ⚙️ Required Variables

Update `terraform.tfvars` or use `-var` CLI flag:

```hcl
aws_region = "us-west-2"
aws_az     = "us-west-2a"
ami_id     = "ami-0abcdef1234567890"  # Ubuntu 20.04 or Amazon Linux 2
```
---

- terraform init
- terraform plan
- terraform apply

