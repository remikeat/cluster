path "kv/data/*" {
      capabilities = [ "create", "read"]
}

path "kv/metadata/*" {
      capabilities = [ "list", "delete"]
}
