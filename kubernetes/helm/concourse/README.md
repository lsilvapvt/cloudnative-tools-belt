## Concourse Helm chart deploy notes

Notes and files created while deploying Concourse Helm chart to a Kubernetes cluster using instruction from [Josh Ghiloni's article](https://medium.com/concourse-ci/installing-concourse-5-0-on-pivotal-container-service-using-helm-9f20e4e1b8bf
).

### Prepare your desktop

1. Install Helm cli  
   `brew install kubernetes-helm`

### Prepare your cluster

1. Create service account for tiller  
   `kubectl apply -f tiller-config.yaml`  

1. Initialize tiller for the cluster  
   `helm init --service-account tiller`  

1. For PKS only - create storageConfig object  
   `kubectl apply -f storage-config-pks.yml`      
  

### Prepare helm chart parameters file

1. Create a [`values.yml`](https://github.com/helm/charts/blob/master/stable/concourse/values.yaml) file with appropriate parameters.  
   See examples for [GCP](gcp-values.yml) and [PKS](pks-values.yml) in this repository.  
   Sample commands to generate all keys and certificates for `value.yml`:  
  
   `keysLocation=$HOME/.ssh/concourse-helm/gcp`
  
   `docker run -v {$keysLocation}:/keys -it concourse/concourse generate-key -t ssh -f /keys/host_key`  
   Update `hostKey` param with `{$keysLocation}/hostKey`  
   Update `hostKeyPub` param with `{$keysLocation}/hostKey.pub`  
  
   `docker run -v {$keysLocation}:/keys -it concourse/concourse generate-key -t ssh -f /keys/worker_key`  
   Update `workerKey` param with `{$keysLocation}/workerKey`  
   Update `workerKeyPub` param with `{$keysLocation}/workerKey.pub`  
  
   `docker run -v {$keysLocation}:/keys -it concourse/concourse generate-key -t rsa -f /keys/session_signing_key`  
   Update `sessionSigningKey` param with `{$keysLocation}/session_signing_key`  
  
   `openssl req -newkey rsa:2048 -nodes -keyout {$keysLocation}/concourse.key -x509 -days 365 -out {$keysLocation}/concourse.crt`  
   Update `webTlsKey` param with `{$keysLocation}/concourse.key`  
   Update `webTlsCert` param with `{$keysLocation}/concourse.crt`  

### Deploy concourse using Helm cli 
   `helm install --name concourse -f values.yml stable/concourse`  

---

### Issue found when deploying to PKS

Created PVCs for worker and postgresql pods do not include `storageClass` parameter even when provided in `values.yml`.

*Workaround:*
Manually update the PVC definitions and add storageClass param for each PVC.
`kubectl get pvc`
1. Get PVC yaml for each pvc
```
kubectl get pvc concourse-work-dir-concourse-worker-1 -o yaml > pvc.yml
kubectl delete pvc -f pvc.yml
```
1. Update the pvc file with storageClassName: 
```
spec:
  storageClassName: concourse-storage-class
```

1. Save the yml file and recreate the PVC
`kubectl apply -f pvc.yml`

PVC will then get bound successfully and pods will get initialized correctly.
