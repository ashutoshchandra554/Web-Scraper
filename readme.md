
# Introduction

This project is a fully Dockerized web scraper that:
- Scrapes Web URL using **node.js with puppeteer** with no chromium installation and no sandbox.
- Serves the scaped json data using **Flask** web server using python.
- For contenarization a **Two-Stage Dockerfile** is used.

## Prerequisites

Ensure you have [Docker](https://www.docker.com/products/docker-desktop) installed on your desktop.

## Installation

Step 1: Build the Docker Image, run the following command in the URL scraper directory (where Dockerfile is located):

```bash
docker build -t web-scraper --build-arg SCRAPE_URL=<Enter Scrape URL> .
```

Step 2: Run the Dockerfile (and the web server) using:
```bash
docker run -p 5000:5000 web-scraper
```

Then web server can be visited by:
```bash
http://localhost:5000/
```

## Working

First as we run docker build it triggers the build of our Dockerfile (stage 1).

In this stage:

- Node.js image is installed with skipping puppeteer install.
- Installing the rest of the dependencies including chromium.
- Copying Package.json into workdir which contains the dependency as well as version for node.js installation.
- After installing npm, it runs scraper.js with the scraping URL we set.

Scraper.js in this stage:

- Launching chromium in puppeteer as local install with no sandbox.
- Opening URL in chromium (using puppeteer) and scraping title, heading, linkcount and wordcount.
- Using fs to write the scraped data into a json file to be used in python later

Then we run the dockerfile with port 5000 triggering Dockerfile(Stage 2):

- Python image is installed with skipping puppeteer install.
- Scraped_data.json and server.py is copied to workdir.
- Running server.py exposing port 5000

Server.py in this stage:

- Using Flask to set up a web server.
- Opening Scraped_data.json and then jsonify it to web server.
- Serve the data on localhost (0.0.0.0) and port 5000.