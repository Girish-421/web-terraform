pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the Terraform infrastructure')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials') 
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials') 
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
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

        stage('Docker Build and Push') {
            when {
                expression { return params.ACTION == 'apply' && fileExists('Dockerfile') }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    script {
                        sh '''
                            echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin
                        '''
                        sh 'docker build -t $DOCKER_HUB_USERNAME/static-website .'
                        sh 'docker push $DOCKER_HUB_USERNAME/static-website'
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
