pipeline {
    agent any
    stages {
        stage("Initialize Environment") { // Defines environment variables for staging vs prod
            steps {
                script {
                    // Staging
                    if (env.JOB_NAME.startsWith("ASMRchive-2/Staging")) {
                        withCredentials([string(credentialsId: "asmrchive2-staging-POSTGRES_PASSWORD", variable: "POSTGRES_PASSWORD")]) {
                            env.ENVIRONMENT = "staging"
                            env.DB_VOLUME_NAME = "asmr-db-data-staging"

                            sh "echo POSTGRES_USER=dbadmin > .env"
                            sh "echo POSTGRES_PASSWORD=${env.POSTGRES_PASSWORD} >> .env"
                            sh "echo POSTGRES_DB=ASMRchive >> .env"
                            sh "echo DB_PORT=5433 >> .env"
                            sh "echo DB_VOLUME_NAME=${env.DB_VOLUME_NAME} >> .env"
                            sh "echo DB_IMAGE_NAME=asmrchive-db-staging >> .env"
                            sh "echo PYTHON_IMAGE_NAME=asmrchive-python-staging >> .env"
                        }
                    }
                }
            }
        }
        stage("Tidy Up") {
            steps {
                // Remove any remnant volumes.
                sh "podman volume rm ${env.DB_VOLUME_NAME} || true"
            }
        }
        stage("Build") {
            steps {
                sh "podman volume create ${env.DB_VOLUME_NAME}"
                sh "podman-compose up -d --no-deps --build db python"
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
            sh "podman volume rm ${env.DB_VOLUME_NAME} || true"

            // Remove containers
            sh "podman ps -a -q -f ancestor=asmrchive-python-staging | xargs -I {} podman container rm -f {} || true"
            sh "podman ps -a -q -f ancestor=asmrchive-db-staging | xargs -I {} podman container rm -f {} || true"
        }
    }
}