from os import getenv
from dotenv import load_dotenv
import requests
import json
import mysql.connector
import re

from api import api_fritext, api_get_product

load_dotenv()

# Environment variables
ICA_USERNAME = getenv('ICA_USERNAME')
ICA_PASSWORD = getenv('ICA_PASSWORD')

# Constants
ICA_BASE_URL = 'https://handla.api.ica.se/api'
HOSTNAME = 'eu-cdbr-west-03.cleardb.net'
DB_NAME = 'heroku_9f604fd90f29f7f'
USERNAME = 'b5a5478eb59ef3'
PASSWORD = 'a007cb73'

def get_authentication_ticket() -> str:
    response = requests.get(ICA_BASE_URL + '/login', auth=(ICA_USERNAME, ICA_PASSWORD))
    if (response.status_code != 200):
        return None

    ticket = response.headers['AuthenticationTicket']
    return ticket


class IcaAPI:
    def __init__(self) -> None:
        self.ticket = get_authentication_ticket()
 
    def search_recipes(self, phrase: str, max_results: int):
        url = ICA_BASE_URL + f'/recipes/searchwithfilters'

        params = {
            'phrase': phrase, 
            'recordsPerPage': max_results,
            'pageNumber': 0, # Första sidan
            'sorting': 2 # Sortera efter relevans
        }

        headers = {'AuthenticationTicket': self.ticket}

        response = requests.get(url, params=params, headers=headers)

        if response.status_code != 200:
            # Update ticket
            self.ticket = self.get_authentication_ticket()
            return None
        
        recipes = response.json()

        return recipes

    def get_recipe(self, recipe_id: int):
        url = ICA_BASE_URL + f'/recipes/recipe/{recipe_id}'
        headers = {'AuthenticationTicket': self.ticket}
        
        response = requests.get(url, headers=headers)
        
        if response.status_code != 200:
            # Update ticket
            self.ticket = self.get_authentication_ticket()
            return None
        
        return response.json()

def varugrupp_exists(varugrupp: str, db):
    cursor = db.cursor()

    query = f"SELECT * FROM varugrupper WHERE namn = '{varugrupp}'"
    cursor.execute(query)
    res = cursor.fetchone()
    cursor.close()

    if res:
        return res[0]

    return None

def save_varugrupp(fritext, db):
    # måste ha huvudvarugruppen och en riktifg varugrupp från dabas
    res = api_fritext(fritext)
    if not res:
        return None

    dabas_info = api_get_product(res['GTIN'])
    huvudvarugrupp = dabas_info['huvudvarugrupp']
    varugrupp = dabas_info['varugrupp']

    vg_id = varugrupp_exists(varugrupp, db)
    
    if vg_id:
        return vg_id

    # spara först huvudvarugrupp
    if (not huvudvarugrupp_exists(huvudvarugrupp, db)):
        save_huvudvarugrupp(huvudvarugrupp, db)

    cursor = db.cursor()

    query = f"INSERT INTO varugrupper (namn, huvudvarugrupp) VALUES ('{varugrupp}', '{huvudvarugrupp}')"
    cursor.execute(query)
    db.commit()

    cursor.close()

    return cursor.lastrowid

def save_huvudvarugrupp(huvudvarugrupp, db):
    cursor = db.cursor()
    query = f"INSERT INTO huvudvarugrupper (namn) VALUES ('{huvudvarugrupp}')"
    
    cursor.execute(query)
    db.commit()

    cursor.close()

def huvudvarugrupp_exists(huvudvarugrupp, db):
    # spara först huvudvarugrupp
    cursor = db.cursor()
    
    query = f"SELECT * FROM huvudvarugrupper WHERE namn = '{huvudvarugrupp}'"
    cursor.execute(query)
    res = cursor.fetchone()
    
    cursor.close()

    return res != None

def connect_recipe_to_varugrupp(recipe_id, varugrupp_id, db):
    cursor = db.cursor()

    query = f"INSERT INTO recipestovarugrupp (recipeID, varugruppID) \
        VALUES ({recipe_id}, {varugrupp_id})"
    cursor.execute(query)

    db.commit()

    cursor.close()


def save_recipe(recipe, db):
    cursor = db.cursor()

    # Först skapa receptet
    recipe_id = recipe['Id']
    titel = recipe['Title']

    for (i, x) in enumerate(recipe['CookingSteps']):
        recipe['CookingSteps'][i] = re.sub('<[^<]+?>', '', x)

    instruktion = json.dumps(recipe['CookingSteps'])

    betyg = 0
    bild = recipe['ImageUrl']

    query = f"INSERT INTO recipes (id, titel, instruktion, betyg, bild) VALUES \
        ({recipe_id}, '{titel}', '{instruktion}', {betyg}, '{bild}')"
    
    cursor.execute(query)
    db.commit()

    # Koppla till varugrupper
    groups = recipe['IngredientGroups']

    for group in groups:
        group_ingredients = group['Ingredients']
        for ingredient in group_ingredients:
            varugrupp = ingredient['Ingredient']

            vg_id = varugrupp_exists(varugrupp, db)

            if (not vg_id):
                saved_varugrupp_id = save_varugrupp(varugrupp, db)
                if saved_varugrupp_id:
                    # Koppla recept till 
                    connect_recipe_to_varugrupp(recipe_id, saved_varugrupp_id, db)




    cursor.close()


def recipe_exists(recipe, db):
    cursor = db.cursor()

    query = f"SELECT * FROM recipes WHERE id = {recipe['Id']}"
    cursor.execute(query)
    res = cursor.fetchone()
    
    cursor.close()

    return res != None

if __name__ == '__main__':
    ica = IcaAPI()

    db = mysql.connector.connect(
        host=HOSTNAME,
        user=USERNAME,
        password=PASSWORD,
        database=DB_NAME
    )
    phrase = input("Fras att söka efter: ")
    search_results = ica.search_recipes(phrase, 10)

    for result in search_results['Recipes']:
        recipe = ica.get_recipe(result['Id'])

        if (not recipe_exists(recipe, db)):
            save_recipe(recipe, db)
    
    db.close()

