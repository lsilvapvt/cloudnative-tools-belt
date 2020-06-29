# Notes on Harbor install and operations

- [Harbor documentation](https://docs.pivotal.io/partners/vmware-harbor/using.html)
- [Harbor Helm git repository](https://github.com/goharbor/harbor-helm)
- [Harbor Helm on Kubeapps](https://hub.kubeapps.com/charts/bitnami/harbor)
- [Harbor demonstration videos](https://github.com/goharbor/harbor/wiki/)

## Harbor Helm install

Sample commmands:

`helm install harbor bitnami/harbor -n harbor --set global.storageClass=pacific-gold-storage-policy -f ./harbor-values.yaml`

`helm upgrade harbor bitnami/harbor -n harbor --set global.storageClass=pacific-gold-storage-policy  -f ./harbor-values.yaml --reuse-values` 

---
## Login to Harbor using the local docker cli:

- click on your `Docker Desktop icon > Preference > Docker Engine`
- add/update the "insecure-registries" entry of the config file with the harbor server FQDN/IP
```
  {
      ...
     "insecure-registries": [
        ...
        "my-harbor-fqdn-or-ip-address"
     ]
  }
```
- click Apply and Restart button
- wait until docker daemon is restarted
- on the command line, "docker login <my-harbor-fqdn-or-ip-address>"
     
# Push an image to Harbor

  - change the tag of the image to contain the harbor FQDN prefix
     e.g.   `docker tag nginx:latext <my-harbor-fqdn-or-ip-address>/<project>/nginx`
  - docker push the tagged image
     e.g. `docker push <my-harbor-fqdn-or-ip-address>/<project>/nginx`

---
## Harbor Notary and Trust 

- [Harbor Notary demonstration video](https://www.youtube.com/watch?v=pPklSTJZY2E)
- [Notary Client configuration](https://docs.docker.com/notary/reference/client-config/)
- [Get started with Notary](https://docs.docker.com/notary/getting_started/)

```
export DOCKER_CONTENT_TRUST=1
export DOCKER_CONTENT_TRUST_SERVER=https://<my-harbor-fqdn-or-ip-address>:4443
notary list <my-harbor-fqdn-or-ip-address>/dev/web-ui  -s $DOCKER_CONTENT_TRUST_SERVER -d ~/.docker/trust --tlscacert ~/.docker/myharbor.crt
```
---









 
