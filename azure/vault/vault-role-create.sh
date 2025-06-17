#!/bin/bash
vault write auth/jwt/role/github-actions \
  role_type="jwt" \
  bound_audiences="vault" \
  user_claim="sub" \
  bound_subject="spiffe://azure/github/org/repo/azure-deploy" \
  policies="github-actions" \
  ttl="15m"
  
# Binds a specific SPIFFE ID to a Vault role
# Grants access to specific secrets or mounts via a policy
# Limits tokens to 15 minutes
