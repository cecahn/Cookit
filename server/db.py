import json

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

# TODO: hämta skafferiet från användaren i databasen istället
def db_get_recomendations(skafferi: list[str], db, max_results):
    '''
    Returnerar en lista av recept sorterat utifrån hur bra rekomendationerna är.
    De bästa rekomendationerna kommer först.
    Ett recept är bättre desto minder varugrupper som saknas för receptet.
    Listan har som mest längden max_results.
    '''
    cursor = db.connection.cursor()

    # Hitta alla varugrupper som skafferiet innehåller
    find_varugrupper = 'SELECT DISTINCT varugrupp FROM products WHERE gtin = ' + ' OR gtin = '.join(skafferi)

    cursor.execute(find_varugrupper)
    varugrupper = sql_to_dict(cursor)
    varugruppID = [str(varugrupp['varugrupp']) for varugrupp in varugrupper]

    # Hitta alla recept som innehåller varugrupperna
    find_recipes = 'SELECT DISTINCT recipeID FROM recipestovarugrupp WHERE varugruppID = ' + ' OR varugruppID = '.join(varugruppID)
    cursor.execute(find_recipes)
    recipeIDS = [x['recipeID'] for x in sql_to_dict(cursor)]

    result = []

    for recipeID in recipeIDS:
        # Hämta alla varugrupper som receptet kräver
        recipe_varugrupper = f'SELECT varugruppID FROM recipestovarugrupp WHERE recipeID = {recipeID}'
        cursor.execute(recipe_varugrupper)
        recipe_varugrupper_ids = [str(x['varugruppID']) for x in sql_to_dict(cursor)]
        
        # Vilka varugrupper finns inte i skafferiet som receptet kräver?
        missing_ids = set(recipe_varugrupper_ids) - set(varugruppID)
        
        # Hämta all information om receptetet från databasen
        recipe = db_get_recipe(recipeID, db)

        # Lägg till ett fält för alla saknade varugrupper
        recipe['saknas'] = [db_varugrupp_name(missing, db) for missing in missing_ids]

        result.append(recipe)

    cursor.close()

    # Sortera så att de med minst saknade varugrupper hamnar först
    sorted_list = sorted(result, key=lambda d: len(d['saknas']))[:max_results]

    return sorted_list

def sql_to_dict(cursor):
    '''
    Converts a response with possibly multiple rows to a dict.
    '''
    rows = cursor.fetchall()
    result = []

    for row in rows:
        for i, column in enumerate(cursor.description):
            columnName = column[0]
            stuff = {}
            stuff[columnName] = row[i]
            result.append(stuff)
    
    return result

def db_get_recipe(recipeID, db):
    '''
    Hämta all information om ett recept från databasen.
    '''
    cursor = db.connection.cursor()

    query = f'SELECT * FROM recipes WHERE id = {recipeID}'

    cursor.execute(query)
    result = sql_query_to_json(cursor)

    cursor.close()

    return result