### Fix ingress

```
kubectl edit -n rancher ingress/rancher
```

And remove conflicting cert-manager.io annotations

### Get bootstrap password for Rancher

```
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
```

### Get initial password for argocd

```
argocd admin initial-password -n argo-cd
```

### Login in argocd

```
argocd login argocd.remikeat.com
```

### Change password

```
argocd account update-password
```

### Delete secret

```
kubectl delete -n argo-cd secrets/argocd-initial-admin-secret
```

### ArgoCD configuration

Create a github token and connect the repo in argocd
