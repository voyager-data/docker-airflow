# Airflow Dockerfile

This repository contains **Dockerfile** of [airflow](https://github.com/airbnb/airflow) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/voyagerdata/airflow/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

## Informations

* Based on python:2.7 official Image (Ubuntu Trusty) [python:2.7](https://registry.hub.docker.com/_/python/)
* Install [Docker](https://www.docker.com/)
* Install [Docker Compose](https://docs.docker.com/compose/install/)
* Following the Airflow release from [Python Package Index](https://pypi.python.org/pypi/airflow)

## Installation

        docker pull voyagerdata/airflow
        cd ~
        git clone https://github.com/voyager-data/docker-airflow.git
        

## Build

For example, if you need to install [Extra Packages](http://pythonhosted.org/airflow/installation.html#extra-package), edit the Dockerfile and than build-it.

		cd ~/docker-airflow
        docker build --rm -t voyagerdata/airflow .

# Usage

Start the stack (postgres, rabbitmq, airflow-webserver, airflow-scheduler airflow-flower & airflow-worker) :

		cd ~/docker-airflow
        docker-compose up -d

If you want to use Ad hoc query, make sure you've configured connections :
Go to Admin -> Connections and Edit "mysql_default" set this values (equivalent to values in airflow.cfg/docker-compose.yml) :
- Host : postgres
- Schema : postgres
- Login : airflow
- Password : airflow

Check [Airflow Documentation](http://pythonhosted.org/airflow/)

## UI Links

- Airflow: [localhost:8080](http://localhost:8080/)
- Flower: [localhost:5555](http://localhost:5555/)
- RabbitMQ: [localhost:15672](http://localhost:15672/)

(with boot2docker, use: open http://$(boot2docker ip):8080)


## Run the test "tutorial"

        docker exec airflow_webserver_1 airflow backfill tutorial -s 2016-01-01 -e 2016-02-01
## Web Authentication: create user
        docker exec -it airflow_webserver_1 python
`Python 2.7.10 (default, Nov 20 2015, 05:21:22) 
[GCC 4.9.2] on linux2
Type "help", "copyright", "credits" or "license" for more information.`
    
`>>>`
    
	import airflow
	from airflow import models, settings
	from airflow.contrib.auth.backends.password_auth import PasswordUser
	user = PasswordUser(models.User())
	user.username = 'admin'
	user.email = 'admin@admin.net'
	user.password = 'secret'
	session = settings.Session()
	session.add(user)
	session.commit()
	session.close()
	exit()
	
# Wanna help?

Fork, improve and PR. ;-)
