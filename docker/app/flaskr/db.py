from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()  # creating the sqlaclhemy object

class User(db.Model):  #class to inherit the db.Model features

    __tablename__ = 'user' #name of the table

    id = db.Column(db.Integer, db.Boolean, primary_key=True) #id column
    username = db.Column(db.String(50), unique=True, nullable=False) 
    password_hash = db.Column(db.String(120), unique=True, nullable=False)
    email = db.Column(db.String(50), unique = True, nullable = False)
    created = db.Column(db.DateTime, default=datetime.now)
    is_active = db.Column(db.Boolean, default=True)
    last_login = db.Column(db.DateTime)

    def __init__(self, username, email, password, created, is_active, last_login ):   #constructor to initialize the valuues usedd in the columns.
        self.username = username
        self.email = email
        self.password_hash = generate_password_hash(password)
        self.created = created
        self.is_active = is_active
        self.last_login = last_login
    def set_password(self, password):
        self.password_hash = generate_password_hash(password) # this function is used to set the password hash
    
    def check_password(self, password):
        return check_password_hash(self.password_hash, password) 
    
    def __repr__(self):
        return '<User %r>' % self.username
    
    def serialize(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'created': self.created
        }
    
    def save(self):
        db.session.add(self)
        db.session.commit()

