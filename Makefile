.PHONY: *

SHELL := bash
ARTIFACT ?= playground
HASH = $(shell git rev-parse --short HEAD)
BRANCH_NAME ?= local
BUILD_NUMBER ?= 9999
PACKAGE_VERSION=$(shell jq -r .version my-app/package.json)
BUILD_VER=${PACKAGE_VERSION}-${BRANCH_NAME}-${BUILD_NUMBER}-${HASH}
REGISTRY ?= registry.hub.docker.com
IMAGE ?= $(REGISTRY)/$(ARTIFACT):$(BUILD_VER)

run-full-process: docker-build docker-run docker-test

####################################
# DOCKER COMMANDS

docker-build:
	docker build -t $(IMAGE) .

docker-test:
	curl http://localhost:80

docker-push:
	docker push $(IMAGE)

docker-run:
	docker run -d -p 80:80 --name myapp $(IMAGE)

format-code:
	cd my-app && yarn prettier

check-code-format:
	cd my-app && yarn prettier-check

install-dependencies:
	cd my-app && yarn install

# "yarn install" is not really necessary here if "install-dependencies" is scheduled to run in advance, which it is in this case
yarn-build:
	cd my-app && yarn install && CI=false yarn build

test:
	cd my-app && yarn tests

test-all:
	cd my-app && yarn test-all

####################################