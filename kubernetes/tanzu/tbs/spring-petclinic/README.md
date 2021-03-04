# Spring Pet Clinic - sample app builds with TBS 

### kp command

    ```
    kp image create petclinic \
    --tag lsilva.azurecr.io/petclinic \
    --cluster-builder tcserverbuilder \
    --namespace default \
    --git https://github.com/lsilvapvt/spring-petclinic.git \
    --git-revision main
    ```

    OR use `kubectl apply -f ./petclinic-image.yml`

### Deploy to Kubernetes

    `kubectl apply -f ./petclinic-deployment.yaml`