# SPIRE Integration for Azure — Zero-Trust CI/CD

This directory contains the full configuration needed to deploy **SPIFFE/SPIRE** in an Azure-based Zero-Trust CI/CD pipeline.

> 🎯 Goal: Enable GitHub Actions to securely authenticate to Vault and Azure targets using **identity-based authentication**, not static secrets.

---

## 🌐 What is SPIRE?

**SPIRE** (SPIFFE Runtime Environment) is a production-ready implementation of the [SPIFFE](https://spiffe.io/) standard.

- **SPIFFE** defines a framework for **identity-based security**: every workload gets a verifiable identity (`spiffe://...`).
- **SPIRE** issues and manages those identities through X.509 SVIDs (for TLS) or JWT SVIDs (for auth to Vault, etc).

In this project:
- **GitHub Actions workflows** act as workloads
- **SPIRE issues JWT-SVIDs** to them
- **Vault uses SPIFFE IDs** to grant access to secrets

---

## 🔁 Workflow Overview

**GitHub Action** → **SPIRE Agent** → **SPIRE Server** → **JWT-SVID** → **Vault JWT Auth** → **Azure VM/Secrets**


---

### 1. `spire-server.conf`

This file configures the **SPIRE Server**, which:
- Maintains the SPIFFE trust domain (`spiffe://azure`)
- Acts as the central authority for workload identity
- Signs JWTs and X.509 certs
- Stores data locally via the `disk` plugin
- Uses `UpstreamAuthority` to load a CA certificate and private key

📌 **Why it's needed**:
- Without it, no SPIFFE IDs can be issued.
- SPIRE Server enforces registration and attestation policies.

📌 **Where it's deployed**:
- Preferably on a hardened **jump server or bastion host** in Azure.

---

### 2. `spire-agent.conf`

This configures the **SPIRE Agent**, which:
- Runs alongside workloads (or in this case, mocks them)
- Attests to the SPIRE Server and retrieves identities
- Communicates with workloads via Unix socket

📌 **Why it's needed**:
- It bridges the workload and SPIRE Server securely.

📌 **Where it's deployed**:
- On the same host where the GitHub Action runner or VM executes.
- It uses the `join_token` method to authenticate to SPIRE Server (simple for demo).

---

### 3. `register-github-entry.sh`

This is a shell script that **registers a GitHub Action workflow** with SPIRE.

📌 **What this does**:
Creates a new SPIFFE ID for the GitHub Action
Tells SPIRE: "If you see a process with UID 1001, assign it this identity"

📌 **Why it's needed**:
SPIRE only issues identities to registered workloads.
Without this entry, no token will be issued.

📌 **Where it's run**:
On the SPIRE Server machine after the server is started.

```bash
spire-server entry create \
  -spiffeID "spiffe://github/org/repo/azure-deploy" \
  -selector "unix:uid:1001" \
  -parentID "spiffe://azure/agent/my-agent" \
  -ttl 3600
```

### Security & Best Practices
Area	                              Recommendation
SPIRE                               AuthN	Replace join_token with Azure MSI or TPM
Secrets	                            Never embed client secrets in workflows
SPIFFE IDs	                        Use meaningful names for traceability
Runtime isolation	                  Run SPIRE Agent in minimal VMs or containers
Monitoring	                        Enable SPIRE logs and Vault audit logs

🔗 **Resources**

**SPIFFE Specification** : https://github.com/spiffe/spiffe/blob/main/standards/SPIFFE-ID.md

**SPIRE Documentation** : https://spiffe.io/docs/latest/spire-about/

**Vault JWT Auth Method** : https://developer.hashicorp.com/vault/docs/auth/jwt


