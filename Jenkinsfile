pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/TharushikaS/book-store-mern-project_.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-frontend:latest .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 3000:3000 my-frontend:latest'
            }
        }
    }
}
