# Variables
APP_PORT=13773
APP_NAME=cts-flask-service
AWS_REGION=us-east-1
DOCKER_LOGIN := $(shell aws ecr get-login --region ${AWS_REGION} --no-include-email)
DOCKER_REPO := $(shell echo ${DOCKER_LOGIN} | awk '{print $7}' | cut -d '/' -f 3)
VERSION := $(shell git rev-parse --short HEAD)

# Help / Self Documentation
.PHONY: help

help: ## Help command to see what commands are available and what they do
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST}

.DEFAULT_GOAL := help

print-vars: ## Print all configured variables that are required for startup
	printf "\033[0;34m%s\n" "PORT ${PORT}" "APP_NAME ${APP_NAME}" "JFROG_USER ${JFROG_USER}" "JFROG_PASS ${JFROG_PASS}"

# DOCKER TASKS
build: ## Build the container
	docker build --build-arg JFROG_USER=${JFROG_USER} --build-arg JFROG_PASS=${JFROG_PASS} -t ${APP_NAME}-build-image \
		--target builder .
	docker build --build-arg JFROG_USER=${JFROG_USER} --build-arg JFROG_PASS=${JFROG_PASS} -t ${APP_NAME} .

build-nc: ## Build the container without caching
	docker build --no-cache --build-arg JFROG_USER=${JFROG_USER} --build-arg JFROG_PASS=${JFROG_PASS} \
		-t ${APP_NAME}-build-image --target builder .
	docker build --no-cache --build-arg JFROG_USER=${JFROG_USER} --build-arg JFROG_PASS=${JFROG_PASS} -t ${APP_NAME} .

test: ## Test the built application
	docker run --rm --name ${APP_NAME}-build-container ${APP_NAME}-build-image pytest

run: ## Run container on port configured in variables
	docker run -d -p ${APP_PORT}:8080 --name=${APP_NAME} ${APP_NAME}
	printf "\033[0;34m%s\n" "local service can be reached at localhost:${APP_PORT}"

up: build run ## Build containers and run it on port configured in variables

destroy: ## Stop and remove running container
	docker stop ${APP_NAME}; docker rm ${APP_NAME}

docker-push: ## Push the image to ECR
	aws ecr describe-repositories --repository-names ${APP_NAME} --region ${AWS_REGION} \
		|| aws ecr create-repository --repository-name ${APP_NAME} --region ${AWS_REGION}
	${DOCKER_LOGIN}
	docker tag ${APP_NAME}:latest ${DOCKER_REPO}/${APP_NAME}:${VERSION}
	docker push ${DOCKER_REPO}/${APP_NAME}:${VERSION}
	docker tag ${APP_NAME}:latest ${DOCKER_REPO}/${APP_NAME}:latest-dev
	docker push ${DOCKER_REPO}/${APP_NAME}:latest-dev
