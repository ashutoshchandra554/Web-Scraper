// Importing dependency for puppeteer for web scraping and fs to read and write into local file
const puppeteer = require('puppeteer');
const fs = require('fs');

// Scrape URL as an environmental variable stored into url variable
const url = process.env.SCRAPE_URL;

// Checking if URL has been provided returning error if not
if (!url) {
  console.error("URL environment variable to be scraped not set up correctly.");
  process.exit(1);
}

// Launching chromium in puppeteer as local install with no sandbox
(async () => {
  try {
    const browser = await puppeteer.launch({
      headless: true,
      executablePath: '/usr/bin/chromium',
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    // Opening URL in chromium and scraping title, heading, linkcount and wordcount
    const page = await browser.newPage();
    await page.goto(url, { timeout: 60000 });

    const data = await page.evaluate(() => ({
      title: document.title,
      heading: document.querySelector('h1')?.innerText || '',
      linkCount: document.querySelectorAll('a').length,
      wordCount: document.body.innerText.split(/\s+/).length,
    }));

    // Using fs to write into a json file to be used in python later
    fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));
    await browser.close();
  } catch (error) {
    console.error("Scraping unsuccesful:", error.message);
    process.exit(1);
  }
})();
