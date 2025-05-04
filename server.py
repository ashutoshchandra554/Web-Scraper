#Importing Flask for webhook, jsonify to show data as json and json to handle json data provided by scraper
from flask import Flask, jsonify
import json

#creating a flask web as variable web
web = Flask(__name__)

#Web route as the index page
@web.route('/')
# Reads json data from scraped_data.json and then jsonify it to web
def serve_data():
    with open('scraped_data.json') as f:
        data = json.load(f)
    return jsonify(data)

# Run web on port 5000 on localhost (0.0.0.0)
if __name__ == '__main__':
    web.run(host='0.0.0.0', port=5000)
