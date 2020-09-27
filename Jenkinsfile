currentBuild.displayName = "Final_Demo${env.BUILD_ID}"
def getDockerTag(){
         def tag=sh script: 'git rev-parse HEAD', returnStdout: true
         }

pipeline{
  environment {
  Docker_tag=getDockerTag()
  }
agent any
options{
  buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '1', numToKeepStr: '2')
  }
stages {
  stage("BUILD"){
    agent {
      docker {
      label 'redhat'
      image 'maven'
      args '-v $HOME/.m2:/root/.m2'
      }
      }

    steps{
      sh 'mvn -DskipTests clean install'
      echo "build completed"
      }
    }
  stage("Deployment"){
    agent {label 'redhat'}
    steps {
      script{
        sh "docker build . -t i633184/my-app:${env.BUILD_ID}"
        withCredentials([usernamePassword(credentialsId: 'dockcred', passwordVariable: 'passwd', usernameVariable: 'username')]) {
        sh 'docker login -u $username -p $passwd'
        sh 'docker push i633184/my-app:$BUILD_ID'
         }
       }
     }
    }
  stage("ansible-playbookk"){
    options{ timeout(time:30, unit:'MINUTES')}
    input{ 
          message "Should I Deploy to Testing"
               ok "Deploy"
          parameters{
                     choice(name:'ENV', choices:["PROD","DEV","QA"], description: "This is multiple choice based")
                    }
         }
    agent { label 'redhat'}
    steps{
    script{
      sh '''final_tag="${BUILD_ID}"
      echo ${final_tag}test
      sed -i "s/docker_tag/$final_tag/g" deployment.yml
         '''
      ansiblePlaybook installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yml'
          }
         }
         }
     }
}
