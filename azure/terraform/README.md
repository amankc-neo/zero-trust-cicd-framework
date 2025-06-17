# 🏗️ Azure Terraform Setup – Zero Trust CI/CD Infrastructure

This Terraform module provisions the necessary Azure infrastructure to support a **Zero-Trust CI/CD pipeline** using:

- **SPIFFE/SPIRE** for cryptographic service identities
- **HashiCorp Vault** for secure secret delivery
- **GitHub Actions** as the CI/CD orchestrator

---

## 📦 What This Terraform Code Does

This setup deploys the foundational cloud components for running SPIRE Server, SPIRE Agent, and HashiCorp Vault inside Azure Virtual Machines.

| Resource                        | Purpose                                                  |
|---------------------------------|----------------------------------------------------------|
| Resource Group                  | Isolated environment for all Zero Trust components      |
| Virtual Network (VNet)          | Logical network boundary for SPIRE/Vault components     |
| Subnet                          | Dedicated subnet for secure compute instances           |
| Network Interface               | IP configuration for the VM                             |
| Linux Virtual Machine (Ubuntu)  | Hosts SPIRE Server, SPIRE Agent, and Vault binaries     |

---

## 🧩 Tech Stack & Design Choices

- **Terraform + AzureRM Provider**: Declarative IaC for repeatable deployments
- **Ubuntu 20.04 VM**: Preferred for compatibility with SPIRE and Vault binaries
- **Dynamic IP allocation**: Makes setup simple, use static/private IP in production
- **Resource Isolation**: Single RG and VNet for easier management and teardown

---

## 🛠️ Files and Their Purpose

| File             | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `main.tf`        | Provisions all resources (VNet, subnet, VM, etc.)                           |
| `variables.tf`   | Input variables used throughout the Terraform configs                       |
| `outputs.tf`     | Outputs like public IP of the provisioned VM                                |
| `terraform.tfvars` (optional) | Can be added to set custom values for input variables             |

---

## ⚙️ Required Variables

You can define values inline or in a `terraform.tfvars` file:

```hcl
location = "East US"
```
---

- terraform init
- terraform plan
- terraform apply

# After deployment, you’ll receive the public IP address of the provisioned VM. Use this to SSH into your host and install SPIRE/Vault.

---
