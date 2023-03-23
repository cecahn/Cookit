import mysql.connector
import json

HOSTNAME = 'eu-cdbr-west-03.cleardb.net'
DB_NAME = 'heroku_9f604fd90f29f7f'
USERNAME = 'b5a5478eb59ef3'
PASSWORD = 'a007cb73'

cookit_db = mysql.connector.connect(
    host        = HOSTNAME,
    user        = USERNAME,
    password    = PASSWORD,
    database    = DB_NAME
)

def db_get_product(gtin: str):
    '''
    Looks up a gtin number in the database and
    returns a JSON object representing the matching item
    if it exists.
    
    Keys   = column names
    Values = the value for the corresponding column
    
    If no match is found for the gtin number an
    empty object is returned
    '''
    # Är ett tomt objekt ett bra returvärde?
    # Kan returnera 'None' istället

    cursor = cookit_db.cursor()
    # TODO: Lägg till fler kolumner i queryn
    query = f"SELECT varugrupp, namn, tillverkare, hållbarhet \
              FROM products WHERE gtin = '{gtin.zfill(14)}'"
    cursor.execute(query)

    result = sql_query_to_json(cursor)

    cursor.close()

    return result

def sql_query_to_json(cursor):
    '''
    Takes a database cursor holding a query
    and converts the results of the query
    into a JSON object
    '''
    row = cursor.fetchone()
    result_dict = {}
    if row:
        for i, column in enumerate(cursor.column_names):
            result_dict[column] = row[i]
    return json.dumps(result_dict)
    
def db_store_product(product):
    '''
    Denna funktion lagrar en produkt i databasen.
    
    product är en dict med det vi ska spara om produkten.
    
    db är ett interface till MySQL databasen.
    '''

    cursor = cookit_db.cursor()

    # TODO: Ändra till mindre hårdkodning!
    sql = "INSERT INTO products (gtin, varugrupp, hållbarhet, namn, tillverkare, allergener) VALUES (%s, %s, %s, %s, %s, %s)"
    val = (product['gtin'], product['varugrupp'], product['hållbarhet'], product['namn'], product['tillverkare'], json.dumps(product['allergener']))
    
    cursor.execute(sql, val)

    cookit_db.commit()

    cursor.close()
