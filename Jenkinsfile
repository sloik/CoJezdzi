pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Build'
        sh '''echo $(pwd)
cd CoJezdzi


xcrun xcodebuild -workspace CoJezdzi.xcworkspace \\

    -scheme CoJezdzi \\
    -sdk iphoneos \\
    CODE_SIGN_IDENTITY="" \\ 
    CODE_SIGNING_REQUIRED=NO'''
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