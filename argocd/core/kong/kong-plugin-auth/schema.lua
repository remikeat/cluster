local schema = {
    name = "auth",
    fields = {
      {
        config = {
          type = "record",
          fields = {
            { introspect_url = { type = "string", required = true } }, -- The Keycloak introspection URL
            { client_id = { type = "string", required = true } },      -- Client ID registered in Keycloak
            { client_secret = { type = "string", required = true } },  -- Client secret for authentication
          }
        }
      }
    }
  }

  return schema
