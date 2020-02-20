def DOCKER_VERSION ='1.0.0';
pipeline {
  environment {
    registry = "demoapp2020/Incedo123"
    registryCredential = 'docker-hub-credentials'
    dockerImage = ''
	
  }
  agent any
  stages {
    stage('Initialize the variables') {
            // Each stage is made up of steps
            steps{
                script{
                    DOCKER_VERSION="1.0.0.${BUILD_NUMBER}"
			println "version: ${DOCKER_VERSION}"
                }
            }                
     }
    stage('Checkout') {
      steps {
        git 'https://github.com/nileshkardile/Demo-App.git'
      }
    }
    stage('Build & Create Docker') {
      steps{
        script {
              println "version1: ${DOCKER_VERSION}"  
             sh """#!/bin/bash
             #To clean older docker images
              sudo docker rmi -f \$(docker images -a -q)
              set -o errexit
              VERSION=1.0.0
              PREFIX=demoapp2020
              echo "Version2: "+ \${DOCKER_VERSION}
              #TIMESTAMP=\$(date +%Y%m%d%H%M%S)
              export home=/var/lib/jenkins/workspace/CI_Demo-App-Pipeline_master/bookinfo/src
              cd $home
              SCRIPTDIR=$home
              pushd \"\$SCRIPTDIR/productpage\"

docker build --pull -t \"\${PREFIX}/productpage:\${VERSION}\" -t \"\${PREFIX}/productpage:\${DOCKER_VERSION}\" .
popd

pushd "$SCRIPTDIR/details"
  #plain build -- no calling external book service to fetch topics
  docker build --pull -t \"\${PREFIX}/details:\${VERSION}\" -t \"\${PREFIX}/details:\${DOCKER_VERSION}\" --build-arg service_version=v1 .
popd

pushd \"\$SCRIPTDIR/reviews\"
  #java build the app.
  docker run --rm -u root -v \"\$(pwd)\":/home/gradle/project -w /home/gradle/project gradle:4.8.1 gradle clean build
  pushd reviews-wlpcfg
    #plain build -- no ratings
    docker build --pull -t \"\${PREFIX}/reviews:\${VERSION}\" -t \"\${PREFIX}/reviews:\${DOCKER_VERSION}\" --build-arg service_version=v1 .
  popd
popd

pushd \"\$SCRIPTDIR/ratings\"
  docker build --pull -t \"\${PREFIX}/ratings:\${VERSION}\" -t \"\${PREFIX}/ratings:\${DOCKER_VERSION}\" --build-arg service_version=v1 .
popd
               """
       }
      }
    }
     stage('Docker Push') {
      steps{
        script {
          
        sh '''#!/bin/bash
           
          #Docker Login
echo Incedo123 | docker login --username demoapp2020 --password-stdin
echo "Version Number3: "+ ${DOCKER_VERSION}
#Push image to docker hub
sudo docker push ${PREFIX}/productpage:${DOCKER_VERSION}
sudo docker push ${PREFIX}/details:${DOCKER_VERSION}
sudo docker push ${PREFIX}/reviews:${DOCKER_VERSION}
sudo docker push ${PREFIX}/ratings:${DOCKER_VERSION}
               '''
        }
      }
    }
  }
}
