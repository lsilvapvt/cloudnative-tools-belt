## Weighted routing with a Contour Ingress Controller

This sample demonstrates the concept of weighted application and routing of services and ingress objects in Kubernetes by using the [Contour ingress controller](https://projectcontour.io/).

The sample configuration files in this repository deploy the following resources when applied to a Kubernetes cluster:

1. A `weighted-routing` namespace
1. A `myapp-deployment-v10` deployment containing one `myapp-v1.0` pod
1. A `myapp-svc-v10` service for the pod in myapp-deployment-v10
1. A `myapp-deployment-v11` containing one `myapp-v1.1` pod
1. A `myapp-svc-v11` service for the pods in myapp-deployment-v11
1. A `myapp-root` ingress routing config that controls which service (v1.0 or v1.1) the app traffic will be routed to on a weighted basis.

To create the objects above in your Kubernetes cluster:

1. Deploy the [Contour ingress controller](https://github.com/projectcontour/contour/blob/master/examples/contour/README.md#deploy-contour)  
   `kubectl apply -f https://projectcontour.io/quickstart/contour.yaml`

1. Deploy the v1.0 app workload and service
   `kubectl appy -f myapp-v1.0.yml`

1. Deploy the v1.1 app workload and service
   `kubectl appy -f myapp-v1.1.yml`

1. Deploy the contour weighted ingress routing objects
   `kubectl appy -f contour-ingress-weighted.yml`


After all objects are created successfully:

1. get the `EXTERNAL-IP` ADDRESS of the ingress `envoy` service for Contour:  
   `kubectl get svc -n projectcontour`

1. create a DNS rule on your environment for your app root domain name with a wildcard that matches the one used in the ingress configuration.  
  For example:  `*.go.haas-208.pez.pivotal.io   10.195.72.192`  

1. curl the configured myapp path. You should see more of the v1.0 app responses since its route weith is higher (90%).
   For example:  
   ```
   $ curl http://myapp.go.haas-208.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>v1.0! - 172.24.46.4</h1></body></html>
   ```

1. Change the weight for each app version to 50/50 in `contour-ingress-weighted.yml`
   ```
   ...
      - match: /
         services:
            - name: myapp-svc-10
            port: 80
            weight: 50
            - name: myapp-svc-11
            port: 80
            weight: 50
   ```  
   and apply the changes `kubectl apply -f contour-ingress-weighted.yml`

1. curl the configured myapp path again. You should see an even number of responses from each myapp version.
   For example:  
   ```
   $ curl http://myapp.go.haas-208.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>v1.1! - 172.24.46.4</h1></body></html>
   ```

---


