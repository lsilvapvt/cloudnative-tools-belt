# tc Server as a container - Notes

This folder contains notes and files created for the experiment to run tcServer as a container in a Kubernetes cluster by following the instructions from [tcServer documentation](https://tcserver.docs.pivotal.io/4x/docs-tcserver/topics/tcserver-kubernetes-howto.html).

---

## Building a tcServer Container Image with Dockerfiles

I used this folder's [Dockerfile](./Dockerfile) to create my container.

#### Pre-reqs 

I downloaded the pre-req bits from Tanzu Network using the [`pivnet` cli](https://github.com/pivotal-cf/pivnet-cli/releases).

- `pivnet download-product-files --product-slug pivotal-openjdk --release-version 1.8.0_242 --glob "openjdk-jdk-*-bionic.tar.gz"`

- `pivnet download-product-files --product-slug tc-server-4x-core --release-version 4.1.6 --glob "*.deb"`

- `pivnet download-product-files --product-slug tc-server-4x-runtimes --release-version 9.0.43.A --glob "*.deb"`


#### Building the Container

Command to build the container using my local docker cli:

- `docker build --tag vmware-pivotal-tcserver-standard:4.1.6 .`

Then I tagged the container and moved it to my public registry:

- `docker tag vmware-pivotal-tcserver-standard:4.1.6 myregistry-domain/vmware-pivotal-tcserver-standard:4.1.6`
- `docker push myregistry-domain/vmware-pivotal-tcserver-standard:4.1.6`

---

## tcServer on Kubernetes - Cluster Configuration and Sample App Deployment

Create secret to access your registry, if needed:

- `kubectl create secret docker-registry regcred --docker-server="myregistry-domain" --docker-username="USERID" --docker-password="PASSWORD" --docker-email="my@email.com"`

Create config map with tc server instance information (see [sample yaml file](tcserver-tomcat-sample-app-instance.yaml) used):

- `kubectl create configmap tcserver-tomcat-sample-app-instance --from-file=tcserver-tomcat-sample-app-instance.yaml`

- `kubectl apply -f tcserver-tomcat-sample-app-instance-pod.yaml`

- `kubectl logs tcserver-tomcat-sample-app-instance`

- `kubectl port-forward  tcserver-tomcat-sample-app-instance 8080:8080`

- `curl http://localhost:8080`

--- 

## Building a tcServer Container Image with Tanzu Build Service

[tcServer documentation](https://tcserver.docs.pivotal.io/4x/docs-tcserver/topics/tcserver-buildpack.html) highlights that VMware provides a Cloud Native Buildpack for tcServer.

This allows for the use of [Tanzu Build Service](https://docs.pivotal.io/build-service/1-1/index.html) as a modern cloud native tool to create and manage container images for tcServer instances.

1. Install Tanzu Build Service on a Kubernetes Cluster  
   https://docs.pivotal.io/build-service/installing.html  

2. Download the tcServer Cloud Native Buildpack  
   https://tcserver.docs.pivotal.io/4x/docs-tcserver/topics/tcserver-buildpack.html#downloading-the-vmware-tc-server-cloud-native-buildpack

3. Tag and push the builpack to a container registry
   `docker tag vmware-tcserver-buildpack:4.1.7 lsilva.azurecr.io/vmware-tcserver-buildpack:4.1.7

4. If needed, add a secret for the container registry  
   `kp secret create aks-registry-creds --registry lsilva.azurecr.io --registry-user USERID`

5. Add the tcServer buildpack to the TBS cluster store object
   `kp clusterstore add default -b lsilva.azurecr.io/vmware-tcserver-buildpack:4.1.7`

6. Create a custom cluster builder that includes the tcServer buildpack (see [sample](./tcb-builder.yaml))   
   `kubectl apply -f tcb-builder.yml`

7. Create a build image  
  ```
  kp image create myAppImage \
  --tag lsilva.azurecr.io/myAppImage \
  --cluster-builder tcserverbuilder \
  --namespace default \
  --git https://github.com/lsilvapvt/sample-tc1.git \
  --git-revision main
  ```

8. Check the build logs and, if the build is successful, find the new image in the repository under the `tag` defined in the command above  
   `kp build logs myAppImage -b 1`

---