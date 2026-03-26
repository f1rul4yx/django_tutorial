pipeline {
    agent none
    environment {
        IMAGEN = "f1rul4yx/django_tutorial"
        USUARIO = credentials('DOCKERHUB_CREDENTIALS')
        PRODUCCION_IP = "192.168.2.11"
    }
    stages {
        // === EJERCICIO 1: Test + Build imagen Docker ===

        // Stages que se ejecutan en el contenedor python:3
        stage("Test en contenedor") {
            agent {
                docker {
                    image 'python:3'
                    args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch: 'main', url: 'https://github.com/f1rul4yx/django_tutorial.git'
                    }
                }
                stage('Install') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'python3 manage.py test'
                    }
                }
            }
        }

        // Stages que se ejecutan en la máquina de Jenkins
        stage("Build y Push en Jenkins") {
            agent any
            stages {
                stage('Clone repo') {
                    steps {
                        git branch: 'main', url: 'https://github.com/f1rul4yx/django_tutorial.git'
                    }
                }
                stage('Build imagen') {
                    steps {
                        script {
                            newApp = docker.build("${IMAGEN}:${BUILD_NUMBER}", "-f build/Dockerfile build/")
                        }
                    }
                }
                stage('Push a Docker Hub') {
                    steps {
                        script {
                            docker.withRegistry('', 'DOCKERHUB_CREDENTIALS') {
                                newApp.push()
                                newApp.push('latest')
                            }
                        }
                    }
                }
                stage('Borrar imagen local') {
                    steps {
                        sh "docker rmi ${IMAGEN}:${BUILD_NUMBER}"
                        sh "docker rmi ${IMAGEN}:latest"
                    }
                }
            }
        }

        // === EJERCICIO 2: Despliegue en producción ===
        stage("Deploy en producción") {
            agent any
            steps {
                sshagent(['PRODUCCION_SSH']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no root@${PRODUCCION_IP} '
                            cd /opt/django_tutorial &&
                            docker compose pull &&
                            docker compose down &&
                            docker compose up -d
                        '
                    """
                }
            }
        }
    }
    post {
        always {
            mail to: 'vargasgomezderequenaclass@gmail.com',
            subject: "Pipeline: ${currentBuild.fullDisplayName} - ${currentBuild.result}",
            body: "Build ${env.BUILD_URL} ha finalizado con resultado: ${currentBuild.result}"
        }
    }
}
