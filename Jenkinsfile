pipeline {
    agent {
        label 'builder3'
    }

    environment {
        sonarqube_token = credentials('sonar-secret-id')
        IMAGE_NAME = "molacon/simple-java-maven-app"
        IMAGE_TAG = "latest"
    }
    
    tools {
        maven 'Maven'
    //    jdk 'JDK11'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=simple-java-maven-app -Dsonar.projectName="simple-java-maven-app"'
                }
            }
        }

        stage('sudo Build Docker Image') {
            steps {
                    sh 'sudo docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        //  Optional: Push Docker image to a registry
        stage('sudo Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-image-id',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        // stage('Deploy Docker Image') {
        //     steps {
        //             sh 'docker run ${IMAGE_NAME}:${IMAGE_TAG} -p 8888:8080'
        //     }
        // }


        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
        //         }
        //     }
        // }
        
        // The good things at the end
        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 1, unit: 'HOURS') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }

    }
}