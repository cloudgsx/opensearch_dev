# OpenSearch Docker Setup with SSL

This repository provides a setup script and Docker Compose configuration for deploying OpenSearch and OpenSearch Dashboards with SSL enabled.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Generated Files](#generated-files)
- [Environment Variables](#environment-variables)
- [License](#license)

## Overview

This project automates the setup of an OpenSearch cluster with SSL/TLS encryption on a DEV environment. It includes a script to generate the necessary SSL certificates, configure the OpenSearch and OpenSearch Dashboards services, and start the services using Docker Compose.

## Features

- **Automatic SSL Certificate Generation**: Generates self-signed SSL certificates for secure communication.
- **OpenSearch and OpenSearch Dashboards**: Set up with secure HTTP/HTTPS endpoints.
- **Docker Compose**: Easily start and stop the services with Docker Compose.
- **Environment Configuration**: Customize the OpenSearch password and other settings through environment variables.

## Prerequisites

Before using this setup, ensure you have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [OpenSSL](https://www.openssl.org/)

## Setup Instructions

1. **Clone the Repository**
2. **By default it uses the interface ens33. You will need to adapt it accordingly**
3. **Run the script**
4. **Check the docker-compose.yml file to get your admin password**
5. **Browse to the dashboard on your ip:5601**
