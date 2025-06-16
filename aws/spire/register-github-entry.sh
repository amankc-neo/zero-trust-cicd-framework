#!/bin/bash
# Register GitHub Action workload with SPIRE on AWS

spire-server entry create \
  -spiffeID "spiffe://github/org/repo/aws-deploy" \
  -selector "unix:uid:1001" \
  -parentID "spiffe://aws/agent/aws-agent" \
  -ttl 3600
