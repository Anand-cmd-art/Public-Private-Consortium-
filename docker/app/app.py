from flask import Flask
my_app = Flask(__name__)
@my_app.route('/')
def index():
    return "Hello, World!"
