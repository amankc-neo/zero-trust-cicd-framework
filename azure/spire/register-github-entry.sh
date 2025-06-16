#!/bin/bash
# Register GitHub Action workload with SPIRE on Azure

spire-server entry create \
  -spiffeID "spiffe://github/org/repo/azure-deploy" \
  -selector "unix:uid:1001" \
  -parentID "spiffe://azure/agent/my-agent" \
  -ttl 3600
