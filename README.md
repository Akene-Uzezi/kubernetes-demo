# Kubernetes Demo

A Node.js Express application containerized with Docker and deployed to Kubernetes. Demonstrates basic cloud-native application architecture with health checks, readiness probes, and liveness probes.

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Developer     │────▶│   Docker        │────▶│   Kubernetes    │
│   (Local)       │     │   Container     │     │   Cluster       │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       │                       │
        ▼                       ▼                       ▼
   src/index.ts          Docker Image          Deployment (2 pods)
   Express Server        (Multi-stage)         Service (NodePort)
   Health endpoints      Node 22 Alpine        Readiness/Liveness
```

### Components

- **Express API** (`src/index.ts`) - Node.js REST API with health endpoints
- **Docker** (`Dockerfile`, `docker-compose.yaml`) - Multi-stage container build
- **Kubernetes** (`k8s/deployment.yaml`, `k8s/service.yaml`) - Production deployment
- **Deploy Script** (`deploy.sh`) - Automated build, push, and deploy

## Prerequisites

You need to install the following tools:

### 1. Node.js & npm
- **Version**: Node.js 22+ (LTS)
- **Download**: https://nodejs.org/en/download
- Verify:
  ```bash
  node --version  # v22+
  npm --version   # 10+
  ```

### 2. Docker
- **Version**: Docker Engine 24+ (with Docker Hub account)
- **Download**: https://docs.docker.com/engine/install/
- Verify:
  ```bash
  docker --version
  docker compose version
  ```

### 3. Kubernetes CLI (kubectl)
- **Version**: kubectl latest
- **Download**: https://kubernetes.io/docs/tasks/tools/
- Verify:
  ```bash
  kubectl version --client
  ```

### 4. Optional: Minikube or Kind (for local Kubernetes)
- **Minikube**: https://minikube.sigs.k8s.io/docs/start/
- **Kind**: https://kind.sigs.k8s.io/docs/user/quick-start/

## Project Structure

```
.
├── src/
│   └── index.ts              # Express application entry point
├── k8s/
│   ├── deployment.yaml       # Kubernetes Deployment (2 replicas)
│   └── service.yaml          # Kubernetes Service (NodePort)
├── Dockerfile                # Multi-stage Docker build
├── docker-compose.yaml       # Local development environment
├── deploy.sh                 # Automated deploy script
├── package.json              # Node.js dependencies and scripts
├── tsconfig.json             # TypeScript configuration
└── README.md                 # This file
```

## Quick Start

### Local Development

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start development server:
   ```bash
   npm run dev
   ```

3. Access the API:
   - http://localhost:3000 - Main endpoint
   - http://localhost:3000/readyz - Readiness probe
   - http://localhost:3000/healthz - Liveness probe

### Docker (Local)

1. Build and run with docker-compose:
   ```bash
   docker compose up --build
   ```

2. Access the API:
   - http://localhost:3000

### Kubernetes Deployment

1. Build and push Docker image:
   ```bash
   # Update USERNAME in deploy.sh to your Docker Hub username
   sh deploy.sh
   ```

   Or manually:
   ```bash
   docker build -t yourusername/kubernetes-demo-api:latest .
   docker push yourusername/kubernetes-demo-api:latest
   ```

2. Update `k8s/deployment.yaml` with your image name:
   ```yaml
   image: yourusername/kubernetes-demo-api:latest
   ```

3. Apply Kubernetes manifests:
   ```bash
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   ```

4. Verify deployment:
   ```bash
   kubectl get pods
   kubectl get services
   kubectl get deployment
   ```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Returns service info with timestamp |
| `/readyz` | GET | Readiness probe endpoint |
| `/healthz` | GET | Liveness probe endpoint |

## Configuration

### Environment Variables

- `PORT` - HTTP port (default: 3000)
- `NODE_ENV` - Node environment (development/production)
- `POD_NAME` - Kubernetes pod name (auto-injected)

### Docker Build

The `Dockerfile` uses a multi-stage build:
1. **Builder stage** - Installs deps, compiles TypeScript
2. **Production stage** - Runs compiled JS with minimal Alpine base

### Kubernetes Resources

**Deployment**: 2 replicas with resource limits
- CPU: 100m request / 500m limit
- Memory: 128Mi request / 512Mi limit

**Probes**:
- Readiness: `/readyz` (5s initial delay, 10s period)
- Liveness: `/healthz` (10s initial delay, 20s period)

## Scripts

| Script | Description |
|--------|-------------|
| `npm run dev` | Start dev server with nodemon |
| `npm run build` | Compile TypeScript to JavaScript |
| `npm start` | Run compiled application |
| `npm run deploy` | Execute deploy script |

## Development

### TypeScript

The project uses TypeScript. After making changes, rebuild:

```bash
npm run build
```

### Nodemon

During development, `nodemon` watches for file changes and auto-restarts the server.

## Troubleshooting

### Docker Build Fails

```bash
# Clean build cache
docker builder prune -a
docker compose up --build --force-recreate
```

### Kubernetes Pods Not Starting

```bash
# Check pod logs
kubectl logs -f deployment/kubernetes-demo-api

# Describe pod for events
kubectl describe pod -l app=kubernetes-demo-api

# Check service endpoints
kubectl get endpoints kubernetes-demo-api-service
```

### Port Conflicts

Change the port in:
- `src/index.ts` (PORT variable)
- `docker-compose.yaml` (ports mapping)
- `k8s/deployment.yaml` (containerPort)
- `k8s/service.yaml` (port and targetPort)

## License

ISC