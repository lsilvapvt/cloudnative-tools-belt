# OpenLDAP Notes

## Helm chart installation notes

Source: https://hub.kubeapps.com/charts/stable/openldap

Sample install command:
```
kubectl create namespace openldap
helm install openldap -n openldap stable/openldap --set service.type=LoadBalancer,persistence.storageClass=lun
```

## Configure memberOf overlay module

SSH into the openldap pod and run the command below to configure the `memberOf` [overlay](https://www.openldap.org/doc/admin24/overlays.html) typically required for LDAP authentication by other systems. This instructions came from [this article](https://tylersguides.com/guides/openldap-memberof-overlay/).

1. ssh into the openldap pod  
   `kubectl exec <pod-id> -n openldap -it -- /bin/bash`  
   

2. Check the name of the OpenLdap database  
   `slapcat -n 0 | grep olcDatabase:`  
   Make sure that the {1} database ID matches the one used in line 1 of the ldif content in the next step. e.g. `olcDatabase: {1}hdb`  
     

3. Execute the following command:  
   
   `ldapadd -Y EXTERNAL -H ldapi:///`  
     
   Then paste the ldif content below followed by `Ctrl+D`:  
     
   ```  
   dn: olcOverlay=memberof,olcDatabase={1}hdb,cn=config  
   objectClass: olcOverlayConfig  
   objectClass: olcMemberOf  
   olcOverlay: memberof  
   olcMemberOfRefint: TRUE  
   ```  

   You should see a successful return message such as `adding new entry "olcOverlay=memberof,olcDatabase={1}hdb,cn=config"`  

   Exit out of the ssh session with the openldap pod.  


4. Execute the following command to create test data:  
     
   ```  
   ldapadd -H ldap://<openldap-service-ip>:389 -D "cn=admin,dc=example,dc=org" -w <openldap-admin-password> -f ./openldap_test_data.ldif
   ```  

5. Search for user entries with the `memberOf` field.  

   ```  
   ldapsearch -x ldap://<openldap-service-ip>:389 -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w <openldap-admin-password> memberof
   ```  
     
   You should see an entry containing field memberOf such as:  
   `memberOf: cn=admins,ou=groups,dc=example,dc=org`  


The LDAP server is now ready to be tested for authentication integration with other systems.

--- 

#### Notes

- Typical configuration for authentication with this LDAP server setup  
    
  LDAP URL: `ldap://<openldap-service-ip>:389`  
  LDAP Search DN: `cn=admin,dc=example,dc=org`  
  LDAP Search Password: `<your-openldap-admin-password>`  
  LDAP Base DN: `dc=example,dc=org`  
  LDAP UID: `cn`  
  LDAP Scope: `Subtree`  

  LDAP Group Base DN: `ou=groups,dc=example,dc=org`  
  LDAP Group GID: `cn`  
  LDAP Group Admin DN: `cn=admins,ou=groups,dc=example,dc=org`  
  LDAP Group Membership: `memberOf`  
  LDAP Scope: `Subtree`  
    
  Reference: [Harbor's LDAP auth configuration](https://goharbor.io/docs/1.10/administration/configure-authentication/ldap-auth/).  


- Online LDAP test server: [link](https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/)  

---

