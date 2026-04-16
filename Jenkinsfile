node('agent-demo-1') {

    properties([
        parameters([
            string(name: 'BRANCH_NAME', defaultValue: 'patch-1', description: 'Enter Git Branch'),
            booleanParam(name: 'DEPLOY_APP', defaultValue: true, description: 'Deploy application'),
            choice(name: 'ENV', choices: ['DEV', 'QA', 'UAT', 'PROD'], description: 'Select Your Environment')
        ])
    ])

    def TOMCAT_PATH = '/opt/tomcat/webapps'
    def REMOTE_HOST = 'ubuntu@52.55.84.222'

    try {

        stage('Clone Code') {
            git branch: params.BRANCH_NAME,
                url: 'https://github.com/udevops2026/rock-paper-scissors.git',
                credentialsId: 'git-access-token'
        }

        stage('Build with Maven') {
            sh 'mvn clean package'
        }

        if (params.DEPLOY_APP) {
            stage('Deploy to Remote Tomcat') {
                sh "cp target/*.war ${TOMCAT_PATH}/"
            }
        }

        stage('Success Message') {
            echo "Deployment Successful in ${params.ENV}"
        }

    } catch (Exception e) {

        stage('Failure') {
            echo "Build Failed!"
            throw e
        }
    }
}
