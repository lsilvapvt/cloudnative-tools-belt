## Wavefront notes

### Install agent to Kubernetes cluster

```
kubectl create namespace wavefront

helm install wavefront wavefront/wavefront --set wavefront.url=https://vmware.wavefront.com --set wavefront.token=MY-WAVEFRONT-TOKEN --set clusterName=my-cluster --namespace wavefront
```