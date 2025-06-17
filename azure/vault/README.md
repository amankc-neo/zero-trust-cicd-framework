# Vault Configuration for Azure - Zero-Trust CI/CD

This directory contains configuration files to integrate **HashiCorp Vault** with **GitHub Actions** and **SPIFFE/SPIRE** for secure, identity-based authentication in Azure.

> 🎯 Goal: Enable GitHub Actions to retrieve secrets from Vault **without long-lived credentials**, using short-lived JWT-SVIDs issued by SPIRE.

---

## 🔁 How It Works
**GitHub Actions** → **SPIRE Agent** → **SPIRE Server** → **JWT-SVID** → **Vault JWT Auth Method** → **Secrets**


- The **JWT-SVID** acts like a proof of identity.
- Vault uses **SPIFFE IDs** to associate JWTs with specific policies and roles.
- Access is fine-grained and **tied to workload identity**, not static tokens.

---

### 1. `vault-config.hcl`

Vault’s general server configuration:
- Storage: file backend (for demo)
- Listener: HTTP on port 8200 (for dev)
- TLS disabled for simplicity, but should be **enabled in prod**
- UI enabled

🔐 In production:
- Use integrated storage (`raft`)
- Enable TLS with certs
- Restrict listener to internal network

---

### 2. `jwt-auth-enable.sh`

```bash
#!/bin/bash
vault auth enable jwt
```

**Enables the JWT Auth method on Vault, allowing Vault to validate JWT tokens (SVIDs) from SPIRE**

---

| Feature            | Benefit                                |
| ------------------ | -------------------------------------- |
| SPIFFE IDs         | Unforgeable identity for CI/CD         |
| Vault + JWT Auth   | Short-lived, dynamic tokens            |
| Policy-as-code     | GitOps-friendly, reviewable, auditable |
| Zero-Secret Access | No secrets in GitHub Actions or VMs    |

---

### Security Practices

1. Enable TLS on Vault listeners (not done here for simplicity)
2. Use vault audit enable file to log token usage
3.Rotate roles/policies using automation
4. Use spiffe:// IDs for tight scoping (not just *)

---

### Test Locally

- vault server -config=vault-config.hcl
- export VAULT_ADDR='http://127.0.0.1:8200'
- export VAULT_TOKEN='root'

# Enable auth
- bash jwt-auth-enable.sh

# Register policy and role
- bash vault-policy-write.sh
- bash vault-role-create.sh

---

### 🔗 References

Vault JWT Auth : https://developer.hashicorp.com/vault/docs/auth/jwt
Vault Policies : https://developer.hashicorp.com/vault/docs/concepts/policies
SPIFFE IDs in Vault : https://spiffe.io/blog/spiffe-jwt-vault/
