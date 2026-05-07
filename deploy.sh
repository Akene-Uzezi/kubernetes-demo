set -e

NAME="kubernetes-demo-api"
USERNAME="empakene"
IMAGE="$USERNAME/$NAME:latest"

echo "Building Docker image..."
docker build -t $IMAGE .

echo "Pushing Docker image to Docker Hub..."
docker push $IMAGE

echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Restarting deployment to pull latest image..."
kubectl rollout restart deployment/$NAME

echo "waiting for rollout to complete..."
kubectl rollout status deployment/$NAME

echo "Getting pods ..."
kubectl get pods

echo "Getting services ..."
kubectl get services

echo "fetching the main service ..."
kubectl get service $NAME