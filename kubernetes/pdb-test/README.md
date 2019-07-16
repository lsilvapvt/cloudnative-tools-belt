## Notes on Kubernetes Pod Disruption Budgets - PDB

[Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#how-disruption-budgets-work) objects allow you to define a policy for the minimum number of workload instances running on a cluster at any given point in time.

You basically define either the `minimum number of instances available` or the `maximum number of instances unavailable` for a deployment in the cluster and Kubernetes will enforce that for you.

While this is a great feature of Kubernetes, one has to keep in mind that a PDB policy may also prevent a Kubernetes node to be appropriately drained/turned off (e.g. for an OS upgrade/patch) when such action violates the policy definition. Corrective actions may be required to proceed with the node update or to `uncordon` it.

### Testing how K8s enforces PDBs

To see PDB enforcement in action, see documentation on [how to configure PDB](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) and/or perform the following steps:

1. On a Kubernetes cluster configured with 3 nodes deploy [nginx-deployment.yml](nginx-deployment.yml)  

   `kubectl apply -f nginx-deployment.yml`    

2. Then apply the PDB policy [nginx-pdb.yml](nginx-pdb.yml) for the nginx application  

   `kubectl apply -f nginx-pdb.yml`   

   To check if the policy was appropriately applied: `kubectl get poddisruptionbudgets`  

3. Attempt to drain one of the cluster nodes  

   List the cluster's nodes: `kubectl get nodes` and select one of the node names.  

   Then issue command:  

   `kubectl drain <node-name> --delete-local-data --ignore-daemonsets --timeout=60s`   


An error should be returned not allowing the action to be performed due to the applied PDB policy:  
```  
kubectl drain ip-10-0-0-0.us-east-2.compute.internal   

node/ip-10-0-0-0.us-east-2.compute.internal already cordoned
WARNING: ignoring DaemonSet-managed Pods: ...
evicting pod ...
evicting pod ...
evicting pod "nginx-deployment-12345"
error when evicting pod "nginx-deployment-12345" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
evicting pod "nginx-deployment-12345"
error when evicting pod "nginx-deployment-12345" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
...
There are pending pods in node "ip-10-0-0-0.us-east-2.compute.internal" when an error occurred: drain did not complete within 60s
error: unable to drain node "ip-10-0-0-0.us-east-2.compute.internal", aborting command...
```

### Potential corrective actions for the scenario above

Before retrying the `drain` command, inspect the PDB applied to the pod whose eviction
failed and adjust the number of instances to satisfy the policy's parameters.

For example, for our test application and PDB, if we increase the number of `replicas`
for the nginx deployment to `4`, that will satisfy the PDB policy even after
one of the nodes is drained. Only then we can retry the drain of that one node above.

In case you prefer to abort the node drain procedure to retry it later, notice from the command
output above that Kubernetes automatically `cordon` the node during the `drain` command.
The node status remains as `SchedulingDisabled` even after the command is finished or timed out.
Thus, if you want pods to continue to be assigned to that node until your next drain retry,
you need to `uncordon` the node using the `kubectl uncordon <node-id>` command.
