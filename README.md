# Zero-Trust CI/CD Deployment Framework

This repository provides a **production-ready Zero-Trust CI/CD framework** using:

- **GitHub Actions** for CI/CD orchestration
- **SPIFFE/SPIRE** for workload identity
- **HashiCorp Vault** for secret management

🎯 **Goal**: Enable **identity-based authentication** between GitHub Actions and cloud environments (Azure & AWS), without relying on static credentials.

## 🔐 Technologies Used

- GitHub Actions
- HashiCorp Vault (JWT Auth Method)
- SPIFFE/SPIRE (Workload Identity)
- Azure (VMs, Managed Identities)
- AWS (EC2, IAM Roles)
