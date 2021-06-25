APP_URL=`heroku info -s | grep web_url | cut -d= -f2`

open:
	open ${APP_URL}ping

stop:
	 heroku ps:scale web=0

start:
	 heroku ps:scale web=1

build:
	docker-compose up -d --build

tests:
	docker-compose exec web pytest .

check:
	docker-compose exec web flake8 .
	docker-compose exec web black . --check
	docker-compose exec web isort . --check-only

apply:
	docker-compose exec web flake8 .
	docker-compose exec web black .
	docker-compose exec web isort .

schema:
	docker-compose exec web python app/db.py

github-image:
	docker build -f project/Dockerfile.prod -t docker.pkg.github.com/adamgagorik/fastapi-tdd-docker/summarizer:latest ./project

github-image-push:
	docker push docker.pkg.github.com/adamgagorik/fastapi-tdd-docker/summarizer:latest
