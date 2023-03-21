import requests

BASE_URL = 'https://api.dabas.com/'
PRODUCT_ENDPOINT = 'DABASService/V2/article/gtin/'
API_KEY = '10d9b701-e973-42d5-a7cf-ac541f59dcd9'
CODE_MAX_LEN = 14

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
    response = requests.get(BASE_URL + PRODUCT_ENDPOINT + code + '/JSON?apikey=' + API_KEY)
    
    # Returnera svaret i json format
    return response.json()

