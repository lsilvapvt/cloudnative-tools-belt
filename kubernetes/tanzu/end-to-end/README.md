# Tanzu End-to-end demo notes

- Create AKS cluster in Azure (4 worker nodes)
```
az login
az aks get-credentials --name acme-bank-services --resource-group <resrouce group> --context acme-bank-services-aks
kubectl config use-context acme-bank-services-aks
```

- Create a TKG cluster for the microservices
  See sample of TKG on vSphere 7 with Kubernetes manifest file [in this repo](./TKG-Cluster-acme-bank-services.yml).  
```
kubectl vsphere login   --tanzu-kubernetes-cluster-name acme-bank-services-cluster   --server wcp.haas-451.pez.pivotal.io   -u administrator@vsphere.local   --insecure-skip-tls-verify
kubectl config use-context acme-bank-services-cluster
```

- Create a DevOps cluster for Harbor and the Azure DevOps agent 
  See sample of TKG on vSphere 7 with Kubernetes manifest file [in this repo](./TKG-Cluster-devops.yml).  
```
kubectl vsphere login   --tanzu-kubernetes-cluster-name devops-cluster   --server wcp.haas-451.pez.pivotal.io   -u administrator@vsphere.local   --insecure-skip-tls-verify
kubectl vsphere login   --server wcp.haas-451.pez.pivotal.io   -u administrator@vsphere.local   --insecure-skip-tls-verify
```  

- Make cluster storage class default:  
  `kubectl patch storageclass pacific-gold-storage-policy -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'`  

- Deploy an Azure DevOps agent to Kubernetes in TKG: https://github.com/lsilvapvt/pcf-tools-belt/tree/master/azure/devops/agent 

- Deploy Harbor as a Helm Chart to the DevOps agent   
  https://github.com/lsilvapvt/pcf-tools-belt/tree/master/kubernetes/helm/harbor  
  Create `dev` and `prod` projects in Harbor. 

- Attach the first two clusters to a Tanzu Mission Control organization  

- Create a Azure Dev Ops Project

- Create an Azure DevOps pipeline for the application build  
  Publish the created container image to Harbor  

- Deploy the Wavefront agent to the microservices clusters   
  https://github.com/lsilvapvt/pcf-tools-belt/tree/master/wavefront#wavefront-kubernetes-cluster-agent-with-a-tag-for-metrics   

- Create a dashboard in Wavefront for the two microservices clusters   
  https://github.com/lsilvapvt/pcf-tools-belt/tree/master/wavefront#wavefront-kubernetes-cluster-agent-with-a-tag-for-metrics  

- Configure Tanzu Service Mesh agent and dashbord for the microservices   
  Onboard cluster, create GNS, install Istio system  - 2nd step of onboard, configure DNS/Spring Config Map

---




