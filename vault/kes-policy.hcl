path "kv/data/infra/*" {
      capabilities = [ "create", "read"]
}

path "kv/metadata/*" {
      capabilities = [ "list", "delete"]
}
