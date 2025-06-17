# 🏗️ Vault Configuration – AWS Zero-Trust CI/CD

This directory provides the **HashiCorp Vault setup** for the AWS version of the Zero-Trust CI/CD framework using **GitHub Actions + SPIFFE/SPIRE**.

---

## 🎯 Goal

Use SPIFFE-issued JWT-SVIDs to authenticate GitHub Actions workflows to Vault **without static credentials**.

---

## 📁 Files Breakdown

### `vault-config.hcl`
Configures Vault:
- File storage backend (local)
- No TLS (only for demo/testing)
- HTTP listener
- Enables Vault UI

Use TLS and Raft for real deployments.

---

### `jwt-auth-enable.sh`
Enables JWT auth method so Vault can verify SPIFFE tokens issued by SPIRE.

```bash
vault auth enable jwt

```
---

### vault-policy-write.sh

Registers a policy named github-actions that allows read/list access to secrets path:

```bash
vault policy write github-actions ./policies/github-actions-policy.hcl

```

---

### vault-role-create.sh

Creates a Vault role named github-actions that:

Maps to SPIFFE ID spiffe://aws/github/org/repo/aws-deploy

Requires aud=“vault”

Issues short-lived Vault tokens

---

### policies/github-actions-policy.hcl

Vault policy that allows GitHub Actions to access:

secret/data/aws/github/*

Can be customized per repo or org.

---

### Authentication Flow

**GitHub Actions** → **SPIRE Agent** → **JWT-SVID** → **Vault JWT Auth** → **Secrets**

- GitHub Action receives a SPIFFE JWT-SVID via SPIRE
- Vault validates JWT via public key
- Vault maps the SPIFFE ID (sub) to a role
- Role maps to a policy → provides access to secrets

---

### Test Locally

- vault server -config=vault-config.hcl
- export VAULT_ADDR=http://127.0.0.1:8200
- export VAULT_TOKEN=root

- bash jwt-auth-enable.sh
- bash vault-policy-write.sh
- bash vault-role-create.sh

---

### 📚 References

- Vault JWT Auth : https://developer.hashicorp.com/vault/docs/auth/jwt
- SPIFFE and Vault Integration : https://spiffe.io/blog/spiffe-jwt-vault/
- Vault Policies : https://developer.hashicorp.com/vault/docs/concepts/policies

---
