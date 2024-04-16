#!/bin/bash
# check $1
#if [ -z "$1" ]; then
#    echo "Error: Must provide first parameters"
#    exit 1
#fi
##3. swicth context:
#context="kubectl config use-context kind-auth-app-cluster-$1"
#echo "$context"

#5. create metallb:
kubectl apply -f .kube/metallb-native.yml
kubectl get pods --namespace metallb-system -o wide
kubectl wait --namespace metallb-system \
                --for=condition=ready pod \
                --selector=app=metallb \
                --timeout=300s
#6. config metallb:
kubectl apply -f .kube/metallb-config.yml

#7. create nginx-ingress:
kubectl apply -f .kube/ingress-nginx.yml
kubectl get pods --namespace ingress-nginx -o wide
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

#8. create local deployment with service creation:
kubectl apply -f .kube/auth-app-configmap.yml
kubectl apply -f .kube/auth-app-secret.yml
kubectl apply -f .kube/auth-app-deploy.yml
kubectl get configmaps -o wide
kubectl get secrets -o wide
kubectl get services -o wide


#9. create ingress:
kubectl apply -f .kube/auth-app-ingress.yml
kubectl get pods -o wide
kubectl get services -o wide

#10. [postgresql pod/service]

kubectl apply -f .kube/auth-app-pg-secret.yml
kubectl apply -f .kube/auth-app-pg-pv.yml
kubectl apply -f .kube/auth-app-pg-pvc.yml
kubectl apply -f .kube/auth-app-pg-deploy.yml
kubectl get configmap
kubectl get pv -o wide
kubectl get pvc -o wide
kubectl get pods -o wide
kubectl get secrets -o wide
kubectl get services -o wide
kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app=auth-app-pg \
  --timeout=300s
kubectl get services -o wide


#11. [redis pod/service]

kubectl apply -f .kube/auth-app-rs-pv.yml
kubectl apply -f .kube/auth-app-rs-pvc.yml
kubectl apply -f .kube/auth-app-rs-deploy.yml
kubectl get pv -o wide
kubectl get pvc -o wide
kubectl get pods -o wide
kubectl get services -o wide
kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app=auth-app-rs \
  --timeout=300s
kubectl get services -o wide

#12. [mailpit pod/service]

kubectl apply -f .kube/auth-app-mp-pv.yml
kubectl apply -f .kube/auth-app-mp-pvc.yml
kubectl apply -f .kube/auth-app-mp-deploy.yml
kubectl get pv -o wide
kubectl get pvc -o wide
kubectl get pods -o wide
kubectl get services -o wide
kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app=auth-app-mp \
  --timeout=300s
kubectl get services -o wide

