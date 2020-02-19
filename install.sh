#!/bin/bash
# This script is used to build, create and push docker images of our demo micro services.

#set -xv
cd $home

#build docker image from existing code
echo $VERSION;

sudo /usr/bin/kubectl delete secret book-info-secret
sudo /usr/bin/kubectl create secret generic book-info-secret --from-literal=username='demoapp2010' --from-literal=password='Incedo123'


if [ "$VERSION" == "v1" ]; then 
#replace docker tag
sed -i "s/latest/$DOCKER_TAG/g" bookinfo/platform/kube/bookinfo.yaml
# create service and deployment for bookinfo
sudo /usr/bin/kubectl apply -f bookinfo/platform/kube/bookinfo.yaml

# create virtual service, gateway and destination rule for bookinfo
sudo /usr/bin/kubectl apply -f bookinfo/networking/virtual-service-all-v1.yaml
sudo /usr/bin/kubectl apply -f bookinfo/networking/gateway-demoapp.yaml
sudo /usr/bin/kubectl apply -f bookinfo/networking/destination-rule-demo-app.yaml

elif [ "$VERSION" == "v2" ]; then
#replace docker tag
sed -i "s/latest/$DOCKER_TAG/g" bookinfo/platform/kube/bookinfo_v2.yaml

sudo /usr/bin/kubectl apply -f bookinfo/platform/kube/bookinfo_v2.yaml

# add support for version 2 in virtual service and destination rule along with request weight
sudo /usr/bin/kubectl apply -f bookinfo/networking/virtual-service-demo-app-v2.yaml
sudo /usr/bin/kubectl apply -f bookinfo/networking/destination-rule-demo-app-v2.yaml

else

echo "Deployment Version is Mismatch ! Please provide v1 or v2";

fi
