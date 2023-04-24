import requests
from dotenv import load_dotenv
from os import getenv

load_dotenv()

BASE_URL = 'https://api.dabas.com/'
PRODUCT_ENDPOINT = 'DABASService/V2/article/gtin/'
DATA_FORMAT = '/JSON'
CODE_MAX_LEN = 14
ICA_BASE_URL = 'https://handla.api.ica.se/api'
API_KEY = '10d9b701-e973-42d5-a7cf-ac541f59dcd9'

# Environment variables
ICA_USERNAME = getenv('ICA_USERNAME')
ICA_PASSWORD = getenv('ICA_PASSWORD')

def api_get_product(code: str):
    '''
    Denna funktion returnerar data om en produkt från Dabas i JSON format.
    Om koden inte är gilitg returneras None.
    '''
    # TODO: Felhanteringen kanske ska vara lite snyggare än att bara returnera None
    if (code == None or len(code) > CODE_MAX_LEN): return None
    
    # Code måste ha korrekt padding med nollor i början.
    code = code.zfill(CODE_MAX_LEN)

    # Skicka request till Dabas
    response = requests.get(BASE_URL + PRODUCT_ENDPOINT + code + DATA_FORMAT + '?apikey=' + API_KEY)
    
    if (response.status_code != 200):
        return None

    # Omvandla till json
    respone_json = response.json()

    data = {}

    data['gtin'] = respone_json['GTIN']
    data['varugrupp'] = respone_json['Varugrupp']['VarugruppBenamning']
    data['huvudvarugrupp'] = respone_json['Varugrupp']['HuvudgruppBenamning']
    data['hållbarhet'] = respone_json['TotalHallbarhetAntalDagar']
    data['namn'] = respone_json['Artikelbenamning']
    data['tillverkare'] = respone_json['Varumarke']['Tillverkare']['Namn']
    data['allergener'] = []
    
    for allergen in respone_json['Allergener']:
        data['allergener'].append(allergen['Allergen'])

    print(data)

    # Returnera svaret som en dict
    return data

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
