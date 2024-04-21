# VERSION defines the version for the docker containers.
# To build a specific set of containers with a version,
# you can use the VERSION as an arg of the docker build command (e.g make docker VERSION=0.0.2)

# REGISTRY defines the registry where we store our images.
# To push to a specific registry,
# you can use the REGISTRY as an arg of the docker build command (e.g make docker REGISTRY=my_registry.com/username)
# You may also change the default value if you are using a different registry as a defaultt
REGISTRY ?= henrotaym

# PROJECT defines suffix for images built & stored to docker hub.
PROJECT ?= laravel-installer

split-dot = $(word $2,$(subst ., ,$1))

# Commands
guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "$* is missing"; \
    	exit 1; \
	fi

build-image: guard-VERSION guard-PLATFORM
	docker buildx build \
		--file Dockerfile \
		--tag ${REGISTRY}/${PROJECT}:${VERSION}-${PLATFORM} \
		--platform linux/${PLATFORM} \
		--load \
		.
	
push-image: guard-VERSION guard-PLATFORM
	docker push ${REGISTRY}/${PROJECT}:${VERSION}-${PLATFORM}

build-push: build-image push-image

combine-image: guard-VERSION
	docker buildx imagetools create \
		-t ${REGISTRY}/${PROJECT}:${VERSION} \
		${REGISTRY}/${PROJECT}:${VERSION}-arm64 \
		${REGISTRY}/${PROJECT}:${VERSION}-amd64

each-platform: guard-SCRIPT
	PLATFORM=amd64 make ${SCRIPT} && \
	PLATFORM=arm64 make ${SCRIPT}

build-push-combine: guard-VERSION
	SCRIPT=build-push make each-platform && \
	make combine-image

each-version: guard-VERSION guard-SCRIPT
	PLATFORM=arm64 VERSION=$(call split-dot,${VERSION},1).$(call split-dot,${VERSION},2).$(call split-dot,${VERSION},3) make ${SCRIPT} && \
	PLATFORM=arm64 VERSION=$(call split-dot,${VERSION},1).$(call split-dot,${VERSION},2) make ${SCRIPT} && \
	PLATFORM=arm64 VERSION=$(call split-dot,${VERSION},1) make ${SCRIPT}

deploy: guard-VERSION
	SCRIPT=build-push-combine make each-version
