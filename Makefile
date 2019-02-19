DOCKER_REGISTRY ?= localhost:31000
DOCKER_IMAGE_AUTH = $(DOCKER_REGISTRY)/token-poc-auth:$(shell git describe --tags --always --dirty)
DOCKER_IMAGE_HELLO = $(DOCKER_REGISTRY)/token-poc-hello:$(shell git describe --tags --always --dirty)

AMBASSADOR_PRO_IMAGE=quay.io/datawire/amb-sidecar-token-plugin:cd48612

all: images

images:
	docker build -f Dockerfile.authenticate . -t $(DOCKER_IMAGE_AUTH)
	docker build -f Dockerfile.hello . -t $(DOCKER_IMAGE_HELLO)

push: images
	docker push $(DOCKER_IMAGE_AUTH)
	docker push $(DOCKER_IMAGE_HELLO)

manifests: $(wildcard templates/*.yaml)
	for FILE in $^ ; do \
		AUTHENTICATE_IMAGE=$(DOCKER_IMAGE_AUTH) \
		HELLO_IMAGE=$(DOCKER_IMAGE_HELLO) \
		AMBASSADOR_PRO_IMAGE=$(AMBASSADOR_PRO_IMAGE) \
		envsubst < $${FILE} > $$(basename $${FILE}) ; \
	done


.PHONY: images push manifests
