# Tanzu Build Service - - tc Server sample 1 - build with local source

1. Build TBS image with source code from local machine:

  ```
    kp image create tcs-app2 \
    --tag lsilva.azurecr.io/tcs-app2 \
    --cluster-builder tcserverbuilder \
    --namespace default \
    --local-path ./src/ 
  ```

  The Image instance with name `tcs-app2` is created in the Kubernetes cluster and the first build instance is automatically triggered to produce a container image and then save that to the registry provided with the `--tag` parameter.

2. Deploy image to Kubernetes cluster

   `kubectl apply -f tcs-app2-deployment.yml`

3. Update the image definition to change buildpack behavior, e.g. the JVM version to be used

  ```
    kp image patch tcs-app2 \
    --cluster-builder tcserverbuilder \
    --namespace default \
    --local-path ./src/ \
    --env BP_JVM_VERSION=9.* 
  ```
