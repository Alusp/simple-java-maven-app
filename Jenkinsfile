pipeline {
    agent {
        label 'builder3'
    }

    environment {
        sonarqube_token = credentials('sonar-secret-id')
        IMAGE_NAME = "molacon/paas"
        IMAGE_TAG = "latest"
    }
    
    // tools {
    //     maven 'Maven'
    // //    jdk 'JDK11'
    // }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        // stage('Build') {
        //     steps {
        //         sh 'mvn clean package -DskipTests'
        //     }
        // }
        
        // stage('Test') {
        //     steps {
        //         sh 'mvn test'
        //     }
        // }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    // sh 'mvn sonar:sonar -Dsonar.projectKey=simple-java-maven-app -Dsonar.projectName="simple-java-maven-app"'
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
                        echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin
                        sudo docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                sh '''
                    PORT_IN_USE=$(sudo lsof -t -i:8008)
                    if [ -n "$PORT_IN_USE" ]; then
                    echo "Port 8008 in use, stopping process..."
                    sudo kill -9 $PORT_IN_USE || true
                    fi

                    # Alternatively, remove docker containers using port 8008
                    CONTAINER=$(sudo docker ps -q --filter "publish=8008")
                    if [ -n "$CONTAINER" ]; then
                    echo "Docker container using port 8008 found, stopping it..."
                    sudo docker rm -f $CONTAINER
                    fi

                    sudo docker run -d -p 8008:80 ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                   // sh 'sudo docker run -d -p 8008:80 ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }


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