## Tanzu Kubernetes Grid notes

### vSphere 7 WCP login

```
kubectl vsphere login \
  --server wcp.haas-451.pez.pivotal.io \
  -u administrator@vsphere.local \
  --insecure-skip-tls-verify
  
kubectl vsphere login \
  --server wcp.haas-451.pez.pivotal.io \
  -u devops@vsphere.local \
  --insecure-skip-tls-verify
  
kubectl vsphere login \
  --tanzu-kubernetes-cluster-name MY-CLUSTER-NAME \
  --server wcp.haas-451.pez.pivotal.io \
  -u administrator@vsphere.local \
  --insecure-skip-tls-verify
```
