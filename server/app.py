from flask import Flask
from flask import request

from api import api_get_product

app = Flask(__name__)

@app.route("/get/product")
def fetch_product():
    product_code = request.args.get('id')

    info = api_get_product(product_code)

    return "Hello, world!"
