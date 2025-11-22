#!/bin/bash

echo "====================================================="
echo " 🔄 FULL REDEPLOY — DOCKER BUILD + K8s APPLY"
echo "====================================================="

PROJECT_ROOT="$(pwd)"


echo "📌 Project Root: $PROJECT_ROOT"
echo ""

# ---------------------------
# 1. BUILD DOCKER IMAGES
# ---------------------------

echo "🐳 Building Docker images..."

docker build -t auth-api:latest ./auth-api
docker build -t users-api:latest ./user-api
docker build -t tasks-api:latest ./tasks-api

echo "✅ Docker images built successfully!"
echo ""

# ---------------------------
# 2. LOAD IMAGES INTO K8s (Docker Desktop)
# ---------------------------

echo "📦 Loading images into Kubernetes (Docker Desktop)..."

# Docker Desktop automatically uses local images, no need for docker load
# But we restart deployments to force pulling latest local image

# ---------------------------
# 3. APPLY K8s YAML FILES
# ---------------------------

echo "🚀 Applying Kubernetes manifests..."

kubectl apply -f ./k8s-demo/namespace.yaml
kubectl apply -f ./k8s-demo/auth-api.yaml
kubectl apply -f ./k8s-demo/users-api.yaml
kubectl apply -f ./k8s-demo/tasks-api.yaml

echo "⏳ Restarting deployments so they use the latest images..."
kubectl rollout restart deployment auth-api -n demo-app
kubectl rollout restart deployment users-api -n demo-app
kubectl rollout restart deployment tasks-api -n demo-app

echo ""
echo "⏳ Waiting for Pods to start..."
sleep 5

echo ""
echo "🐳 Kubernetes Pods:"
kubectl get pods -n demo-app

echo ""
echo "🌐 Kubernetes Services:"
kubectl get svc -n demo-app

echo ""
echo "🎉 FULL REDEPLOY COMPLETE!"
echo "====================================================="

# ---------------------------
# END OF SCRIPT
# ---------------------------

# --- IGNORE ---
