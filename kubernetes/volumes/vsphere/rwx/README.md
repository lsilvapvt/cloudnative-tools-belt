## ReadWriteMany Persistent Volumes options in vSphere

According to [vSphere Storage for Kubernetes](https://vmware.github.io/vsphere-storage-for-kubernetes/documentation/index.html) documentation, the Dynamic Provisioning method for the [`VsphereVolume` plugin](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) supports only `ReadWriteOnly` mode. 

Having said that, then what would be the alternatives to have a `ReadWriteMany` persistent volume in a vSphere Kubernetes environment?

A sample use-case for this requirement would be for a set of applications that are required to share the same mounted volume with read and write access, regardless of whether or not they are deployed to the same Kubernetes cluster.

<img src="https://github.com/lsilvapvt/cloudnative-tools-belt/raw/master/kubernetes/common/images/rwx_app.png" alt="Application Architecture" width="300" align="center"/>

This repository documents the options that I have found so far, from the most simple to the more complex and scalable solution.

1. **Pods running on the same Kubernetes node**  
     
   Documentation mentions that when pods are deployed to the same Kubernetes Cluster node (i.e. Node Affinity), then the `VsphereVolume` plugin does support `ReadWriteMany` persistent volumes.  
     
   To get it working, [manually/statically create](https://vmware.github.io/vsphere-storage-for-kubernetes/documentation/persistent-vols-claims.html) the Persistent Volume instance with `ReadWriteMany` access mode. See [this example](./nodeAffinity/pv-pvc.yml) of a manifest file for both the PV and PVC.   
     
   Then deploy pods with node affinity that mount the same volume from the defined PVC above, as shown in [this example](./nodeAffinity/pods.yml).   

   To verify that each pod has written its init message to the shared volume, try a kubectl exec command like this: `kubectl exec rwx-pod1 -- ls -la /test-volume`   
     
   You should see files created by both pod1 and pod2 in that mounted directory.  

   The major 'con' for this option is the fact that pods can only run on the same node, which is very limited and not recommended for running Kubernetes workloads in production, where high availability of multiple pods deployed across nodes is desired.  

   <img src="https://github.com/lsilvapvt/cloudnative-tools-belt/raw/master/kubernetes/common/images/rwx_option1.png" alt="Application Architecture" width="400" align="center"/>
  
    

2. **In-cluster NFS Server as a service**   

   Follow this comprehensive and very well written [article from Cormac Hogan0(https://cormachogan.com/2019/06/20/kubernetes-storage-on-vsphere-101-readwritemany-nfs/) to implement this solution.  
     
   In summary, a nfs server pod is created and exposed as a ClusterIP service, so any pod running on that same cluster can mount the nfs drive with RWX access mode.  

   <img src="https://github.com/lsilvapvt/cloudnative-tools-belt/raw/master/kubernetes/common/images/rwx_option2.png" alt="Application Architecture" width="400" align="center"/>


3. **External NFS Server as a service**

   This is a variation of option (2) above, with the difference that the nfs server pod is exposed as a `LoadBalancer` type service, allowing it to be accessible from other clusters (as long as its service IP is routable from pods in other clusters).  

   See sample deployment files on this page's repository.  
   Run `kubectl apply -f 00-storage-class...` for each one of the files in numeric sequence.   

   Check the results by running `kubectl exec nfs-client-pod-1 -- ls -la /nfs` and verifying that there is one file written to the volume by each one of the two pods deployed.  

   Note: the NFS Server Provisioner can also be [deployed as a Helm Chart](https://hub.kubeapps.com/charts/stable/nfs-server-provisioner) instead.  
   
   <img src="https://github.com/lsilvapvt/cloudnative-tools-belt/raw/master/kubernetes/common/images/rwx_option3.png" alt="Application Architecture" width="800" align="center"/>  
     
   This approach also allows for VMs to mount the same volume provided by the NFS server, as long as they can route to the server's IP address.  
   For example, in an Ubuntu VM:  
   ```
   sudo apt-get update && sudo apt-get install nfs-common
   mkdir /home/ubuntu/exports
   sudo mount <NFS-server-IP>:/exports /home/ubuntu/exports
   ls -la /home/ubuntu/exports
   df -h
   ```

---
### WIP

**Object Storage servers/S3 buckets as a NFS service**

- Note 1: on GCP, the techniques found to use a GCE persistent disk in both [article1](https://github.com/mappedinn/kubernetes-nfs-volume-on-gke) and [article2](https://medium.com/platformer-blog/nfs-persistent-volumes-with-kubernetes-a-case-study-ce1ed6e2c266) leverage the same approach as described in option 3 above, meaning by creating an NFS server that serves a common shared storage as a PV/PVC. 

- Note 2: [CSI for S3](https://github.com/ctrox/csi-s3) along with a mounter such as [Goofys](https://github.com/kahing/goofys) might be a potential way to provide a shareable mount point backed by an object storage server, however when such server is not Amazon S3, compatibility and configuration of these open source packages have proved difficult so far. Moreover, there are disclaimers that such projects should be used with caution, as they have not yet been validated or benchmarked to run in production environments. 

- Note 3: [NFS Security](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.storage.doc/GUID-E8741AED-B66C-457E-A906-322746D79CCD.html)
