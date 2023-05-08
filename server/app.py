from flask import Flask, request
from flask_mysqldb import MySQL
from flask_cors import CORS

from db import db_get_product, db_store_product, db_varugrupp_name
from api import api_get_product

HOSTNAME = 'eu-cdbr-west-03.cleardb.net'
DB_NAME = 'heroku_9f604fd90f29f7f'
USERNAME = 'b5a5478eb59ef3'
PASSWORD = 'a007cb73'

app = Flask(__name__)

app.config['MYSQL_HOST'] = HOSTNAME
app.config['MYSQL_USER'] = USERNAME
app.config['MYSQL_PASSWORD'] = PASSWORD
app.config['MYSQL_DB'] = DB_NAME

mysql = MySQL(app)
CORS(app)

@app.route("/get/product")
def fetch_product():
    product_code = request.args.get('id')

    # Kolla att input har korrekt format
    if not valid_gtin(product_code):
        return "Invalid product code", 400

    # Kolla om produkten finns i databasen
    product = db_get_product(product_code, mysql)
    
    # Om inte, sök efter den i API:n
    if (product == None):
        api_product = api_get_product(product_code)
        
        if (api_product == None):
            return "Invalid code", 400
        
        db_store_product(api_product, mysql)
        return api_product
    
    # Ersätt id med namnet för varugruppen
    product['varugrupp'] = db_varugrupp_name(product['varugrupp'], mysql)
    return product


def valid_gtin(gtin: str):
    '''
    Checks if 'gtin' is a valid gtin code
    '''
    return len(gtin) <= 14 and gtin.isdigit()


if __name__ == '__main__':
    app.run(threaded=True)