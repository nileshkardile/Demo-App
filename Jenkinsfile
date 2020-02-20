pipeline {
  environment {
    registry = "demoapp2020/Incedo123"
    registryCredential = 'docker-hub-credentials'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/nileshkardile/Demo-App.git'
      }
    }
    stage('Build & Create Docker') {
      steps{
        script {
          dockerImage = docker.build registry + ":Login-Form-$BUILD_NUMBER"
           bash '''#!/bin/bash
             #To clean older docker images
              sudo docker rmi -f $(docker images -a -q)
              set -o errexit
              VERSION=1.1.1
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

       '''
                 
        }
      }
    }
     stage('Docker Scan') {
      steps{
        script {
        }
        
    stage('Docker Push') {
      steps{
        script {
         bash '''#!/bin/bash
                 
          #Docker Login
echo Incedo123 | docker login --username demoapp2020 --password-stdin
#Push image to docker hub
sudo docker push ${PREFIX}/productpage:$TIMESTAMP
sudo docker push ${PREFIX}/details:$TIMESTAMP
sudo docker push ${PREFIX}/reviews:$TIMESTAMP
sudo docker push ${PREFIX}/ratings:$TIMESTAMP
         '''
        }
      }
    }
  }
}
