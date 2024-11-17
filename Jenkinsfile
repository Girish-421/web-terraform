pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the Terraform infrastructure')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials')  // Assuming AWS credentials stored in Jenkins
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        DOCKER_HUB_USERNAME = credentials('docker-hub-credentials')  // Using the Docker Hub credentials ID
        DOCKER_HUB_PASSWORD = credentials('docker-hub-credentials')  // Using the same Docker Hub credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Inject AWS Credentials') {
            steps {
                script {
                    echo "AWS credentials injected."
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.ACTION == 'apply' }
            }
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.ACTION == 'destroy' }
            }
            steps {
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }

        // Docker-related stages will only run if 'apply' is chosen
        stage('Build Docker Image') {
            when {
                expression { return params.ACTION == 'apply' fileExists('index.html')}
            }
            steps {
                script {
                    // Docker login using credentials from Jenkins
                    sh "echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin"
                    sh 'docker build -t $DOCKER_HUB_USERNAME/static-website .'
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { return params.ACTION == 'apply' }
            }
            steps {
                script {
                    sh 'docker push $DOCKER_HUB_USERNAME/static-website'
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up the workspace after the pipeline execution
        }
    }
}
