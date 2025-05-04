# Stage 1
# Importing node.js image
FROM node:18-slim AS scraper

#Skipping chromium puppeteer install as directed
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install Chromium and other dependencies required
RUN apt-get update && apt-get install -y \
    chromium \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
 && rm -rf /var/lib/apt/lists/*

#Copy Package.json and scraper.js to workdir and intall npm
WORKDIR /app
COPY package.json ./
COPY scraper.js ./
RUN npm install


# Run scraper with scraping URL as env variable
ARG SCRAPE_URL
ENV SCRAPE_URL=$SCRAPE_URL
RUN node scraper.js

# Stage 2
# Importing python 3.10 image
FROM python:3.10-slim

#Copying scraped_data.json anf server.py as well as it's requirement and installing the requirements
WORKDIR /app
COPY --from=scraper /app/scraped_data.json ./scraped_data.json
COPY server.py ./
COPY requirements.txt ./
RUN pip install -r requirements.txt

#Running server.py exposing port 5000
EXPOSE 5000
CMD ["python", "server.py"]
