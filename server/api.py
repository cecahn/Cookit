import requests

BASE_URL = 'https://api.dabas.com/'
PRODUCT_ENDPOINT = 'DABASService/V2/article/gtin/'
DATA_FORMAT = '/JSON'
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
    response = requests.get(BASE_URL + PRODUCT_ENDPOINT + code + DATA_FORMAT + '?apikey=' + API_KEY)
    
    if (response.status_code != 200):
        return None

    # Omvandla till json
    respone_json = response.json()

    data = {}

    data['gtin'] = respone_json['GTIN']
    data['varugrupp'] = respone_json['Varugrupp']['VarugruppBenamning']
    data['hållbarhet'] = respone_json['TotalHallbarhetAntalDagar']
    data['namn'] = respone_json['Artikelbenamning']
    data['tillverkare'] = respone_json['Varumarke']['Tillverkare']['Namn']
    data['allergener'] = []
    
    for allergen in respone_json['Allergener']:
        data['allergener'].append(allergen['Allergen'])

    print(data)

    # Returnera svaret som en dict
    return data
