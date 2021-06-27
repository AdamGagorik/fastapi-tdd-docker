# APP_URL=`heroku info -s | grep web_url | cut -d= -f2`
APP_URL=https://evening-bastion-46853.herokuapp.com

################################################################################
CLEAN=find .                                 \
	-not \( -path ./.git           -prune \) \
	-not \( -path ./venv           -prune \) \
	-not \( -path ./.idea          -prune \) \
	\(                                       \
		    -type f -name \*.pyc             \
		-or -type d -name __pycache__        \
		-or -type d -name .ipynb_checkpoints \
	\)                                       \
	-print

################################################################################
define __help_message__
[targets]
    make help                     : show this message
    make docker-build             : delete the docker images and rebuild them from scratch
    make docker-schema            : run task for SQL for new image after running build
    make docker-tests             : run the unit tests inside the docker container
    make docker-tools-check       : execute dev tools but do not change code
    make docker-tools-apply       : execute dev tools and change the code
    make docker-github-image      : build the docker image for github
    make docker-github-image-push : push the built docker image
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
	$(MAKE) docker-schema

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
	-docker-compose exec web python -m pytest --cov="."
	-docker-compose exec web black . --check
	-docker-compose exec web flake8 .

################################################################################
.PHONY : docker-tools-apply
docker-tools-apply:
	-docker-compose exec web black .
	-docker-compose exec web flake8 .

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

################################################################################
.PHONY : heroku-test-httpie
heroku-test-httpie:
	@echo "Read summaries"
	http GET ${APP_URL}/summaries/
	@echo
	@echo "Read summary 1"
	http GET ${APP_URL}/summaries/1/
	@echo
	@echo "Create a summary"
	http --json POST ${APP_URL}/summaries/ url=https://testdriven.io
	@echo
	@echo "Update a summary"
	http --json PUT ${APP_URL}/summaries/2/ url=https://testdriven.io summary=super
	@echo
	@echo "Delete a summary"
	http DELETE ${APP_URL}/summaries/2/

################################################################################
.PHONY : docker-build-prod
docker-build-prod:
	docker build -f project/Dockerfile.prod -t web ./project
	docker run --name fastapi-tdd -e PORT=8765 -e DATABASE_URL=sqlite://sqlite.db -p 5003:8765 web:latest
	open http://localhost:5003/ping/

################################################################################
.PHONY : docker-clean
docker-clean:
	docker system prune -f
	docker volume prune -f

################################################################################
.PHONY : clean
clean:
	-@$(CLEAN)

################################################################################
.PHONY : force
force:
	-@$(CLEAN) | xargs -I xxx rm -rvf xxx
