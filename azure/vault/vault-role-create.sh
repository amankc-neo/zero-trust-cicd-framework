#!/bin/bash
vault write auth/jwt/role/github-actions \
  role_type="jwt" \
  bound_audiences="vault" \
  user_claim="sub" \
  bound_subject="spiffe://azure/github/org/repo/azure-deploy" \
  policies="github-actions" \
  ttl="15m"
