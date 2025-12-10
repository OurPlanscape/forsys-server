# forsys-server

Planscape's Forsys Server

**[Planscape](https://www.planscape.org/)** is a new wildfire resilience planning web application built by *
*[Spatial Informatics Group (SIG)](https://sig-gis.com/)** for the [U.S. Forest Service and partners](https://code.gov/). Planscape brings the best
available state and federal data together so regional planners can prioritize landscape treatments that reduce wildfire risk, maximize ecological
benefits, and help communities adapt to climate change.

Forsys Server is a Web Service, part of Planscape architecture, that transform the user's inputs to execute ForSys, and transform the
results back to Planscape format in order to be displayed on Plascape website.

## Built With

- [Docker & Docker Compose](https://www.docker.com/) — local development & runtime
- [ForSys](https://github.com/forsys-sp/forsysr) — optimization package for land-management planning
- [Plumber](https://www.rplumber.io/) - API Generator for R
- [PostGIS](https://postgis.net/) — database (with PostgreSQL) for storing geometry, plans and results

## Deployment

Currently, this project is being deployed on GCP Cloud Run.

It is necessary to build the Docker image, push it on GCP and then, deploy it. The following command must be used to deploy.

```sh
$ make build-deploy ENV=<environment>
```

## Running locally

There's two options to run this project locally.

- With Docker
- Rscript

### With Docker

Using docker compose to provision the service.

```sh
$ docker compose up
```

### Rscript

It is possible to install all R dependecies directly to your machine and execute R to start Plumber server. The `run_forsys_server.sh` file
triggers its execution.

Be aware that it requires editing the `.env` file with the database credentials and paths that files will be output.

```sh
$ Rscript install.R  # install dependecies
$ cp .sample.env .env # require editing
$ bash run_forsys_server.sh
```
