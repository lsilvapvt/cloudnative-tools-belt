## Basic Routing with a Contour Ingress Controller

This sample demonstrates the concept of services and ingress objects in Kubernetes by using the [Contour ingress controller](https://projectcontour.io/).

The [sample configuration file](./media-ingress-nginx.yml) in this repository deploys the following resources when applied to a Kubernetes cluster:

1. A `got` namespace
1. A `starks-deployment` containing two `starks-app` pods 
1. A `starks-svc` service for the pods in starks-deployment
1. A `lannisters-deployment` containing two `lannisters-app` pods
1. A `lannisters-svc` service for the pods in lannisters-deployment
1. An ingress config `got-ingress` that routes service traffic to the corresponding path. 

To create the objects above in your Kubernetes cluster:

1. Deploy the [Contour ingress controller](https://github.com/projectcontour/contour/blob/master/examples/contour/README.md#deploy-contour)  
   `kubectl apply -f https://projectcontour.io/quickstart/contour.yaml`

1. Deploy the pods, services and ingress configurations  
   `kubectl appy -f got-ingress-contour.yml`


After all objects are created successfully:

1. get the `EXTERNAL-IP` ADDRESS of the ingress `envoy` service for Contour: `kubectl get svc -n projectcontour`

1. create a DNS rule on your environment for your app root domain name with a wildcard that matches the one used in the ingress configuration.  
  For example:  `*.got.haas-208.pez.pivotal.io   10.195.72.192`  

1. curl the configured ingress paths. You should get the corresponding service's response.  
   For example:  
   ```
   $ curl http://starks.got.haas-208.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>Winter is coming! - 172.24.46.4</h1></body></html>

   $ curl http://lannisters.got.haas-208.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>A Lannister always pays his debts! - 172.24.46.2</h1></body></html>  
   ```   

---


