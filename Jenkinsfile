#!groovy

pipeline {
  agent none

  options {
    ansiColor('xterm')
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {
    stage('Build Setup') {
      parallel {
        stage('Build') {
          agent { label 'ecs-builder-node14' }
          steps {
            initBuild()

            sh 'npm ci'

            securityScan()

            sh 'jupiterone-build'

            script {
              if (env.BRANCH_NAME == 'main') {
                sh 'jupiterone-publish'
              }
            }
          }
        }
      }
    }

    stage('Deploy') {
      when { branch 'main' }
      steps {
        deployToEnvironment(
            environment: 'jupiterone-infra',
        )
      }
    }
  }
}
