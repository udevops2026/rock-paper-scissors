pipeline {
    agent {
        label 'slave-1'
    }

    parameters {
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'patch-1',
            description: 'Enter Git Branch'
        )
        booleanParam(
            name: 'DEPLOY_APP',
            defaultValue: true,
            description: 'Deploy application'
        )
        choice(
            name: 'ENV',
            choices: ['DEV','QA','UAT','PROD'],
            description: 'Select Your Environment'
        )
    }

    environment {
        // Existing variables
        TOMCAT_PATH = '/opt/tomcat/webapps'
        REMOTE_HOST = 'ubuntu@54.87.49.57'

        // New Docker variables added
        IMAGE_NAME  = 'devopsdemo2525/rps'
        IMAGE_TAG   = "${BUILD_NUMBER}"
    }

    stages {

        // ─────────────────────────────────
        // STAGE 1 — CLONE (your existing)
        // ─────────────────────────────────
        stage('Clone Code') {
            steps {
                git branch: "${params.BRANCH_NAME}",
                    url: 'https://github.com/udevops2026/rock-paper-scissors.git',
                    credentialsId: 'git-access-token'
            }
        }

        // ─────────────────────────────────
        // STAGE 2 — MAVEN BUILD (your existing)
        // ─────────────────────────────────
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        // ─────────────────────────────────
        // STAGE 3 — DOCKER BUILD (new!)
        // ─────────────────────────────────
        stage('Docker Build') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh """
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} \
                        -t ${IMAGE_NAME}:latest \
                        .
                """
                echo "Docker image built"
            }
        }

        // ─────────────────────────────────
        // STAGE 4 — DOCKER PUSH (new!)
        // ─────────────────────────────────
        stage('Docker Push') {
            steps {
                echo "Pushing to Docker Hub..."
                withCredentials([usernamePassword(
                    credentialsId : 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo \$DOCKER_PASS | docker login \
                            -u \$DOCKER_USER \
                            --password-stdin

                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest

                        docker logout
                    """
                }
                echo "Image pushed to Docker Hub"
            }
        }

        // ─────────────────────────────────
        // STAGE 5 — DEPLOY (your existing)
        // ─────────────────────────────────
        stage('Deploy') {
            when {
                expression { params.DEPLOY_APP == true }
            }
            steps {
                sh 'cp target/*.war /opt/tomcat/webapps/'
                echo "WAR deployed to Tomcat"
            }
        }
    }

    post {
        success {
            echo """
            ================================
            Deployment Successful!
            Image : ${IMAGE_NAME}:${IMAGE_TAG}
            Hub   : https://hub.docker.com/r/${IMAGE_NAME}
            ================================
            """
        }
        failure {
            echo 'Build Failed!'
        }
        always {
            sh 'docker image prune -f || true'
            cleanWs()
        }
    }
}


