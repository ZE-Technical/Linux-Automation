#!/bin/bash

# Check if Helm is installed
if ! command -v helm > /dev/null; then
  echo "Helm is not installed. Please install Helm and try again."
  exit 1
fi

# Add the AWX repository to Helm
helm repo add awx https://awx-project.github.io/awx-helm/

# Update the Helm repository
helm repo update

# Create a namespace for AWX
kubectl create namespace awx

# Deploy AWX using Helm
helm install awx awx/awx \
  --namespace awx \
  --set awx_task_hostname=awx-task \
  --set awx_web_hostname=awx-web

# Wait for the AWX pods to be ready
kubectl wait --for=condition=ready pods -n awx --all

# Get the AWX URL
AWX_URL=$(kubectl get svc awx-web -n awx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "AWX has been deployed to $AWX_URL"