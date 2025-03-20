import os

DATABASE_URL=os.env.get('DATABASE_URL',"sqlite:///mydb.sqlite3")


class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY','mysecretkey') 
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    QUEST_CONTRACT = os.environ.get("USER_REQUEST_CONTRACT", "0x...")