#!/bin/sh
PROG="aws-es-proxy"
V=$1

if test -z $DOCKERREPO ; then
   echo "need to export $DOCKERREPO"
   exit
fi

IMAGEID=`sudo docker images|grep $PROG|awk '{print $3 }'`
echo "#################################"
echo "Cleanup any old docker images for $PROG => $V"
echo $IMAGEID
for I in $IMAGEID; do
   sudo docker rmi -f $I >/dev/null
done

sleep 5

echo "#################################"
echo "Make a new binary for $PROG => $V"
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -a -installsuffix cgo -ldflags '-w' -o aws-es-proxy github.com/sharecare/aws-es-proxy

echo "#################################"
echo "Make a docker container and upload it for $PROG => $V"
sudo docker build -t siteops/$PROG .
IMAGEID=`sudo docker images|grep $PROG|awk '{print $3 }'`
sudo docker tag $IMAGEID $DOCKERREPO/$PROG:v$V

echo "#################################"
echo "Upload container to repo for: $PROG => $V"
sudo docker push $DOCKERREPO/$PROG:v$V

