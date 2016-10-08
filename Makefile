VIRTUALENV_NAME=hdatalogger
NAMESPACE=sthysel
NAME=biopython
VERSION ?= latest

.PHONY: mkvirtualenv install

all: build push shell run start stop rm release

mkvirtualenv:
	mkvirtualenv ${VIRTUALENV_NAME};

install:
	workon ${VIRTUALENV_NAME}; \
	pip install -r src/pip_requirements_dev.txt; \

build:
	docker build -t ${NAMESPACE}/$(NAME):$(VERSION) .

push:
	docker push ${NAMESPACE}/$(NAME):$(VERSION)

shell:
	docker run --rm --name ${NAME}-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NAMESPACE)/$(NAME):$(VERSION) /bin/bash

run:
	docker run --rm --name ${NAME}-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NAMESPACE)/$(NAME):$(VERSION)

start:
	docker run -d --name ${NAME}-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NAMESPACE)/$(NAME):$(VERSION)

stop:
	docker stop ${NAME}-$(INSTANCE)

rm:
	docker rm ${NAME}-$(INSTANCE)

release: build
	make push -e VERSION=${VERSION}

default: build
