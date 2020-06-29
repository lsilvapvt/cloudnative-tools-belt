## Wavefront notes

### Install agent to Kubernetes cluster

```
kubectl create namespace wavefront

helm install wavefront wavefront/wavefront --set wavefront.url=https://vmware.wavefront.com --set wavefront.token=MY-WAVEFRONT-TOKEN --set clusterName=my-cluster --namespace wavefront
```

---
## Wavefront Kubernetes cluster agent with a tag for metrics

Note in the [`wavefront-values.yaml`](./wavefront-values.yaml) file that a tag is added to the cluster metrics sent to Wavefront.  

```
kubectl create namespace wavefront
helm install wavefront wavefront/wavefront --set wavefront.url=https://vmware.wavefront.com --set wavefront.token=<wavefront-token> --set clusterName=acme-bank-services-tkg --namespace wavefront -f wavefront-values.yaml
```  

Create a Kubernetes clusters dashboard in Wavefront configured with the added metrics tag.   
See [exported sample dashboard JSON file](./acme-bank-cluster-dashboard-wavefront.json).

---
