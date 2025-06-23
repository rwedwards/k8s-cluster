#!/bin/bash

set -e

echo "🔧 Creating metallb-system namespace..."
kubectl create namespace metallb-system 2>/dev/null || echo "Namespace already exists"

echo "📦 Installing MetalLB via Helm..."
helm repo add metallb https://metallb.github.io/metallb
helm repo update
helm upgrade --install metallb metallb/metallb \
  --namespace metallb-system \
  --wait

echo "✅ Waiting for MetalLB pods to be ready..."
kubectl wait --namespace metallb-system \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

kubectl wait --namespace metallb-system \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=speaker \
  --timeout=120s

echo "📄 Creating Layer2AddressPool and L2Advertisement..."
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: main-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.12.50-192.168.12.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-adv
  namespace: metallb-system
spec:
  ipAddressPools:
  - main-pool
EOF

echo "🔍 Deploying test nginx service to verify MetalLB assignment..."
kubectl create deployment test-nginx --image=nginx
kubectl expose deployment test-nginx --port=80 --type=LoadBalancer

echo "⏳ Waiting for MetalLB to assign IP..."
sleep 10
kubectl get svc test-nginx

echo "✅ If an EXTERNAL-IP from 192.168.12.x is assigned, MetalLB is working correctly."
echo "🧹 You can clean up test resources with:"
echo "    kubectl delete svc test-nginx"
echo "    kubectl delete deployment test-nginx"

