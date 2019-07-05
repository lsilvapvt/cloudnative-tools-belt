### Sample bash script to run from the OpsMgr VM
### It downloads PKS tile's files from PivNet and then uploads tile to local OpsMgr server
###
### Three environment variables are required to be defined:
### export PIVNET_TOKEN=
### export OM_USERNAME=
### export OM_PASSWORD=
###
PKS_TILE_VERSION="1.4.1"
### get PIVNET CLI and login to PIVNET
wget --content-disposition https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.60/pivnet-linux-amd64-0.0.60
mv pivnet* pivnet
chmod a+x pivnet
./pivnet login --api-token $PIVNET_TOKEN
### get PKS tile from pivnet
./pivnet download-product-files -p pivotal-container-service -r $PKS_TILE_VERSION -g '*.pivotal'

### get OM cli
wget --content-disposition https://github.com/pivotal-cf/om/releases/download/1.2.0/om-linux
mv om-linux om
chmod a+x om
### upload PKS tile to local OpsMgr VM
./om -t 127.0.0.1 -u $OM_USERNAME -p $OM_PASSWORD -k upload-product --product *.pivotal

### COPY PKS and KUBECTL to local VM
./pivnet download-product-files -p pivotal-container-service -r $PKS_TILE_VERSION -g 'pks-linux*'
chmod +x ./pks-linux*
sudo mv ./pks-linux* /usr/local/bin/pks
./pivnet download-product-files -p pivotal-container-service -r $PKS_TILE_VERSION -g 'kubectl-linux*'
chmod +x ./kubectl-linux*
sudo mv ./kubectl-linux* /usr/local/bin/kubectl
