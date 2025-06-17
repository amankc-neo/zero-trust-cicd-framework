#!/bin/bash
vault policy write github-actions ./policies/github-actions-policy.hcl
# This defines and registers the Vault policy that limits GitHub Actions to specific secrets.
