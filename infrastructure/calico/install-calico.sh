#!/bin/bash
set -e

echo "🌐 Installing Calico CNI..."

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml

echo "⏳ Waiting for Calico pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n calico-system --timeout=120s

