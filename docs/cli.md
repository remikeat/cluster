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
echo "source /etc/bash_completion.d/tkn" >> ~/.bashrc
```

## knative

### knative cli

```
brew install knative/client/kn
wget https://github.com/knative/func/releases/download/knative-v1.15.1/func_linux_amd64
mv func_linux_amd64 kn-func
chmod +x kn-func
sudo mv kn-func /usr/local/bin
```

### knative cli auto-completion

```
echo "source <(kn completion bash)" >> ~/.bashrc
```
