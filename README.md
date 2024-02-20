# comentarios-api
[![Build Status](https://github.com/guilhermefpv/comentarios-api/actions/workflows/lint.yml/badge.svg?branch=master)](https://github.com/guilhermefpv/comentarios-api/actions/workflows/lint.yml)
# comentarios-api

Uma aplicação de Comentários em versão API (backend) usando ferramentas open source

## Quickstart

This app can be run completely using `Docker` and `docker-compose`. **Using Docker is recommended, as it guarantees the application is run using compatible versions of Python and Node**.

There are three main services:

To run the development version of the app

```bash
$ docker-compose up flask-dev
```

To run the production version of the app

```bash
$ docker-compose up flask-prod
or
$ make build
$ make run
```

The list of `environment:` variables in the `docker-compose.yml` file takes precedence over any variables specified in `.env`.


Go to `http://localhost:8000`. You will see a current comentarios-api screen.

### Running locally

Run the following commands to bootstrap your environment if you are unable to run the application using Docker

```bash
$ git clone https://github.com/guilhermefpv/comentarios-api.git 
$ cd comentarios-api
$ pip install -r requirements/dev.txt
```

Go to `http://localhost:8000/`. You will see a current comentarios-api screen.


## Deployment

When using Docker, reasonable production defaults are set in `docker-compose.yml`

```text
FLASK_ENV=production
FLASK_DEBUG=0
```

Therefore, starting the app in "production" mode is as simple as

```bash
$ docker-compose up flask-prod
or 
$ make run
```