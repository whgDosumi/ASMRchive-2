pipeline {
    agent any
    environment {
        ENVIRONMENT = "" // Set during "Initialize Environment" stage
    }
    stages {
        stage("Initialize Environment") { // Defines environment variables for staging vs prod
            steps {
                script {
                    // Staging
                    if (env.JOB_NAME.startsWith("ASMRchive-2/Staging")) {
                        withCredentials([string(credentialsId: "asmrchive2-staging-POSTGRES_PASSWORD", variable: "POSTGRES_PASSWORD")]) {
                            env.ENVIRONMENT = "staging"
                            echo "POSTGRES_USER=dbadmin" > .env
                            echo "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}" >> .env
                            echo "POSTGRES_DB=ASMRchive" >> .env
                            echo "DB_PORT=5433" >> .env
                            echo "DB_VOLUME_NAME=asmr-db-data-staging" >> .env
                            echo "DB_IMAGE_NAME=ASMRchive-db-staging" >> .env
                            echo "PYTHON_IMAGE_NAME=ASMRchive-python-staging" >> .env
                        }
                    }
                }
            }
        }
        stage("Build") {
            steps {
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
            sh "podman volume rm asmr-db-data-staging"

            // Remove images (we want to rebuild from source every time in staging.)
            sh "podman ps -a -q -f ancestor=ASMRchive-python-staging | xargs -I {} podman container rm -f {} || true"
            sh "podman ps -a -q -f ancestor=ASMRchive-db-staging | xargs -I {} podman container rm -f {} || true"
        }
    }
}