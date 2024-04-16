#!/bin/bash
# check $1
if [ -z "$1" ]; then
    echo "Error: Must provide first parameters"
    exit 1
fi
#0. create docker image:
#docker build -t auth-app . -f .kube/auth-app-docker.yml

#kind create cluster --name dev --config .kube/auth-app-cluster-dev.yml
#kind load docker-image auth-app:latest -n dev
#kubectl config use-context kind-dev
#kind delete cluster --name dev

#1. create cluster:
create="kind create cluster --name auth-app-cluster-$1 --config .kube/auth-app-cluster-$1.yml "
echo "$create"

sleep 60
#2. load local image:
load="kind load docker-image auth-app:latest -n auth-app-cluster-$1"
echo "$load"
sleep 60
# wait docker images load
#until kubectl get nodes -o jsonpath='{.items[*].status.images[*].names}' | grep -q "auth-app:latest"; do
#    sleep 60
#done
# check auth-app-cluster contexts existed
if kubectl config get-contexts | grep -q "auth-app-cluster-$1"; then
    echo "auth-app-cluster-$1 context exists, proceeding with operations..."
    sh="./apply-context-configs.sh $1"
    echo "$sh"
else
    echo "auth-app-cluster-$1 context does not exist, skipping operations."
fi


#last Command for Removing a Cluster:
#kind delete cluster --name auth-app-cluster
