pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'book-store-frontend'
        DOCKER_TAG = "${BUILD_NUMBER}"
        FRONTEND_DIR = 'frontend'
        GITHUB_REPO_URL = 'https://github.com/TharushikaS/book-store-mern-project_.git'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    try {
                        git branch: 'main', 
                            url: "${GITHUB_REPO_URL}"
                    } catch (Exception e) {
                        echo "Error cloning repository: ${e.getMessage()}"
                        error "Failed to clone repository"
                    }
                }
            }
        }
        
        stage('Verify Dockerfile') {
            steps {
                script {
                    // Check if Dockerfile exists in frontend directory
                    if (!fileExists("${FRONTEND_DIR}/Dockerfile")) {
                        error "Dockerfile not found in ${FRONTEND_DIR} directory"
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        // Change to frontend directory and build
                        dir(FRONTEND_DIR) {
                            // Stop and remove existing container if it exists
                            sh """
                                docker stop ${DOCKER_IMAGE} || true
                                docker rm ${DOCKER_IMAGE} || true
                                docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true
                            """
                            
                            // Build new Docker image
                            docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                        }
                    } catch (Exception e) {
                        echo "Docker build failed: ${e.getMessage()}"
                        error "Failed to build Docker image"
                    }
                }
            }
        }
        
        stage('Run Container') {
            steps {
                script {
                    try {
                        sh """
                            docker run -d \
                            --name ${DOCKER_IMAGE} \
                            -p 3000:3000 \
                            ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    } catch (Exception e) {
                        echo "Failed to run Docker container: ${e.getMessage()}"
                        error "Container run failed"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Frontend pipeline completed successfully!'
        }
        failure {
            echo 'Frontend pipeline failed. Check the logs for details.'
        }
        always {
            // Clean up workspace
            cleanWs()
        }
    }
}
