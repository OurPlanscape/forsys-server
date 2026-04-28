.PHONY: build deploy test

PROJECT=planscape-23d66
APP_NAME=forsys
ENV=dev
VERSION="$$(date '+%Y.%m.%d')-$$(git log --abbrev=10 --format=%h | head -1)"
APP=$(APP_NAME)-$(ENV)
DOCKER_REPO=planscape-$(APP_NAME)-$(ENV)
REGION=us-central1
DOCKER_TAG=$(REGION)-docker.pkg.dev/$(PROJECT)/$(DOCKER_REPO)/$(APP_NAME):$(VERSION)

build:
	docker build -t $(DOCKER_TAG) .

push:
	gcloud builds submit --tag $(DOCKER_TAG) --timeout=7200

deploy:
	gcloud run deploy $(APP) --image $(DOCKER_TAG) --platform managed --region $(REGION)

build-deploy: build push deploy

run:
	docker compose up

shell:
	./bin/run.sh bash

get-tag:
	echo $(VERSION)
