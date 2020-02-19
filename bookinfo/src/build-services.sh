#!/bin/bash
#
# Copyright 2017 Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#To clean older docker images
sudo docker rmi -f $(docker images -a -q)
set -o errexit

set -o errexit

if [ "$#" -ne 1 ]; then
    echo "Incorrect parameters"
    echo "Usage: build-services.sh <version> "
    exit 1
fi

VERSION=$1
PREFIX=demoapp2020
TIMESTAMP=$(date +%Y%m%d%H%M%S)
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

pushd "$SCRIPTDIR/productpage"
  docker build --pull -t "${PREFIX}/productpage:${VERSION}" -t "${PREFIX}/productpage:$TIMESTAMP" .
popd

pushd "$SCRIPTDIR/details"
  #plain build -- no calling external book service to fetch topics
  docker build --pull -t "${PREFIX}/details:${VERSION}" -t "${PREFIX}/details:$TIMESTAMP" --build-arg service_version=v1 .
popd

pushd "$SCRIPTDIR/reviews"
  #java build the app.
  docker run --rm -u root -v "$(pwd)":/home/gradle/project -w /home/gradle/project gradle:4.8.1 gradle clean build
  pushd reviews-wlpcfg
    #plain build -- no ratings
    docker build --pull -t "${PREFIX}/reviews:${VERSION}" -t "${PREFIX}/reviews:$TIMESTAMP" --build-arg service_version=v1 .
  popd
popd


pushd "$SCRIPTDIR/ratings"
  docker build --pull -t "${PREFIX}/ratings:${VERSION}" -t "${PREFIX}/ratings:$TIMESTAMP" --build-arg service_version=v1 .
popd

#Docker Login
echo Incedo123 | docker login --username demoapp2020 --password-stdin

#Push image to docker hub

sudo docker push ${PREFIX}/productpage:$TIMESTAMP
sudo docker push ${PREFIX}/details:$TIMESTAMP
sudo docker push ${PREFIX}/reviews:$TIMESTAMP
sudo docker push ${PREFIX}/ratings:$TIMESTAMP











