local http = require "resty.http"
local kong = kong
local cjson = require "cjson"

-- Define your plugin
local Auth = {
  PRIORITY = 1000, -- Execution priority of the plugin
  VERSION = "1.0.0",
}

-- Extract token from Authorization header
local function extract_token()
  local auth_header = kong.request.get_header("Authorization")
  if not auth_header then
    return nil, "Missing Authorization header"
  end

  local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
  if not token then
    return nil, "Invalid token format in Authorization header"
  end

  return token
end

-- Call Keycloak introspect URL
local function introspect_token(token, introspect_url, client_id, client_secret)
  local httpc = http.new()
  
  local res, err = httpc:request_uri(introspect_url, {
    method = "POST",
    body = ngx.encode_args({
      token = token,
      client_id = client_id,
      client_secret = client_secret
    }),
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded"
    },
    ssl_verify = false -- Disable SSL verification (optional, but consider using SSL verification)
  })

  if not res then
    return nil, "Failed to connect to introspection endpoint: " .. err
  end

  if res.status ~= 200 then
    return nil, "Invalid response from introspection endpoint: " .. res.status
  end

  local response_body = cjson.decode(res.body)
  return response_body, nil
end

-- Access phase logic: validate the token
function Auth:access(conf)
  -- Step 1: Extract the token from the Authorization header
  local token, err = extract_token()
  if not token then
    return kong.response.exit(401, { message = err })
  end

  -- Step 2: Introspect the token by calling the Keycloak endpoint
  local introspect_url = conf.introspect_url
  local client_id = conf.client_id
  local client_secret = conf.client_secret

  local introspect_response, err = introspect_token(token, introspect_url, client_id, client_secret)
  if not introspect_response then
    return kong.response.exit(500, { message = err })
  end

  -- Step 3: Check if the token is active
  if not introspect_response.active then
    return kong.response.exit(401, { message = "Invalid or expired token" })
  end

  -- Step 4: Token is valid, allow the request to proceed
  kong.log.debug("Token is valid, proceeding with request")
end

-- Return the plugin
return Auth
