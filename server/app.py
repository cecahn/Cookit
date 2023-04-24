# Third-party libraries
from flask import Flask, request
from flask_mysqldb import MySQL
from flask_cors import CORS
from flask_login import (
    LoginManager,
    current_user,
    login_required,
    login_user,
    logout_user,
)
import requests

# Internal imports
from db import (
    db_get_product,
    db_store_product,
    db_varugrupp_name,
    db_get_skafferi,
    db_add_to_pantry,
    db_remove_from_pantry,
    db_set_betyg,
    db_search_recipe,
    db_get_recomendations,
    db_get_recipe,
    db_update_exp_date
)
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
app.config['SESSION_COOKIE_SAMESITE'] = 'None'
app.config['SESSION_COOKIE_SECURE'] = False

mysql = MySQL(app)
CORS(app, supports_credentials=True)
login_manager = LoginManager(app)
login_manager.init_app(app)

@app.route("/get/recomendations")
@login_required
def fetch_recomendations():
    user_id = current_user.id

    # Max antal rekomendationer att få tillbaks
    if (request.args.get('max')):
        max_results = int(request.args.get('max'))
    else:
        max_results = 10

    recomendations = db_get_recomendations(user_id, max_results, mysql)

    return recomendations

@app.route("/get/recipe")
@login_required
def fetch_recipe():
    recipe_id = request.args.get('recipe-id')

    if not recipe_id.isdigit():
        return "Invalid recipe ID", 400
    
    return db_get_recipe(recipe_id, mysql)

@app.route("/search")
@login_required
def search_recipe():
    phrase = request.args.get('phrase')
    limit = request.args.get('limit')

    result = db_search_recipe(phrase, limit, mysql)

    return result, 200

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
        product = api_get_product(gtin)
        
        if (product == None):
            return "Invalid code", 400
        
        db_store_product(product, mysql)
    else:
        # Ersätt id med namnet för varugruppen om hämtad från db
        product['varugrupp'] = db_varugrupp_name(product['varugrupp'], mysql)

    # Lägg till varan i användarens skafferi
    user_id = current_user.id

    expiration_date = request.args.get('expiration-date')

    # Sanera input - kontrollera att formatet är 'YYYYMMDD'
    if expiration_date and not valid_date(expiration_date):
        return "Invalid date format", 400
    
    result = db_add_to_pantry(mysql, user_id, gtin, expiration_date)

    product['skafferi_id'] = result['skafferi_id']
    product['bästföre'] = result['bästföre']
    product['tilläggsdatum'] = result['tilläggsdatum']

    return product

def valid_date(date):
    return (len(date) == 8 and date.isdigit())

@app.route("/skafferi/ta_bort")
@login_required
def delete_from_pantry():
    user_id = current_user.id
    skafferi_id = request.args.get('skafferi_id')

    # Sanera input
    if not skafferi_id.isdigit():
        return "Invalid product id", 400

    result = db_remove_from_pantry(mysql, user_id, skafferi_id)

    if result:
        return f"Tog bort produkten med id:'{skafferi_id}' ur skafferiet", 200
    
    return "Kunde inte hitta varan", 404

def valid_gtin(gtin: str):
    '''
    Checks if 'gtin' is a valid gtin code
    '''
    return len(gtin) <= 14 and gtin.isdigit()

@app.route('/skafferi/update_exp_date')
@login_required
def update_exp_date():
    user_id = current_user.id
    skafferi_id = request.args.get('skafferi_id')
    expiration_date = request.args.get('expiration-date')

    if not expiration_date:
        return "Missing argument 'expiration-date'", 400
    
    if not valid_date(expiration_date):
        return "Invalid date format", 400

    # Sanera input
    if not skafferi_id.isdigit():
        return "Invalid product id", 400

    result = db_update_exp_date(mysql, user_id, skafferi_id, expiration_date)

    if result:
        return f"Uppdaterade utgångsdatum för produkten med id:'{skafferi_id}'", 200
    
    # Varan finns inte i skafferiet, eller användaren satte samma datum som redan var sparat
    return "Varan finns inte, eller hade samma utgångsdatum redan", 400


@app.route("/skafferi")
@login_required
def get_skafferi():
    user_id = current_user.id

    skafferi = db_get_skafferi(user_id, mysql)

    for product in skafferi:
        product['varugrupp'] = db_varugrupp_name(product['varugrupp'], mysql)
    
    return skafferi

@app.route("/betyg/set")
@login_required
def set_betyg():
    user_id = current_user.id
    recipe_id = request.args.get('recipe-id')
    betyg = request.args.get('betyg')

    result = db_set_betyg(mysql, user_id, recipe_id, betyg)

    return result


# AUTH ROUTES ================================================================

# Flask-Login helper to retrieve a user from our db
@login_manager.user_loader
def load_user(user_id):
    return User.get(user_id, mysql)


@app.route("/login")
def login():
    # hämta token
    token = request.args.get('access_token')
    if (not token):
        return 'Must provide access token', 400

    # hämta uppgifter från google
    r=requests.get("https://www.googleapis.com/oauth2/v1/userinfo?alt=json", headers={"Authorization":f'Bearer {token}'})

    if (r.status_code != 200):
        return 'Access token not valid!', 401

    profile = r.json()

    unique_id = profile['id']
    users_email = profile['email']

    user = User(unique_id, users_email)

    if not User.get(unique_id, mysql):
        User.create(unique_id, users_email, mysql)

    login_user(user)

    return "Success, du är inloggad!", 200


@app.route("/logout")
@login_required
def logout():
    logout_user()
    return 'Logged out', 200


if __name__ == '__main__':
    app.run(threaded=True)
