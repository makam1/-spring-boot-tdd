pipeline {
    agent any
    stages {
        stage('GitHub') {
            steps {
            // Get some code from a GitHub repository
                git(
                url: "https://github.com/makam1/-spring-boot-tdd.git",
                branch: "master",
                changelog: true,
                poll: true
                )
            }
        }

        stage('Build Artifact') {
            steps {
                sh "mvn clean package -DskipTests=true"
                archive 'target/*.jar' //so that they can be downloaded later
            }
        }
        stage('Unit Tests - JUnit and Jacoco') {
             steps {
                sh "mvn test"
             }
             post {
                 always {
                     junit 'target/surefire-reports/*.xml'
                     jacoco execPattern: 'target/jacoco.exec'
                 }
             }
        }
         stage('Docker Build and Push') {
                steps {
                    withDockerRegistry([credentialsId: "docker-credential", url: ""]) {
                        sh 'printenv'
                        sh 'docker build -t makam1/demo-spring:$BUILD_NUMBER .'
                        sh 'docker push makam1/demo-spring:$BUILD_NUMBER'
                    }
                }
         }
         stage('Remove Unused docker image') {
                steps{
                    sh 'docker rmi makam1/demo-spring:$BUILD_NUMBER'
                }
         }
         stage('Kubernetes Deployment - DEV') {
                steps { withKubeConfig([credentialsId: 'kubernetes-config']) {
                    sh "sed -i 's#replace#makam1/demo-spring:${BUILD_NUMBER}#g' k8s_deployment_service.yaml"
                       sh "kubectl apply -f k8s_deployment_service.yaml"
                    }
                }
         }
    }
}