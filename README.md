Symfony Docker Bootstrap [![Build Status](https://travis-ci.org/yoshz/symfony-docker-bootstrap.svg?branch=master)](https://travis-ci.org/yoshz/symfony-docker-bootstrap)
========================

This repository contains a bootstrap installation of Symfony to get you started together with:

- **Symfony 3.2**: Uses the microframework and puts all classes and configuration inside `src/` without the need of a custom bundle
- **Docker setup**: it has a Mariadb, Nginx and PHP-FPM 7.1 container which can be started using `docker-compose`
- **Testsuite setup**: testsuite script which runs all tests and generates reports which can be used in Jenkins or other tools
- **Doctrine setup**: Doctrine is enabled by default and a temporary sqlite database is used for functional testing.
- **Xdebug**: Remote debugging is enabled on development mode

Installation
============

Setup new project directory

```bash
docker run --rm -it --user $(id -u):$(id -g)  -v $(pwd):/app -v ~/.composer:/composer \
    composer/composer create-project -s dev yoshz/symfony-docker-bootstrap project-dir
cd project-dir
```

Build Docker images

```bash
docker-compose build
```

Start containers

```bash
docker-compose up -d
```

Create database schema

```bash
docker-compose exec app bin/console doctrine:schema:create
```

Customise
---------

Update the following files with your project name and description:

* composer.json
* docker-compose{.prod}.yml


Usage
=====

PHPStorm
--------

Make sure you installed the **EditorConfig** plugin.

To **Start listening for PHP Debug Connections** (the topright phone icon) make sure you have configured a PHP Server
called "docker" and add mapping on the root of project to `/var/www`.


Logs
----

Application logs are written to the container output and can be viewed by running:

```bash
docker-compose logs
```

Testsuite
---------

The testsuite needs to be run inside the app container by running:

```bash
docker-compose exec app bin/testsuite
```

CI
--

Travis configuration is included to test automatically if your project is stable.

If you use another build tool configure the following tasks in your CI tool to build and test your project:

```bash
docker-compose build
docker-compose run --rm app bin/testsuite
```

All the reports will be written to `reports` directory which can be processed again by another tool.


Production
----------

A different docker-compose file is used for production setup.

Make sure that the Docker images are pulled or built.

Start entire stack by running

```bash
docker-compose -f docker-compose.prod.yml up
```
