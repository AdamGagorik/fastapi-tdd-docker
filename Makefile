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
