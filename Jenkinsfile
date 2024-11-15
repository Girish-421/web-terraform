pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'girish04'
        DOCKER_HUB_PASSWORD = 'girish@421s'
        TERRAFORM_DIR = 'D:/FSI/P/StaticWebTerraform'
        RUN_DESTROY = 'false'  // Set this to 'true' only if you want to destroy the resources
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Girish-421/static-web-terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_HUB_USERNAME/static-website .'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker push $DOCKER_HUB_USERNAME/static-website'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    return env.RUN_DESTROY == 'true'  // Only destroy if RUN_DESTROY is true
                }
            }
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }

        // Use withCredentials in a stage where it's needed
        stage('AWS Configuration') {
            steps {
                withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                    script {
                        // Here you can now access AWS credentials (e.g., $AWS_ACCESS_KEY_ID)
                        sh 'echo $AWS_ACCESS_KEY_ID'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
