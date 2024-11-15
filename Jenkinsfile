pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-south-1'  // Your AWS region
    }
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the Terraform infrastructure')
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        stage('Inject AWS Credentials') {
            steps {
                echo 'Injecting AWS credentials...'
                withCredentials([string(credentialsId: 'aws-credentials', variable: 'AWS_CREDENTIALS')]) {
                    script {
                        def creds = AWS_CREDENTIALS.split("\n")
                        env.AWS_ACCESS_KEY_ID = creds[0].split("=")[1].trim()
                        env.AWS_SECRET_ACCESS_KEY = creds[1].split("=")[1].trim()
                    }
                }
            }
        }
        stage('Initialize Terraform') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }
        stage('Plan Terraform Changes') {
            steps {
                echo 'Planning Terraform changes...'
                sh 'terraform plan'
            }
        }
        stage('Apply or Destroy Terraform') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        echo 'Applying Terraform changes...'
                        sh 'terraform apply -auto-approve'
                    } else if (params.ACTION == 'destroy') {
                        echo 'Destroying Terraform infrastructure...'
                        sh 'terraform destroy -auto-approve'
                    } else {
                        error 'Invalid ACTION selected. Choose apply or destroy.'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution complete.'
        }
    }
}
