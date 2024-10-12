# CLI

## taloctl

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

## argocd

### argocd

```
brew install argocd
```

### argocd auto-completion

```
echo "source <(/home/linuxbrew/.linuxbrew/bin/argocd completion bash)" >> ~/.bashrc
```

## virtctl

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

## tailscale

### tailscale

```
echo "alias tailscale=\"/mnt/c/Program\ Files/Tailscale/tailscale.exe\"" >> ~/.bashrc
```

### tailscale auto-completion

```
tailscale completion bash | sudo tee -a /etc/bash_completion.d/tailscale
echo "source '/etc/bash_completion.d/tailscale'" >> ~/.bashrc
```

## helm

### helm auto-completion

```
helm completion bash | sudo tee /etc/bash_completion.d/helm
echo "source '/etc/bash_completion.d/helm'" >> ~/.bashrc
```

## cilium

### cilium cli

```
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
GOOS=$(go env GOOS)
GOARCH=$(go env GOARCH)
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-${GOOS}-${GOARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-${GOOS}-${GOARCH}.tar.gz.sha256sum
sudo tar -C /usr/local/bin -xzvf cilium-${GOOS}-${GOARCH}.tar.gz
rm cilium-${GOOS}-${GOARCH}.tar.gz{,.sha256sum}
```

### cilium auto-completion

```
cilium completion bash | sudo tee /etc/bash_completion.d/cilium
echo "source '/etc/bash_completion.d/cilium'" >> ~/.bashrc
```

## tekton

### tekton cli

```
wget https://github.com/tektoncd/cli/releases/download/v0.38.1/tektoncd-cli-0.38.1_Linux-64bit.deb
sudo dpkg -i tektoncd-cli-0.38.1_Linux-64bit.deb
rm tektoncd-cli-0.38.1_Linux-64bit.deb
```

### tekton cli auto-completion

```
tkn completion bash > /etc/bash_completion.d/tkn
echo "source '/etc/bash_completion.d/tkn'" >> ~/.bashrc
```

## knative

### knative cli

```
brew install knative/client/kn
wget https://github.com/knative/func/releases/download/knative-v1.15.1/func_linux_amd64
mv func_linux_amd64 kn-func
chmod +x kn-func
sudo mv kn-func /usr/local/bin
echo "alias func='kn func'" >> ~/.bashrc
```

### knative cli auto-completion

```
kn completion bash > /etc/bash_completion.d/kn
echo "source '/etc/bash_completion.d/kn'" >> ~/.bashrc
func completion bash > /etc/bash_completion.d/func
echo "source '/etc/bash_completion.d/func'" >> ~/.bashrc
```

## Vault

### Vault cli

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
echo "export VAULT_ADDR=https://vault.tail4d334.ts.net" >> ~/.bashrc
```

## Krew

### Krew cli

```
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.bashrc
```

### Rook plugin

```
kubectl krew install rook-ceph
```

## Kustomize

### Kustomize cli

```
brew install kustomize
```

### Kustomize auto-completion

```
kustomize completion bash > /etc/bash_completion.d/kustomize
echo "source '/etc/bash_completion.d/kustomize'" >> ~/.bashrc
echo 'alias rook-ceph="kubectl rook-ceph"' >> ~/.bashrc
kubectl rook-ceph completion bash > /etc/bash_completion.d/rook-ceph
echo "source '/etc/bash_completion.d/rook-ceph'" >> ~/.bashrc
echo 'alias ceph="kubectl rook-ceph ceph"' >> ~/.bashrc
```

## ArgoCD vault plugin

### argocd-vault-plugin

```
export AVP_VERSION=1.16.1
curl -L https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v${AVP_VERSION}/argocd-vault-plugin_${AVP_VERSION}_linux_amd64 -o argocd-vault-plugin
chmod +x argocd-vault-plugin
sudo mv argocd-vault-plugin /usr/local/bin/
```

## CloudNativePG

### CloudNativePG CLI

```
kubectl krew install cnpg
```

### CloudNativePG CLI auto-completion

```
cat > kubectl_complete-cnpg <<EOF
#!/usr/bin/env sh

# Call the __complete command passing it all arguments
kubectl cnpg __complete "\$@"
EOF

chmod +x kubectl_complete-cnpg

# Important: the following command may require superuser permission
sudo mv kubectl_complete-cnpg /usr/local/bin
```

## MinIO CLI

### MinIO CLI

```
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
echo 'export PATH=$PATH:$HOME/minio-binaries/' >> ~/.bashrc
```

### MinIO auto-completion

```
mc --autocompletion
```

### Set alias

```
mc alias set myminio https://minio.tail4d334.ts.net
```
