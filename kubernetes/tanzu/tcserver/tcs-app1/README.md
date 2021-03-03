# Tanzu Build Service - tc Server sample 1 - build with source code from git

1. Create a TBS image with source code from a git repository.

  Use either the imperative `kb` command:

    ```
    kp image create tcs-app1 \
    --tag lsilva.azurecr.io/tcs-app1 \
    --cluster-builder tcserverbuilder \
    --namespace default \
    --git https://github.com/lsilvapvt/sample-tc1.git \
    --git-revision main 
    ```

  OR the declarative `kubectl` definition files (see [kpack Image CRD specs](https://github.com/pivotal/kpack/blob/master/docs/image.md) ):

    ```
       kubectl apply -f tcs-app1-image.yml
    ```

    The Image instance with name `tcs-app1` is created in the cluster and its first build instance is triggered to produce a container image and then save that to the registry provided with the `--tag` parameter.

    To inspect the logs of the first build:

    `kp build logs tcs-app1 -b 1`

2. Deploy image to Kubernetes cluster

   `kubectl apply -f tcs-app2-deployment.yml`

3. Update the image definition to change buildpack behavior, e.g. the JVM version to be used

    Either use the imperative `kp` command:

    ```
        kp image patch tcs-app2 \
            --cluster-builder tcserverbuilder \
            --namespace default \
            --local-path ./src/ \
            --env BP_JVM_VERSION=8.* 
    ```

    OR, update the `tcs-app2-deployment.yml` definition file by un-commenting the `build env` entries and then apply the changes with `kubectl`:

    `kubectl apply -f tcs-app2-deployment.yml`
    