path "secret/data/aws/github/*" {
  capabilities = ["read", "list"]
}

# Allows reading any secret under the aws/github/ namespace.
