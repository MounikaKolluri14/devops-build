pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'DockerHub-credentials'   // Jenkins Docker Hub credentials ID
        DOCKERHUB_USERNAME = 'mounika1112'
        DEV_REPO = "${DOCKERHUB_USERNAME}/dev"
        PROD_REPO = "${DOCKERHUB_USERNAME}/prod"
        DEPLOY_SERVER = 'ubuntu@54.172.29.192' // Your EC2 SSH user@host
        DEPLOY_PATH = '/home/ubuntu/devops-build'       // Path on server where repo and scripts live
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
                    if (env.BRANCH_NAME == 'dev') {
                        dockerImage = docker.build("${DEV_REPO}:${imageTag}")
                    } else if (env.BRANCH_NAME == 'master') {
                        dockerImage = docker.build("${PROD_REPO}:${imageTag}")
                    } else {
                        error("Branch ${env.BRANCH_NAME} is not configured for deployment.")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        if (env.BRANCH_NAME == 'dev') {
                            dockerImage.push('latest')
                            dockerImage.push("${env.BUILD_NUMBER}")
                        } else if (env.BRANCH_NAME == 'master') {
                            dockerImage.push('latest')
                            dockerImage.push("${env.BUILD_NUMBER}")
                        }
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    sshagent(['ssh-server']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                            cd ${DEPLOY_PATH} &&
                            ./deploy.sh
                        '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build and deployment successful for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "Build or deployment failed for branch ${env.BRANCH_NAME}"
        }
    }
}

