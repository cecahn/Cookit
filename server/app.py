# Third-party libraries
from flask import Flask, request, redirect, url_for
from flask_mysqldb import MySQL
from flask_cors import CORS
from flask_login import (
    LoginManager,
    current_user,
    login_required,
    login_user,
    logout_user,
)
import json
from oauthlib.oauth2 import WebApplicationClient
import requests

# Internal imports
from db import db_get_product, db_store_product, db_varugrupp_name, db_get_skafferi, db_add_to_pantry
from api import api_get_product
from user import User

HOSTNAME = 'eu-cdbr-west-03.cleardb.net'
DB_NAME = 'heroku_9f604fd90f29f7f'
USERNAME = 'b5a5478eb59ef3'
PASSWORD = 'a007cb73'

GOOGLE_CLIENT_ID = '1076489574363-234q2p79p5m7v0p72jhon685794e5dn9.apps.googleusercontent.com'
GOOGLE_CLIENT_SECRET = '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'
GOOGLE_DISCOVERY_URL = 'https://accounts.google.com/.well-known/openid-configuration'

app = Flask(__name__)
app.secret_key = "super secret key"

app.config['MYSQL_HOST'] = HOSTNAME
app.config['MYSQL_USER'] = USERNAME
app.config['MYSQL_PASSWORD'] = PASSWORD
app.config['MYSQL_DB'] = DB_NAME

mysql = MySQL(app)
CORS(app)
login_manager = LoginManager()
login_manager.init_app(app)

client = WebApplicationClient(GOOGLE_CLIENT_ID)

# Flask-Login helper to retrieve a user from our db
@login_manager.user_loader
def load_user(user_id):
    return User.get(user_id, mysql)

@app.route("/")
def index():
    if current_user.is_authenticated:
        return (
            "<p>Hello! You're logged in! Email: {}</p>"
            '<a class="button" href="/logout">Logout</a>'.format(
                current_user.email
            )
        )
    else:
        return '<a class="button" href="/login">Google Login</a>'


@app.route("/skafferi/spara")
@login_required
def fetch_product():
    gtin = request.args.get('id')

    # Kolla att input har korrekt format
    if not valid_gtin(gtin):
        return "Invalid product code", 400

    # Kolla om produkten finns i databasen
    product = db_get_product(gtin, mysql)
    
    # Om inte, sök efter den i API:n
    if (product == None):
        # api_product = api_get_product(gtin)
        product = api_get_product(gtin)
        
        if (product == None):
            return "Invalid code", 400
        
        db_store_product(product, mysql)
    
    # Ersätt id med namnet för varugruppen
    product['varugrupp'] = db_varugrupp_name(product['varugrupp'], mysql)

    # Lägg till varan i användarens skafferi
    user_id = current_user.id
    expiration_date = request.args.get('expiration-date')
    db_add_to_pantry(mysql, user_id, gtin, expiration_date)

    return product


def valid_gtin(gtin: str):
    '''
    Checks if 'gtin' is a valid gtin code
    '''
    return len(gtin) <= 14 and gtin.isdigit()


@app.route("/skafferi")
@login_required
def get_skafferi():
    user_id = current_user.id

    skafferi = db_get_skafferi(user_id, mysql)

    for product in skafferi:
        product['varugrupp'] = db_varugrupp_name(product['varugrupp'], mysql)
    
    return skafferi

# AUTH ROUTES ================================================================

@app.route("/login")
def login():
    # Find out what URL to hit for Google login
    google_provider_cfg = get_google_provider_cfg()
    authorization_endpoint = google_provider_cfg["authorization_endpoint"]

    # Use library to construct the request for Google login and provide
    # scopes that let you retrieve user's profile from Google
    request_uri = client.prepare_request_uri(
        authorization_endpoint,
        redirect_uri=request.base_url + "/callback",
        scope=["openid", "email", "profile"],
    )

    return redirect(request_uri)

def get_google_provider_cfg():
    return requests.get(GOOGLE_DISCOVERY_URL).json()

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("index"))

@app.route("/login/callback")
def callback():
    # Get authorization code Google sent back to you
    code = request.args.get("code")
    # Find out what URL to hit to get tokens that allow you to ask for
    # things on behalf of a user
    google_provider_cfg = get_google_provider_cfg()
    token_endpoint = google_provider_cfg["token_endpoint"]

    # Prepare and send a request to get tokens! Yay tokens!
    token_url, headers, body = client.prepare_token_request(
        token_endpoint,
        authorization_response=request.url,
        redirect_url=request.base_url,
        code=code
    )
    token_response = requests.post(
        token_url,
        headers=headers,
        data=body,
        auth=(GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET),
    )

    # Parse the tokens!
    client.parse_request_body_response(json.dumps(token_response.json()))
    
    # Now that you have tokens (yay) let's find and hit the URL
    # from Google that gives you the user's profile information,
    # including their Google profile image and email
    userinfo_endpoint = google_provider_cfg["userinfo_endpoint"]
    uri, headers, body = client.add_token(userinfo_endpoint)
    userinfo_response = requests.get(uri, headers=headers, data=body)

    unique_id = userinfo_response.json()["sub"]
    users_email = userinfo_response.json()["email"]
    print(unique_id)
    print(users_email)

    user = User(unique_id, users_email)
    
    if not User.get(unique_id, mysql):
        User.create(unique_id, users_email, mysql)
    
    login_user(user)

    return redirect(url_for("index"))


if __name__ == '__main__':
    app.run(ssl_context="adhoc", threaded=True)
