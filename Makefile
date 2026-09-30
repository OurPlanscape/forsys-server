.PHONY: build deploy test

PROJECT=planscape-23d66
APP_NAME=forsys
ENV=dev
VERSION="$$(git log -1 --format="%at" | xargs -I{} date -d @{} +%Y.%m.%d)-$$(git log --abbrev=10 --format=%h | head -1)"
APP=$(APP_NAME)-$(ENV)
DOCKER_REPO=planscape-$(APP_NAME)
DOCKER_IMAGE=us-central1-docker.pkg.dev/$(PROJECT)/$(DOCKER_REPO)/$(APP_NAME)
DOCKER_TAG=$(DOCKER_IMAGE):$(VERSION)
REGION=us-central1

build:
	@BUILDS=$$(gcloud builds list --filter="images:$(DOCKER_TAG)" --format=json); \
	if [ "$$BUILDS" = "[]" ]; then \
		CACHE_TAG=$$(gcloud artifacts docker images list "$(DOCKER_IMAGE)" --include-tags --filter="tags:*" --sort-by="~UPDATE_TIME" --limit=1 --format="value(tags[0])" 2>/dev/null || true); \
		CACHE_FROM=""; \
		if [ -n "$$CACHE_TAG" ]; then \
			CACHE_FROM="$(DOCKER_IMAGE):$$CACHE_TAG"; \
			echo "Using Docker cache from $$CACHE_FROM ."; \
			docker pull "$$CACHE_FROM" || true; \
		else \
			echo "No existing Docker image found for cache."; \
		fi; \
		echo "Building image with tag $(DOCKER_TAG).";\
		if [ -n "$$CACHE_FROM" ]; then \
			docker build --cache-from "$$CACHE_FROM" -t $(DOCKER_TAG) .; \
		else \
			docker build -t $(DOCKER_TAG) .; \
		fi; \
	else \
		echo "Docker image already pushed to artifact repo (tag: $(DOCKER_TAG))";\
	fi;

build-force:
	docker build -t $(DOCKER_TAG) .

push:
	@BUILDS=$$(gcloud builds list --filter="images:$(DOCKER_TAG)" --format=json); \
	if [ "$$BUILDS" = "[]" ]; then \
		CACHE_TAG=$$(gcloud artifacts docker images list "$(DOCKER_IMAGE)" --include-tags --filter="tags:*" --sort-by="~UPDATE_TIME" --limit=1 --format="value(tags[0])" 2>/dev/null || true); \
		CACHE_FROM=""; \
		if [ -n "$$CACHE_TAG" ]; then \
			CACHE_FROM="$(DOCKER_IMAGE):$$CACHE_TAG"; \
			echo "Using Docker cache from $$CACHE_FROM ."; \
		else \
			echo "No existing Docker image found for cache."; \
		fi; \
		echo "Pushing image $(DOCKER_TAG) ."; \
		gcloud builds submit --config cloudbuild.dockerfile.yaml --substitutions _IMAGE=$(DOCKER_TAG),_CACHE_FROM=$$CACHE_FROM .;\
	else \
		echo "Image $(DOCKER_TAG) already submitted"; \
	fi;

deploy:
	gcloud run jobs update $(APP) --image $(DOCKER_TAG) --region $(REGION)

build-deploy: push deploy

run:
	docker compose up

shell:
	./bin/run.sh bash

get-tag:
	echo $(VERSION)
