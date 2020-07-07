## Notes to deploy the Minio Helm Chart

- Source: https://hub.kubeapps.com/charts/bitnami/minio

- Sample command:   
  `helm install minio bitnami/minio -n minio --set global.storageClass=lun -f minio-values.yml`  

---

Once deployed, MinIO can be accessed via port 9000 on the following DNS name from within your cluster: `minio.minio.svc.cluster.local`

To get your credentials run:
```
   export MINIO_ACCESS_KEY=$(kubectl get secret --namespace minio minio -o jsonpath="{.data.access-key}" | base64 --decode)
   export MINIO_SECRET_KEY=$(kubectl get secret --namespace minio minio -o jsonpath="{.data.secret-key}" | base64 --decode)
```

To connect to your MinIO server using a client:

- Run a MinIO Client pod and append the desired command (e.g. 'admin info server'):
```
   kubectl run --namespace minio minio-client \
     --rm --tty -i --restart='Never' \
     --env MINIO_SERVER_ACCESS_KEY=$MINIO_ACCESS_KEY \
     --env MINIO_SERVER_SECRET_KEY=$MINIO_SECRET_KEY \
     --env MINIO_SERVER_HOST=minio \
     --image docker.io/bitnami/minio-client:2020.6.26-debian-10-r5 -- admin info server minio
```

To access the MinIO web UI:

```
   export SERVICE_IP=$(kubectl get svc --namespace minio minio --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")

   echo "MinIO web URL: http://$SERVICE_IP:9000/minio"
```   