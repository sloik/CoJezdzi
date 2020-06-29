pipeline {
  agent any
  stages {
    stage('Checkout') {
      agent any
      steps {
        sh 'echo "Checkout"'
      }
    }

    stage('Build') {
      steps {
        echo 'Build'
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