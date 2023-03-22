from flask import Flask, request
from api import api_get_product, db_store_product

app = Flask(__name__)

@app.route("/get/product")
def fetch_product():
    product_code = request.args.get('id')

    product = api_get_product(product_code)
    db_store_product(product)

    return "Hello, world!"
