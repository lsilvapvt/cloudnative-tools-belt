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
### Setting the default storage class for a cluster

Before installing helm charts, it helps to make sure that you have a default storage class setup for your cluster and targeted namespace:

`kubectl patch storageclass pacific-gold-storage-policy -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' -n my-namespace`

---