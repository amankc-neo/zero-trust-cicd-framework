#!/bin/bash
vault write auth/jwt/role/github-actions \
    role_type="jwt" \
    bound_audiences="vault" \
    user_claim="sub" \
    bound_subject="spiffe://aws/github/org/repo/aws-deploy" \
    policies="github-actions" \
    ttl="15m"

# audiences: JWTs must have vault in the aud claim
# bound_subject: SPIFFE ID issued by SPIRE to GitHub Action workload
# ttl: Tokens are short-lived for security
