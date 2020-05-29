### Kubeapps deployment notes

```
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set frontend.service.type=LoadBalancer,useHelm3=true
```

`kubectl get svc -n kubeapps`

```
kubectl config view -o=jsonpath='{.users[?(.name=="admin")].user.auth-provider.config.refresh-token}' | pbcopy
```
