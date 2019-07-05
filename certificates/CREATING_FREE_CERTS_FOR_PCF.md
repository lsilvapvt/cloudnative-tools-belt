# Create Certificates for PCF sandbox deployments

How to create certificates from a known CA for SandBox deployments of Pivotal Application Service (PAS) or Pivotal Container Services (PKS) using https://wiki.acme.sh/ :

1. Install `acme.sh`: https://github.com/Neilpang/acme.sh/wiki/How-to-install  
   The `acme.sh` tool is installed by default in `~/.acme.sh/`

2. Run `acme.sh` and create certificates  

   Example for a PKS deployment:   
   `acme.sh --issue --dns dns_aws -d "*.pks.mydomain.io"`  

   Example for a PAS deployment:   
   `acme.sh --issue --dns dns_aws -d "*.pas.mydomain.io" -d "*.sys.pas.mydomain.io" -d "*.apps.pas.mydomain.io" -d "*.uaa.sys.pas.mydomain.io" -d "*.login.sys.pas.mydomain.io"`  

   Certificate and private key is created by default in corresponding subfolder under `~/.acme.sh/`  

3. Copy contents of generated CA, Certificate and Private key into corresponding PAS/PKS configuration fields.
