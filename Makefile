DOCKER_REGISTRY ?= localhost:31000
DOCKER_IMAGE_AUTH = $(DOCKER_REGISTRY)/token-poc-auth:$(shell git describe --tags --always --dirty)
DOCKER_IMAGE_HELLO = $(DOCKER_REGISTRY)/token-poc-hello:$(shell git describe --tags --always --dirty)

all: images

images:
	docker build -f Dockerfile.authenticate . -t $(DOCKER_IMAGE_AUTH)
	docker build -f Dockerfile.hello . -t $(DOCKER_IMAGE_HELLO)

push: images
	docker push $(DOCKER_IMAGE_AUTH)
	docker push $(DOCKER_IMAGE_HELLO)

.PHONY: images push
