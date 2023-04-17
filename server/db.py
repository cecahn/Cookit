import json
import datetime

def db_get_product(gtin: str, cookit_db):
    '''
    Looks up a gtin number in the database and
    returns a JSON object representing the matching item
    if it exists.
    
    Keys   = column names
    Values = the value for the corresponding column
    
    If no match is found for the gtin number 'None' is returned
    '''

    cursor = cookit_db.connection.cursor()

    # Get product information
    query = f"SELECT varugrupp, gtin, namn, tillverkare, hållbarhet, allergener \
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
        for i, column in enumerate(cursor.description):
            # TODO: Fixa hårdkodning
            column_name = column[0]
            if (column_name == 'allergener'):
                result_dict[column_name] = json.loads(row[i])
            else:
                result_dict[column_name] = row[i]

        return result_dict
    return None

def db_store_product(product, cookit_db):
    '''
    Denna funktion lagrar en produkt i databasen.
    
    product är en dict med det vi ska spara om produkten.
    
    db är ett interface till MySQL databasen.
    '''

    # Hämta id för varugruppen som produkten tillhör
    varugrupp_id = db_varugrupp_id(product['varugrupp'], cookit_db)

    cursor = cookit_db.connection.cursor()

    # TODO: Ändra till mindre hårdkodning!
    sql = "INSERT INTO products (gtin, varugrupp, hållbarhet, namn, tillverkare, allergener) VALUES (%s, %s, %s, %s, %s, %s)"
    val = (product['gtin'], varugrupp_id['id'], product['hållbarhet'], product['namn'], product['tillverkare'], json.dumps(product['allergener']))
    
    cursor.execute(sql, val)

    cookit_db.connection.commit()

    cursor.close()

def db_varugrupp_id(varugrupp_name: str, db) -> int:
    '''
    Create a new varugrupp if it does not exist.
    Returns an object with the id for the newly created or previously existing varugrupp.
    '''
    cursor = db.connection.cursor()
    
    # Hämta id för varugruppen
    get_id = f"SELECT id FROM varugrupper WHERE namn = '{varugrupp_name.lower()}'"
    
    cursor.execute(get_id)

    result = sql_query_to_json(cursor)
    
    # Om result är None finns inte varugruppen
    if (result == None):
        # Skapa varugruppen
        insert = f"INSERT INTO varugrupper (namn) VALUES ('{varugrupp_name}')"
        cursor.execute(insert)
        db.connection.commit()
        
        # Svara med id för varugruppen.
        result = {'id': cursor.lastrowid}
        
    cursor.close()
    return result

def db_varugrupp_name(varugrupp_id: int, db) -> str:
    '''
    Lookup varugrupps namnet från id
    '''
    cursor = db.connection.cursor()

    get_varugrupp = f"SELECT namn FROM varugrupper WHERE id = {varugrupp_id}"
    cursor.execute(get_varugrupp)
    
    varugrupp = sql_query_to_json(cursor)

    cursor.close()
    
    return varugrupp['namn']

def db_add_to_pantry(db, user_id, gtin, expiration_date):
    '''
    Lägg till en vara i användarens skafferi
    '''
    product_id = get_product_id(db, gtin)

    if not expiration_date:
        # Inget bäst-före-datum angett
        product = db_get_product(gtin, db)
        shelf_life = product['hållbarhet']
        if shelf_life:
            # Bäst-före = dagens datum + hållbarhet
            current_date = datetime.date.today()
            expiration_date = current_date + datetime.timedelta(days=shelf_life)
        else:
            expiration_date = "NULL"

    cursor = db.connection.cursor()
    
    query = f"INSERT INTO userstoproducts (user_id, product_id, bästföredatum) \
              VALUES ('{user_id}', '{product_id}', {expiration_date})"
    
    cursor.execute(query)

    db.connection.commit()

    cursor.close()

def db_remove_from_pantry(db, user_id, product_pantry_id):
    cursor = db.connection.cursor()
    
    query = f"DELETE FROM userstoproducts WHERE user_id='{user_id}' AND id={product_pantry_id}"

    result = cursor.execute(query)

    db.connection.commit()

    cursor.close()

    return result # '0' if nothing was removed

def get_product_id(db, gtin):
    '''
    Hitta en varas id i `products`-tabellen givet gtin-nummer
    '''
    cursor = db.connection.cursor()

    query = f"SELECT id FROM products WHERE gtin='{gtin}'"

    cursor.execute(query)

    id = sql_query_to_json(cursor)

    cursor.close()

    return id['id']

def db_get_skafferi(user_id, db):
    '''
    Hämta en användares skafferi!
    '''
    cursor = db.connection.cursor()

    query = f'SELECT * FROM userstoproducts WHERE user_id = {user_id}'
    cursor.execute(query)

    row = sql_query_to_json(cursor)
    
    products = []

    while(row):
        bfd = str(row['bästföredatum'])
        product_id = str(row['product_id'])
        skafferi_id = str(row['id'])
       
        product = get_product_by_id(product_id, db)
        
        product['bästföredatum'] = bfd
        product['skafferi_id'] = skafferi_id
        products.append(product)

        row = sql_query_to_json(cursor)

    cursor.close()

    return products

def get_product_by_id(product_id, db):
    '''
    Hämta en produkt från databasen utifrån dess id. (inte gtin)
    '''
    cursor = db.connection.cursor()
    query = f'SELECT * FROM products WHERE id = {product_id}'

    cursor.execute(query)

    result = sql_query_to_json(cursor)

    cursor.close()

    return result

def db_set_betyg(db, user_id, recipe_id, betyg):
    '''
    Lägger till ett användarbetyg till ett recept i
    tabellen "betyg", eller uppdaterar betyget om användaren
    redan har betygsatt receptet. 
    Returnerar uppdaterade snittbetyget för recepetet.
    '''
    cursor = db.connection.cursor()

    query = f"INSERT INTO betyg (user_id, recipe_id, betyg) \
              VALUES ('{user_id}', '{recipe_id}', '{betyg}') \
              ON DUPLICATE KEY UPDATE betyg = VALUES(betyg)"
    
    cursor.execute(query)

    db.connection.commit()
    
    avg = avg_recipe_score(recipe_id, db)

    query2 = f'UPDATE recipes SET betyg={avg} WHERE id={recipe_id}'
    cursor.execute(query2)

    db.connection.commit()

    cursor.close()

    return {'avg_score': avg}

def avg_recipe_score(recipe_id, db):
    '''
    Returnerar ett recepts genomsnittliga betyg
    '''
    cursor = db.connection.cursor()

    query = f"SELECT AVG(betyg) as average FROM betyg WHERE recipe_id = '{recipe_id}'"

    cursor.execute(query)
    
    result = sql_query_to_json(cursor)

    cursor.close()

    return result['average']
