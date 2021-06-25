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