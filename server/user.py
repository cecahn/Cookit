from flask_login import UserMixin

class User(UserMixin):
    def __init__(self, id_, email):
        self.id = id_
        self.email = email

    
    @staticmethod
    def get(user_id, db):
        cursor = db.connection.cursor()
        query = f'SELECT * FROM users where id = {user_id}'

        cursor.execute(query)

        row = cursor.fetchone()
        cursor.close()
        
        if row:
            return User(row[0], row[1])
        else:
            return None

    @staticmethod
    def create(id_, email, db):
        cursor = db.connection.cursor()

        query = f"INSERT INTO users(id, email) VALUES ('{id_}', '{email}')"
        cursor.execute(query)

        db.connection.commit()
        cursor.close()

