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
                 sh "mvn test -Dgroups=unitaires"
                 }
                 post {
                    always {
                        junit 'target/surefire-reports/*.xml'
                        jacoco execPattern: 'target/jacoco.exec'
                 }
             }
        }

        stage('Service - IntegrationTest') {
            steps{
                sh "mvn test -Dgroups=integrations"
            }
        }

        stage('Web - IntegrationTest') {
            steps{
                sh "mvn test -Dgroups=web"
            }
        }

         stage('Docker Build and Push') {
            when{ expression {false}}
                steps {
                    withDockerRegistry([credentialsId: "docker-credential", url: ""]) {
                        sh 'printenv'
                        sh 'docker build -t makam1/demo-spring:$BUILD_NUMBER .'
                        sh 'docker push makam1/demo-spring:$BUILD_NUMBER'
                    }
                }
         }
         stage('Remove Unused docker image') {
            when{ expression {false}}
                steps{
                    sh 'docker rmi makam1/demo-spring:$BUILD_NUMBER'
                }
         }
         stage('Kubernetes Deployment - DEV') {
            when { expression { false } }
            steps { withKubeConfig([credentialsId: 'kubernetes-config']) {
                sh "sed -i 's#replace#makam1/demo-spring:4#g' k8s_deployment_service.yaml"
                   sh "kubectl apply -f k8s_deployment_service.yaml --validate=false"
                }
            }
         }
    }
}