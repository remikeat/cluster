### Talos installation

- Download talos image from https://factory.talos.dev/ by setting values according to talos/boot_assets/assets.yaml
- Extract the image

```
xz -d metal-arm64.raw.xz
```

Prepare the cluster

```
talosctl apply-config --insecure -n 192.168.0.122 --file controlplane.yaml
talosctl bootstrap -n 192.168.0.122
talosctl kubeconfig -n 192.168.0.122
talosctl config endpoint 192.168.0.122
talosctl config nodes 192.168.0.122
```

### Terraform installation

```
terraform init
source .env
terraform apply
```

### Fix ingress

```
kubectl edit -n rancher ingress/rancher
```

And remove conflicting cert-manager.io annotations:

```
cert-manager.io/issuer: rancher
cert-manager.io/issuer-kind: Issuer
```

### Get bootstrap password for Rancher

```

kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'

```

### Get initial password for argocd

```

argocd admin initial-password -n argocd

```

### Login in argocd

```

argocd login argocd.tail4d334.ts.net

```

### Change password

```

argocd account update-password

```

### Delete secret

```

kubectl delete -n argocd secrets/argocd-initial-admin-secret

```

### Create applications

```
kubectl apply -f applicationset.yaml
kubectl apply -f applications.yaml
```

### Get initial password for elasticsearch

```
kubectl get secrets elasticsearch-es-elastic-user -o json | jq -r .data.elastic | base64 -d
```

Update password in bitwarden secret manager : fluent.env
And update password in bitwarden password manager for kibana/elasticsearch

### Portainer

Create admin account for portainer by accessing portainer.tail4d334.ts.net IMMEDIATELY

### Redmine

- Setup authentication needed
- Disable user self registration

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

And update argocd/applications/bitwarden/secrets.yaml

### Setup number of replicas for elasticsearch

```
curl -X PUT -L 'https://elasticsearch.tail4d334.ts.net/*/_settings' \
-u "elastic:$PASSWORD" \
-H 'Content-Type: application/json' \
-d '{"index": {"number_of_replicas": 0}}'
```

### How to encode in base64

```
echo -n "username:password" | base64
```

### How to create htpasswd data

```
htpasswd -n username
```

### Deploy applications

```
kubectl apply -f applications.yaml
```

### Cluster shutdown

```
talosctl shutdown
```

### talosctl

```
brew install siderolabs/tap/talosctl
```

### talosctl auto-completion

```
talosctl completion bash > ~/.talos/completion.bash.inc
echo "source '$HOME/.talos/completion.bash.inc'" >> ~/.bashrc
source $HOME/.bashrc
```

### argocd

```
brew install argocd
```

### argocd auto-completion

```
echo "source <(/home/linuxbrew/.linuxbrew/bin/argocd completion bash)" >> ~/.bashrc
```

### virtctl

```
curl -Lo virtctl https://github.com/kubevirt/kubevirt/releases/download/v1.3.1/virtctl-v1.3.1-linux-amd64
chmod +x virtctl
sudo mv virtctl /usr/local/bin/
```

### virtctl auto-completion

```
virtctl completion bash > ~/.virtctl-completion.bash
echo "source '/home/remi/.virtctl-completion.bash'" >> ~/.bashrc
```

### tailscale

```
echo "alias tailscale=\"/mnt/c/Program\ Files/Tailscale/tailscale.exe\"" >> ~/.bashrc
```

### tailscale auto-completion

```
tailscale completion bash | sudo tee -a /etc/bash_completion.d/tailscale
echo "source '/etc/bash_completion.d/tailscale'" >> ~/.bashrc
```

### Retrieve kubeconfig

```
talosctl kubeconfig
tailscale configure kubeconfig tailscale-operator
```

### helm auto-completion

```
helm completion bash | sudo tee /etc/bash_completion.d/helm
echo "source '/etc/bash_completion.d/helm'" >> ~/.bashrc
```

### Reset machine

```
talosctl reset --graceful=false --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --reboot
```
