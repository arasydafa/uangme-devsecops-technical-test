# Arasy HelloWorld - DevSecOps Technical Test

Go-based HelloWorld application with Docker containerization, Kubernetes deployment, and Jenkins CI/CD pipeline.

## Project Structure

```
├── main.go              # Go HTTP application
├── main_test.go         # Unit tests with security validation
├── go.mod               # Go module
├── pom.xml              # Maven configuration
├── Dockerfile           # Multi-stage Docker build
├── Jenkinsfile          # CI/CD pipeline
├── .gitignore
├── README.md
└── k8s/
    ├── deployment.yaml  # Kubernetes deployment
    └── service.yaml     # Kubernetes service
```

## Quick Start

### Build
```bash
go mod download
go build -o helloworld .
go test -v ./...
```

### Docker
```bash
docker build -t helloworld:latest .
```

### Kubernetes
```bash
kubectl apply -f k8s/
kubectl port-forward svc/helloworld-service 8080:80
curl http://localhost:8080/
```

## API Endpoints

**GET /** - Hello message
```json
{
  "message": "Hello from Arasy!",
  "timestamp": "2026-05-10T12:00:00Z",
  "hostname": "helloworld-abc123",
  "version": "1.0.0"
}
```

**GET /health** - Health check
```json
{
  "status": "healthy"
}
```
