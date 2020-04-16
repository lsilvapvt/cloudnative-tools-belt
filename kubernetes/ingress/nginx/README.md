## Test Kubernetes Ingress with an NGINX Controller

This sample demonstrates the concept of services and ingress objects in Kubernetes by using the [Nginx ingress controller](https://kubernetes.github.io/ingress-nginx/).

The [sample configuration file](./media-ingress-nginx.yml) in this repository deploys the following resources when applied to a Kubernetes cluster:

1. A `media` namespace
1. A `music-deployment` containing two `music-app` pods 
1. A `music-svc` service for the pods in music-deployment
1. A `video-deployment` containing two `video-app` pods
1. A `video-svc` service for the pods in video-deployment
1. An ingress config `media-ingress` that routes service traffic to the corresponding path. 

To create the objects above in your Kubernetes cluster:

`kubectl appy -f media-ingress-nginx.yml`


Once all objects are created successfully:

1. get the IP `ADDRESS` of the ingress service created: `kubectl get ingress media-ingress -n media`

1. create a DNS rule on your environment for your app root domain name with a wildcard that matches the one used in the ingress configuration.  
  For example:  `*.svc.haas-208.pez.pivotal.io   10.195.72.192`  

1. curl the configured ingress paths. You should get the corresponding service's response.  
   For example:  
   ```
   $ curl http://music.svc.haas-208.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>Welcome to the MUSIC application - 172.24.46.4 !</h1></body></html>

   $ curl http://video.svc.haas-208.pez.pivotal.io
     <!DOCTYPE html><html><body><h1>Welcome to the VIDEO application - 172.24.46.2 !</h1></body></html>  
   ```   

---


