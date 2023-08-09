#!/bin/bash

int_handler() {
    echo "Interrupted..."
    # Kill the parent process of this script.
    kill $PPID
    exit 1
}

trap 'int_handler' INT

echo "Start"

BUILD_NUMBER="v1"
DOCKER_HUB="docker-ng-staging.northgrum.com"
IMAGE_NAME="${DOCKER_HUB}/kevinbwusa/s2-movie-info-service:${BUILD_NUMBER}"

echo "Creating Image..."
echo "IMAGE_NAME--- $IMAGE_NAME"
docker build -t $IMAGE_NAME .
# sudo docker login -u kevinbwusa -p${DOCKER_HUB}
docker push $IMAGE_NAME
echo "Deploying Image to Kubernetes..."
export KUBECONFIG=/home/ubuntu/kubeconfig/kubeConfig/kube-config-mil01-rana-cluster.yml
kubectl set image deployment.v1beta1.extensions/s2-movie-info-service-deployment s2-movie-info-service=$IMAGE_NAME
echo "End"
