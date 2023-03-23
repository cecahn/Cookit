from flask import Flask
from flask import request

from db import db_get_product, db_store_product
from api import api_get_product

app = Flask(__name__)

@app.route("/get/product")
def fetch_product():
    product_code = request.args.get('id')

    # Kolla om produkten finns i databasen
    product = db_get_product(product_code)
    
    # Om inte, sök efter den i API:n
    if (product == None):
        api_product = api_get_product(product_code)
        if (api_product == None):
            # Error hantera
            return "Invalid code", 400
        else:
            db_store_product(api_product)
            return api_product
    else:
        return product
