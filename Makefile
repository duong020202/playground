.PHONY: *

SHELL := bash
ARTIFACT = my-app
HASH = $(shell git rev-parse --short HEAD)
BRANCH_NAME ?= local
BUILD_NUMBER ?= 9999
PACKAGE_VERSION=$(shell jq -r .version client/package.json)
BUILD_VER=${PACKAGE_VERSION}-${BRANCH_NAME}-${BUILD_NUMBER}-${HASH}
DOCKER_REGISTRY ?= localhost:5000
# Skaffold will pass in the IMAGE variable and fails if docker has not
# produced an image with that tag.
IMAGE ?= $(DOCKER_REGISTRY)/$(ARTIFACT):$(BUILD_VER)

run-full-process:
	docker-build
	docker-run
	curl http://localhost:80


####################################
# DOCKER COMMANDS

docker-build:
	docker build -t $(IMAGE) .

docker-push:
	docker push $(IMAGE)

docker-run:
	docker run -d -p 80:80 --name myapp myapp

####################################