# Prisma Apollo Seed

A GraphQL seed project using [Prisma](https://www.prisma.io/) with [Apollo Server](https://www.apollographql.com/docs/apollo-server/) that's ready-to-go for development.

Projects can easily be deployed in a production environment (including [Let's Encrypt](https://letsencrypt.org/) for HTTPS) when you're ready to go live.

## Local Installation & Development

First, you need to install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) or [Docker for Windows](https://docs.docker.com/docker-for-windows/).

Next, you'll need the Prisma CLI if you don't already have it installed:

```bash
$ brew tap prisma/prisma
$ brew install prisma
```

Or use npm:

```bash
$ npm install -g prisma
```

Then clone this repo and install its dependencies:

```bash
$ git clone https://github.com/mandiwise/prisma-apollo-seed.git
$ cd prisma-apollo-seed && npm install
```

Create a `.env` file and add the following variables (replacing the password/secret values with the applicable strings):

```
NODE_ENV=development
POSTGRES_PASSWORD=XXXXXXXXXXXXXXXX
PRISMA_ENDPOINT=http://prisma:4466/prisma/dev
PRISMA_MANAGEMENT_API_SECRET=XXXXXXXXXXXXXXXX
PRISMA_SERVICE_SECRET=XXXXXXXXXXXXXXXX
```

To begin development on your Prisma/Apollo project, run the following commands in the project directory:

```bash
$ docker-compose up -d
$ docker exec app prisma deploy
```

The API will be accessible on [localhost:4000/graphql](http://localhost:4000/graphql).

Nodemon will automatically reload the `app` container on changes when working in the `development` environment. Be sure to re-deploy Prisma if you make changes to the Prisma schema in `prisma/datamodel.prisma`.

## Prisma Authentication

The Prisma endpoint is available at http://localhost:4466/prisma/dev (or https://mydomain/prisma/prod in production), but requires authentication to make any queries or mutations.

To generate token for testing with the main Prisma service, run the following command inside the project directory:

```bash
$ docker exec app prisma token
```

You can send the resulting token along in an HTTP header (e.g. in the GraphQL Playground interface):

```
{
  "Authorization": "Bearer XXXXXXXXX..."
}
```

Please note that you are only required to send a token if you are testing or otherwise interacting with the Prisma service directly (available at http://localhost:4466/prisma/dev or https://mydomain/prisma/prod).

The public-facing GraphQL API (available at http://localhost:4000/graphql or https://mydomain.com/graphql) will automatically send the service secret along with every request it makes to the Prisma service.

## Management Console

If you need to access the Prisma management console, run the following command inside the project directory:

```bash
$ prisma admin
```

Note that the management console cannot be accessed directly through the URL because the CLI must generate an access token for you.

## Deployment

_Deployment on a production server requires a bit of set-up..._

### Assumptions

To deploy your API, you will need to ensure you have the following:

- Basic Linux server up and running (I have tested this on [Ubuntu 18.04 with Digital Ocean](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04)...a \$5 droplet will likely be fine, but you may need more memory depending on how you build out your app)
- [Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04#step-1-%E2%80%94-installing-docker) on your server installed
- [Docker Compose](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04#step-1-%E2%80%94-installing-docker-compose) installed on your server

### Installation & Set-up

Then clone this repo and install its dependencies:

```bash
$ git clone https://github.com/mandiwise/prisma-apollo-seed.git
$ cd prisma-apollo-seed && npm install
```

Create a `.env` file and add the following variables (replacing the password/secret values with the applicable strings):

```
DOMAIN=https://mydomain.com
NODE_ENV=production
POSTGRES_PASSWORD=XXXXXXXXXXXXXXXX
PRISMA_ENDPOINT=http://prisma:4466/prisma/prod
PRISMA_MANAGEMENT_API_SECRET=XXXXXXXXXXXXXXXX
PRISMA_SERVICE_SECRET=XXXXXXXXXXXXXXXX
```

Note that this `.env` includes a `DOMAIN` variable—this is necessary for configuring nginx!

### Configure TLS (required for remote set-up only)

This repo comes with a bash script to automatically request certificates from Let's Encrypt. Run the following commands from the root of the repo, and pass in appropriate arguments:

```bash
$ chmod +x scripts/init-letsencrypt.sh
$ sudo ./scripts/init-letsencrypt.sh mydomain.com bob@email.com
```

This script will take a few moments to run because it will have to create your `nginx` container (and it's `app` container dependency) in order for the certificate validation to work in the `certbot` container.

### Start-up

You're now ready to `docker-compose up`! To start the project in production mode, run:

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
$ docker exec app prisma deploy
```
