pipeline {
    agent {
        label 'agent-demo-1'
    }

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'patch-1', description: 'Enter Git Branch')
        booleanParam(name: "DEPLOY_APP", defaultValue: true, description: 'Deploy application')
        choice(name: 'ENV', choices:['DEV','QA','UAT','PROD'], description: 'Select Your Environment')
    }

    environment {
        TOMCAT_PATH = '/opt/tomcat/webapps'
        REMOTE_HOST = 'ubuntu@52.55.84.222'
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: "${params.BRANCH_NAME}",
                    url: 'https://github.com/udevops2026/rock-paper-scissors.git',
                    credentialsId: 'git-access-token'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy') {
            when {
                expression { params.DEPLOY_APP == true }
            }
            steps {
                sh 'cp target/*.war /opt/tomcat/webapps/'
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Build Failed!'
        }
    }
}
