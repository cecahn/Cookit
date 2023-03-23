from flask import Flask, request
from flask_mysqldb import MySQL

from db import db_get_product, db_store_product
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

@app.route("/get/product")
def fetch_product():
    product_code = request.args.get('id')

    # Kolla om produkten finns i databasen
    product = db_get_product(product_code, mysql)
    
    # Om inte, sök efter den i API:n
    if (product == None):
        api_product = api_get_product(product_code)
        if (api_product == None):
            # Error hantera
            return "Invalid code", 400
        else:
            db_store_product(api_product, mysql)
            return api_product
    else:
        return product

if __name__ == '__main__':
    app.run(threaded=True)