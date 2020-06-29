pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Build'
        sh 'echo $(pwd)'
      }
    }

    stage('Test') {
      steps {
        echo 'Test'
      }
    }

    stage('Notifie') {
      steps {
        echo 'Noti'
      }
    }

  }
}