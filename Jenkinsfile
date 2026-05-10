pipeline {
    agent any

    environment {
        APP_NAME = 'helloworld'
        IMAGE_NAME = 'helloworld'
        IMAGE_TAG = "${env.BUILD_NUMBER ?: 'latest'}"
        K8S_NAMESPACE = 'default'
    }

    triggers {
        // Poll SCM every 2 minutes for automatic builds
        pollSCM('H/2 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build (Maven)') {
            steps {
                echo 'Running Maven build...'
                // Maven integration for dependency validation and build lifecycle
                sh 'mvn -f pom.xml validate'
            }
        }

        stage('Build (Go)') {
            steps {
                echo 'Building Go application...'
                sh '''
                    go mod download
                    CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o helloworld .
                    echo "Build completed successfully"
                '''
            }
        }

        stage('Security Scan') {
            steps {
                echo 'Running security checks...'
                // Static analysis and security scanning
                sh '''
                    echo "Running go vet..."
                    go vet ./...
                    echo "Security scan completed"
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh '''
                    go test -v -cover ./...
                    echo "Tests completed"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh '''
                    // Update image tag in deployment manifest
                    sed -i "s|image: helloworld:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|" k8s/deployment.yaml

                    // Apply Kubernetes manifests
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml

                    // Wait for rollout
                    kubectl rollout status deployment/helloworld --timeout=60s
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sh '''
                    echo "Checking pod status..."
                    kubectl get pods -l app=helloworld

                    echo "Checking service..."
                    kubectl get svc helloworld-service

                    echo "Deployment verification completed"
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
            echo "Application deployed to Kubernetes"
        }
        failure {
            echo "Pipeline failed!"
            // Could add notification here (email, Slack, etc.)
        }
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
    }
}
