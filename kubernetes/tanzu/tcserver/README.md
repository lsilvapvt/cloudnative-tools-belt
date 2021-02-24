# tc Server as a container - Notes

This folder contains notes and files created for the experiment to run tcServer as a container in a Kubernetes cluster by following the instructions from [tcServer documentation](https://tcserver.docs.pivotal.io/4x/docs-tcserver/topics/tcserver-kubernetes-howto.html].

## Creating a container image with tcServer

I used this folder's [Dockerfile](./Dockerfile) to create my container.

#### Pre-reqs 

I downloaded the pre-req bits from Tanzu Network using the [`pivnet` cli](https://github.com/pivotal-cf/pivnet-cli/releases).

- `pivnet download-product-files --product-slug pivotal-openjdk --release-version 1.8.0_242 --glob "openjdk-jdk-*-bionic.tar.gz"`

- `pivnet download-product-files --product-slug tc-server-4x-core --release-version 4.1.6 --glob "*.deb"`

- `pivnet download-product-files --product-slug tc-server-4x-runtimes --release-version 9.0.43.A --glob "*.deb"`


#### Container build

Command to build the container using my local docker cli:

- `docker build --tag vmware-pivotal-tcserver-standard:4.1.6 .`

Then I tagged the container and moved it to my public registry:

- `docker tag vmware-pivotal-tcserver-standard:4.1.6 myregistry-domain/vmware-pivotal-tcserver-standard:4.1.6`
- `docker push myregistry-domain/vmware-pivotal-tcserver-standard:4.1.6`


#### Kubernetes cluster configuration and sample app deployment

Create secret to access your registry, if needed:

- `kubectl create secret docker-registry regcred --docker-server="myregistry-domain" --docker-username="USERID" --docker-password="PASSWORD" --docker-email="my@email.com"`

Create config map with tc server instance information (see [sample yaml file](tcserver-tomcat-sample-app-instance.yaml) used):

- `kubectl create configmap tcserver-tomcat-sample-app-instance --from-file=tcserver-tomcat-sample-app-instance.yaml`

- `kubectl apply -f tcserver-tomcat-sample-app-instance-pod.yaml`

- `kubectl logs tcserver-tomcat-sample-app-instance`

- `kubectl port-forward  tcserver-tomcat-sample-app-instance 8080:8080`

- `curl http://localhost:8080`

--- 