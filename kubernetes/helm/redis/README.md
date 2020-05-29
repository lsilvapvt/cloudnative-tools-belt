## Redis Helm chart deployment notes

```
helm install redis bitnami/redis -n redis --set master.service.type=LoadBalancer,slave.service.type=LoadBalancer,cluster.slaveCount=1
```

```
export REDIS_PASSWORD=$(kubectl get secret --namespace redis redis2 -o jsonpath="{.data.redis-password}" | base64 --decode)
export SERVICE_IP=$(kubectl get svc --namespace redis redis2-master --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")   
redis-cli -h $SERVICE_IP -p 6379 -a $REDIS_PASSWORD
```

### To test it:
```
kubectl run --namespace redis redis1-client --rm --tty -i --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
   --image docker.io/bitnami/redis:5.0.8-debian-10-r47 -- bash
redis-cli -h redis2-master -a $REDIS_PASSWORD
redis-cli -h redis2-slave -a $REDIS_PASSWORD
```

Or use Redis Probe service: https://github.com/lsilvapvt/redis-probe 






