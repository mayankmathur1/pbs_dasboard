pipeline {
    agent { label 'docker' }

    options {
        // Do not omit this option, otherwise it will start eating all the disk space and we will be forced to delete
        // the job to avoid a Jenkins DoS
        buildDiscarder(logRotator(numToKeepStr:'10'))
        // helpful when looking at docker or node output which tends to send ansi sequences even without a tty.
        ansiColor('xterm')
        timeout(time: 3, unit: 'HOURS')
    }

    environment {
        JFROG_USER = credentials('cts_jfrog_user')
        JFROG_PASS = credentials('cts_jfrog_password')
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'make build'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'make test'
            }
        }
        stage('Scan') {
            steps {
                echo 'Scanning...'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing image...'
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'c6637acd-e4c8-44f2-be76-536e34cad915', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "make docker-push"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}