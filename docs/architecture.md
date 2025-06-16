# Architecture: Zero-Trust Identity Model

This document details the **identity trust model** across GitHub Actions, SPIRE, and Vault for both Azure and AWS.

## 🔐 SPIFFE Trust Domains

| Environment | Trust Domain      |
|-------------|-------------------|
| Azure       | `spiffe://azure`  |
| AWS         | `spiffe://aws`    |
| GitHub      | `spiffe://github` |

## 🔄 Identity Flow 

1. GitHub Actions workflow starts and is identified by SPIRE.
2. SPIRE issues a **JWT-SVID** to the GitHub job.
3. GitHub uses the token to **authenticate to Vault** using JWT Auth.
4. Vault verifies SPIFFE identity and issues scoped secrets.
5. GitHub uses secrets to deploy to Azure or AWS (Zero-Trust access).

## 🆔 SPIFFE ID Format

### Azure

| Component        | SPIFFE ID                                |
|------------------|-------------------------------------------|
| GitHub Workflow  | `spiffe://github/org/repo/azure-deploy`  |
| Azure VM         | `spiffe://azure/vm/my-vm`                |
| MSI              | `spiffe://azure/msi/my-client-id`        |

### AWS

| Component        | SPIFFE ID                                |
|------------------|-------------------------------------------|
| GitHub Workflow  | `spiffe://github/org/repo/aws-deploy`    |
| AWS EC2          | `spiffe://aws/ec2/i-0abcd1234efg56789`   |
| IAM Role         | `spiffe://aws/iam/my-ci-role`            |

---
