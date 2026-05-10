# Deployment Instructions

## Prerequisites

Make sure these are installed and running:
- Go 1.26+
- Docker Desktop (must be running with green icon)
- Kubernetes enabled in Docker Desktop
- kubectl configured

## Quick Deploy

### Option 1: Automated (Windows)
```cmd
test-deploy.bat
```

### Option 2: Manual Steps

```bash
# 1. Build Go app
go mod download
go build -o helloworld.exe .

# 2. Run tests
go test -v ./...

# 3. Build Docker image
docker build -t helloworld:latest .

# 4. Deploy to Kubernetes
kubectl apply -f k8s/

# 5. Wait for rollout
kubectl rollout status deployment/helloworld

# 6. Verify
kubectl get pods
kubectl get svc

# 7. Access the app
kubectl port-forward svc/helloworld-service 8080:80
# Then open: http://localhost:8080/
```

## Troubleshooting

### Docker Desktop not responding
1. Right-click Docker Desktop icon in system tray → Quit
2. Open Task Manager → End any remaining Docker processes
3. Restart Docker Desktop from Start Menu
4. Wait until icon turns green

### Kubernetes not starting
1. Open Docker Desktop → Settings → Kubernetes
2. Check "Enable Kubernetes"
3. Click Apply & Restart
4. Wait for "Kubernetes is running" message

### Port already in use
If port 30080 is already in use, edit `k8s/service.yaml` and change `nodePort` to another value (30000-32767 range).

## Recording Guide

See `RECORDING_GUIDE.md` for the video recording script.
