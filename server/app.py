from flask import Flask, request, make_response, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
from functools import wraps
import jwt
import uuid

from db import db_get_product, db_store_product, db_get_tables, db_add_user, db_authenticate_user, db_get_username
from api import api_get_product

""" HOSTNAME = 'eu-cdbr-west-03.cleardb.net'
DB_NAME = 'heroku_9f604fd90f29f7f'
USERNAME = 'b5a5478eb59ef3'
PASSWORD = 'a007cb73' """
HOSTNAME = 'localhost'
DB_NAME = 'mydatabase'
USERNAME = 'root'
PASSWORD = 'password'

app = Flask(__name__)

app.config['SECRET_KEY'] = 'f62253c77166ea024480587df9b6bcbe'
app.config['MYSQL_HOST'] = HOSTNAME
app.config['MYSQL_USER'] = USERNAME
app.config['MYSQL_PASSWORD'] = PASSWORD
app.config['MYSQL_DB'] = DB_NAME

mysql = MySQL(app)
CORS(app)

def token_required(f):
    ''' 
    A function which requires the user to be
    logged in is wrapped in this function
    '''
    @wraps(f)
    def decorator(*args, **kwargs):
        """ token = None
        if 'x-access-tokens' in request.headers:
            token = request.headers['x-access-tokens']

        if not token:
            return jsonify({'message': 'a valid token is missing'})
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = Users.query.filter_by(public_id=data['public_id']).first()
        except:
            return jsonify({'message': 'token is invalid'}) """
        
        print("token_required -> decorator")

        public_id = ''
        if 'public_id' in request.json():
            public_id = request.json()['public_id']
        if public_id == '':
            return jsonify({'message': 'a valid token is missing'})

        # return f(current_user, *args, **kwargs)
        return f(*args, **kwargs)
    return decorator

@token_required
@app.route("/hello", methods=['POST'])
def hello():
    ''' Test function '''
    data = request.get_json()
    username = db_get_username(mysql, data['public_id'])
    if username:
        return jsonify({'message': f"Hello {username}!"})
    return jsonify({'message': f"Not logged in!"})

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
            # Error hantera
            return "Invalid code", 400
        else:
            db_store_product(api_product, mysql)
            return api_product
    else:
        return product

@app.route('/register', methods=['POST'])
def signup_user(): 
    data = request.get_json()
    hashed_password = generate_password_hash(data['password'], method='sha256')
    public_id=str(uuid.uuid4())

    db_add_user(mysql, public_id, name=data['name'], password=hashed_password)
      
    return jsonify({'public_id': public_id})

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    result = db_authenticate_user(mysql, data['name'], data['password'])
    if (result != None):
        return jsonify({'public_id': result})
    return jsonify({'message': 'login failed!'})

def valid_gtin(gtin: str):
    '''
    Checks if 'gtin' is a valid gtin code
    '''
    return len(gtin) <= 14 and gtin.isdigit()


if __name__ == '__main__':
    app.run(threaded=True)