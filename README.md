# FastAPI + Docker

![Continuous Integration and Delivery](https://github.com/AdamGagorik/fastapi-tdd-docker/workflows/Continuous%20Integration%20and%20Delivery/badge.svg?branch=master)

This project is from `testdriven.io`.

- The `FastAPI` module is used to create REST endpoints
- The `Pydantic` module is used to validate incoming JSON data
- The `Toitoise` module is used to interact with `PostgreSQL` database
  
# Development and Production

- `Docker` is used to manage the development and production environment
- `Heroku` is used to deploy and host the production environment in the cloud 
- `GitHubPackages` is used to store Docker images
- `GitHubActions` is used to automate CI tasks

# Endpoints

| Endpoint         | HTTP Method     | CRUD Method     | Result               | Done |
|------------------|-----------------|-----------------|----------------------|------|
| `/ping`          |                 |                 | get test json        | yes  |
| `/summaries`     | **GET**         | **READ**        | get all summaries    | yes  |
| `/summaries/:id` | **GET**         | **READ**        | get a single summary | yes  |
| `/summaries`     | **POST**        | **CREATE**      | add a summary        | yes  |
| `/summaries/:id` | **PUT**         | **UPDATE**      | update a summary     | yes  |
| `/summaries/:id` | **DELETE**      | **DELETE**      | delete a summary     | yes  |
