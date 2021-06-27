APP_URL=`heroku info -s | grep web_url | cut -d= -f2`

################################################################################
define __help_message__
[targets]
    make help                     : show this message
    make docker-build             : delete the docker images and rebuild them from scratch
    make docker-tests             : run the unit tests inside the docker container
    make docker-tools-check       : execute dev tools but do not change code
    make docker-tools-apply       : execute dev tools and change the code
    make docker-github-image      : build the docker image for github
    make docker-github-image-push : push the built docker image
    make sql-schema               : run task for SQL for new img
    make heroku-open              : heroku application browser
    make heroku-stop              : heroku application start
    make heroku-start             : heroku application kill
endef
export __help_message__

################################################################################
.PHONY : help
help:
	@echo "$$__help_message__"

################################################################################
.PHONY : docker-build
docker-build:
	docker-compose up -d --build

################################################################################
.PHONY : docker-tests
docker-tests:
	docker-compose exec web pytest .

################################################################################
.PHONY : docker-schema
docker-schema:
	docker-compose exec web python app/db.py

################################################################################
.PHONY : docker-tools-check
docker-tools-check:
	docker-compose exec web python -m pytest --cov="."
	docker-compose exec web flake8 .
	docker-compose exec web black . --check
	docker-compose exec web isort . --check-only

################################################################################
.PHONY : docker-tools-apply
docker-tools-apply:
	docker-compose exec web flake8 .
	docker-compose exec web black .
	docker-compose exec web isort .

################################################################################
.PHONY : heroku-open
heroku-open:
	open ${APP_URL}ping

################################################################################
.PHONY : heroku-stop
heroku-stop:
	 heroku ps:scale web=0

################################################################################
.PHONY : heroku-start
heroku-start:
	 heroku ps:scale web=1

################################################################################
.PHONY : docker-github-image
docker-github-image:
	docker build -f project/Dockerfile.prod -t docker.pkg.github.com/adamgagorik/fastapi-tdd-docker/summarizer:latest ./project

################################################################################
.PHONY : docker-github-image-push
docker-github-image-push:
	docker push docker.pkg.github.com/adamgagorik/fastapi-tdd-docker/summarizer:latest
