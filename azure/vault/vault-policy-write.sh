#!/bin/bash
vault policy write github-actions ./policies/github-actions-policy.hcl
# Creates a Vault policy defining what GitHub workflows are allowed to do.
