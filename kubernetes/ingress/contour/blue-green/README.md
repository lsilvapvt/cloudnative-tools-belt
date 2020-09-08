## Blue-Green Deployment and Routing with a Contour Ingress Controller

This sample demonstrates the concept of blue-green deployment and routing of services and ingress objects in Kubernetes by using the [Contour ingress controller](https://projectcontour.io/).

The sample configuration files in this repository deploy the following resources when applied to a Kubernetes cluster:

1. A `bluegreen` namespace
1. A `blue-deployment` containing one `blue-app` pod
1. A `blue-svc` service for the pod in blue-deployment
1. A `green-deployment` containing one `green-app` pod
1. A `green-svc` service for the pods in green-deployment
1. A `blue-green-root` ingress routing config that controls which service (blue or green) the app traffic will be routed to.

To create the objects above in your Kubernetes cluster:

1. Deploy the [Contour ingress controller](https://github.com/projectcontour/contour/blob/master/examples/contour/README.md#deploy-contour)  
   `kubectl apply -f https://projectcontour.io/quickstart/contour.yaml`

1. Deploy the blue workload and service
   `kubectl appy -f blue-workload.yml`

1. Deploy the green workload and service
   `kubectl appy -f green-workload.yml`

1. Deploy the contour blue-green ingress routing objects
   `kubectl appy -f contour-ingress-bluegreen.yml`


After all objects are created successfully:

1. get the `EXTERNAL-IP` ADDRESS of the ingress `envoy` service for Contour:  
   `kubectl get svc -n projectcontour`

1. create a DNS rule on your environment for your app root domain name with a wildcard that matches the one used in the ingress configuration.  
  For example:  `*.tkg.haas-426.pez.pivotal.io   10.195.72.192`  

1. curl the configured app path.  
   For example:  
   ```
   $ curl http://myservice.tkg.haas-426.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>BLUE! - 172.24.46.4</h1></body></html>
   ```

1. Change the weight for the rounting to "Green" to 100 in `contour-ingress-bluegreeen.yml`
   ```
   ...
   routes: 
      - conditions:
         - prefix: /  
         services:
         - name: blue-svc
            port: 80
            weight: 0
         - name: green-svc
            port: 80
            weight: 100  
   ```  
   and apply the changes `kubectl apply -f contour-ingress-bluegreen.yml`

1. curl the configured app path again.  
   For example:  
   ```
   $ curl http://myservice.tkg.haas-426.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>GREEN! - 172.24.46.4</h1></body></html>
   ```

---


