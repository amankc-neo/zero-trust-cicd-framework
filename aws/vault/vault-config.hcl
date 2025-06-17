listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

storage "file" {
  path = "./vault-data"
}

ui = true

# for production 
# Use storage "raft" for HA
# Replace TLS config with working certificates
# Set ACL policies for minimal access
