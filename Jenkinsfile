pipeline {
    agent any
    options {
        // For throttling other builds
        throttleJobProperty(
        categories: ['ASMRchive-2'],
        throttleEnabled: true,
        throttleOption: 'category'
        )
        // Only keep 3 builds
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    parameters {
        // Determines whether we should skip the manual review step
        booleanParam(defaultValue: false, description: "Manually test live environment", name: "MANUAL_REVIEW")
    }
    stages {
        stage("Initialize Environment") { // Defines environment variables for staging vs prod
            steps {
                script {
                    // Staging
                    echo "Job name: ${env.JOB_NAME}"
                    if (env.JOB_NAME.startsWith("ASMRchive-2/Staging")) {
                        withCredentials([string(credentialsId: "asmrchive2-staging-POSTGRES_PASSWORD", variable: "POSTGRES_PASSWORD")]) {
                            env.ENVIRONMENT = "staging"
                            env.DB_VOLUME_NAME = "asmr-db-data-staging"
                            sh "echo POSTGRES_USER=dbadmin > .env"
                            sh "echo POSTGRES_PASSWORD=${env.POSTGRES_PASSWORD} >> .env"
                            sh "echo POSTGRES_DB=ASMRchive >> .env"
                            sh "echo DB_PORT=5433 >> .env"
                            sh "echo DB_VOLUME_NAME=asmr-db-data-staging >> .env"
                            sh "echo DB_IMAGE_NAME=asmrchive-db-staging >> .env"
                            sh "echo DB_CONTAINER_NAME=asmrchive-db-staging >> .env"
                            sh "echo DJANGO_IMAGE_NAME=asmrchive-django-staging >> .env"
                            sh "echo DJANGO_CONTAINER_NAME=asmrchive-django-staging >> .env"
                            sh "echo DJANGO_PORT=8001 >> .env"
                        }
                    }
                }
            }
        }
        stage("Tidy Up") {
            steps {
                // Remove any remnant volumes.
                sh "podman volume rm \${PWD##*/}${env.DB_VOLUME_NAME} || true"
                // Remove staging containers
                sh "podman ps -a -q -f ancestor=asmrchive-python-staging | xargs -I {} podman container rm -f {} || true"
                sh "podman ps -a -q -f ancestor=asmrchive-db-staging | xargs -I {} podman container rm -f {} || true"
            }
        }
        stage("Build") {
            steps {
                sh "podman-compose build"
            }
        }
        stage("Launch") {
            steps {
                sh "podman-compose -p up -d"
            }
        }
        stage("Manual Review") { 
            steps {
                input(id: 'userInput', message: 'Is the build okay?')
            }
        }
    }
    post {
        always {
            sh "podman-compose down" // Shut down the services in case they're still running

            // Remove volumes
            sh "podman volume rm \${PWD##*/}${env.DB_VOLUME_NAME} || true"

            // Remove containers
            sh "podman ps -a -q -f ancestor=asmrchive-python-staging | xargs -I {} podman container rm -f {} || true"
            sh "podman ps -a -q -f ancestor=asmrchive-db-staging | xargs -I {} podman container rm -f {} || true"
        }
    }
}