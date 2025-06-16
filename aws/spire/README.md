# SPIRE Integration for AWS — Zero-Trust CI/CD

This directory contains SPIRE configurations tailored for AWS to establish **identity-based authentication** between GitHub Actions and AWS infrastructure (e.g., EC2, IAM roles, Vault).

> 🎯 Goal: Authenticate GitHub Actions to Vault using SPIFFE IDs instead of long-lived IAM credentials or secrets.

---

## 🌐 What is SPIRE?

SPIRE = SPIFFE Runtime Environment. It enables **workload identity issuance** using secure and dynamic methods.

- SPIFFE IDs (e.g., `spiffe://aws/iam/my-ci-role`) replace secret-based access.
- SPIRE validates workloads and issues **short-lived JWT-SVIDs**.
- Vault uses these SVIDs to grant fine-grained access to secrets.

---

## 🔁 Workflow Overview

**GitHub Action** → **SPIRE Agent** → **SPIRE Server** → **JWT-SVID** → **Vault JWT Auth** → **AWS Resource Access**


---

### 1. `spire-server.conf`

This configures the SPIRE Server in AWS context:

- Trust domain: `spiffe://aws`
- Runs on EC2 or bastion
- Uses `disk` plugin for local storage
- Signs SPIFFE JWT tokens for GitHub

📌 **Why**: It serves as the **central trust authority**.

📌 **Where**: EC2 instance that is part of your CI/CD jump layer.

---

### 2. `spire-agent.conf`

The SPIRE Agent is a local daemon that:
- Attests to the server using join tokens
- Issues identities to workloads it manages

📌 **Why**: Allows local workloads (GitHub runner or container) to get JWT-SVIDs.

📌 **Where**: Can run as sidecar or daemon on a self-hosted GitHub runner or EC2.

---

### 3. `register-github-entry.sh`

Registers a GitHub Action as a valid SPIFFE workload.

```bash
spire-server entry create \
  -spiffeID "spiffe://github/org/repo/aws-deploy" \
  -selector "unix:uid:1001" \
  -parentID "spiffe://aws/agent/aws-agent" \
  -ttl 3600
````

📌 **Why**: No identity in SPIFFE = no access. This script binds a process (UID 1001) to an identity.

📌 **Where**: Run manually after SPIRE Server is bootstrapped.

---

### Security Tips

Replace join_token with EC2 Instance Identity Document attestation

Run SPIRE Agent with restricted permissions (non-root)

Use Vault audit logs to track issued tokens and secrets

SPIFFE IDs should represent both who (GitHub workflow) and what (environment/resource)

---

### Use Case in AWS

**Component**	            **SPIFFE ID**
GitHub Action	        spiffe://github/org/repo/aws-deploy
EC2 Instance	        spiffe://aws/ec2/i-xxxxxxxxxxxx
IAM Role	            spiffe://aws/iam/github-deploy-role

---

###🔗 References

**SPIFFE in AWS** : https://spiffe.io/docs/latest/spire/deploying/aws/

**Vault JWT Auth for AWS** : https://developer.hashicorp.com/vault/docs/auth/jwt

**SPIRE Attestors** : https://spiffe.io/docs/latest/spire/concepts/attestation/

---
