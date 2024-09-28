# Secret configuration

### Bitwarden configuration

Create a secret in bitwarden secret manager with the following values

- name: ingress-nginx.yaml
- value:

```
controller:
  extraInitContainers:
  - name: init-clone-crowdsec-bouncer
    image: crowdsecurity/lua-bouncer-plugin
    imagePullPolicy: IfNotPresent
    env:
      - name: API_URL
        value: "http://crowdsec-service.crowdsec.svc.cluster.local:8080"
      - name: API_KEY
        value: ""
      - name: BOUNCER_CONFIG
        value: "/crowdsec/crowdsec-bouncer.conf"
    command: ['sh', '-c', "sh /docker_start.sh; mkdir -p /lua_plugins/crowdsec/; cp -R /crowdsec/* /lua_plugins/crowdsec/"]
    volumeMounts:
    - name: crowdsec-bouncer-plugin
      mountPath: /lua_plugins
```

- name: grafana.yaml
- value:

```
  grafana:
    adminPassword: <GRAFANA_PASSWORD>
```

- name: redmine.yaml
- value:

```
redmineUsername: <REDMINE_USERNAME>
redminePassword: <REDMINE_PASSWORD>
redmineEmail: <REDMINE_EMAIL>
smtpPassword: "<SMTP_API_KEY>"
postgresql:
  auth:
    username: bn_redmine
    password: ""
```

- name: remikeat.com.dockerconfigjson
- value:

```
{
    "auths": {
        "ghcr.io": {
            "username": "",
            "password": "",
            "auth": "username:password base64 encoded"
        }
    }
}
```

- name: remikeat.com.env
- value:

```
NEXT_PUBLIC_WEB3FORMS_TOKEN=""
NEXT_PUBLIC_HCAPTCHA_TOKEN=""
```

- name: crowdsec.yaml
- value:

```
secrets:
  username: ""
  password: ""
lapi:
  env:
    - name: ENROLL_INSTANCE_NAME
      value: "my-k8s-cluster"
    - name: ENROLL_KEY
      value: "<ENROLL_KEY>"
    - name: BOUNCER_KEY_nginx
      value: "<BOUNCER_KEY>"
config:
  notifications:
    email.yaml: |
      type: email           # Don't change
      name: email_default   # Must match the registered plugin in the profile

      # One of "trace", "debug", "info", "warn", "error", "off"
      log_level: info

      # group_wait:         # Time to wait collecting alerts before relaying a message to this plugin, eg "30s"
      # group_threshold:    # Amount of alerts that triggers a message before <group_wait> has expired, eg "10"
      # max_retry:          # Number of attempts to relay messages to plugins in case of error
      timeout: 20s          # Time to wait for response from the plugin before considering the attempt a failure, eg "10s"

      #-------------------------
      # plugin-specific options

      # The following template receives a list of models.Alert objects
      # The output goes in the email message body
      format: |
        <html><body>
        {{range . -}}
          {{$alert := . -}}
          {{range .Decisions -}}
            <p><a href="https://www.whois.com/whois/{{.Value}}">{{.Value}}</a> will get <b>{{.Type}}</b> for next <b>{{.Duration}}</b> for triggering <b>{{.Scenario}}</b> on machine <b>{{$alert.MachineID}}</b>.</p> <p><a href="https://app.crowdsec.net/cti/{{.Value}}">CrowdSec CTI</a></p>
          {{end -}}
        {{end -}}
        </body></html>

      smtp_host: smtp.sendgrid.net # example: smtp.gmail.com
      smtp_username: apikey        # Replace with your actual username
      smtp_password:               # Replace with your actual password
      smtp_port: 587               # Common values are any of [25, 465, 587, 2525]
      auth_type: login             # Valid choices are "none", "crammd5", "login", "plain"
      sender_name: "CrowdSec"
      sender_email: contact@remikeat.com         # example: foo@gmail.com
      email_subject: "CrowdSec Notification"
      receiver_emails:
        - contact@remikeat.com
      # - email2@gmail.com

      # One of "ssltls", "starttls", "none"
      encryption_type: "starttls"

      # If you need to set the HELO hostname:
      # helo_host: "localhost"

      # If the email server is hitting the default timeouts (10 seconds), you can increase them here
      #
      # connect_timeout: 10s
      # send_timeout: 10s
```

- name: supabase.yaml
- value:

```
secret:
  jwt:
    anonKey:
    serviceKey:
    secret: your-super-secret-jwt-token-with-at-least-32-characters-long
  smtp:
    username: your-mail@example.com
    password: example123456
  dashboard:
    username: supabase
    password: this_password_is_insecure_and_should_be_updated
  db:
    username: postgres
    password: example123456
    database: postgres
  analytics:
    apiKey: your-super-secret-and-long-logflare-key
```

- name: kiali.yaml
- value:

```
cr:
  spec:
    external_services:
      grafana:
        auth:
          type: basic
          username: ""
          password: ""
```

- name: harbor.yaml
- value:

```
harborAdminPassword: password
```

- name: fluent.env
- value:

```
username=
password=
```

- name: falco.yaml
- value:

```
falcosidekick:
  webui:
    user: "admin:adminpassword"
```

- name: vm-userdata.yaml
- value:

```
#cloud-config
hostname: vm
users:
  - name: remi
    ssh_import_id:
      - gh:remikeat
    plain_text_passwd:
    lock_passwd: False
    shell: /bin/bash
    sudo: ALL=(ALL) ALL
ssh_pwauth: false
disable_root: false
```

- name: vm-networkdata.yaml
- value:

```
version: 2
ethernets:
  enp1s0:
    dhcp4: true
#  enp2s0:
#    dhcp4: false
#    addresses: [192.168.1.100/22]
#    gateway4: 192.168.0.1
```

- name: vm-pubkey.pub
- value:

```
ssh-ed25519 XXXX
```

And update argocd/bitwarden/secrets.yaml
