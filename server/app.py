from flask import Flask
from flask import request

app = Flask(__name__)

@app.route("/get/product")
def fetch_product():
    product_code = request.args.get('id')
    print(product_code)
    return "Hello, world!"