pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the Terraform infrastructure')
    }

    environment {
        // You can leave this empty or set other environment variables
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
                    echo "Injecting AWS credentials..."
                    withCredentials([string(credentialsId: 'aws-credentials', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'aws-credentials', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        // AWS credentials are now available as environment variables
                        echo "AWS credentials injected."
                    }
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
    }
}
