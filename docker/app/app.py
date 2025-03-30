from flask import Flask, render_template
from flask_migrate import Migrate
from config import Config
from db import db, init_db
from blockchain import BlockchainManager
from auth import auth_bp
from user_verification import verification_bp
from user_request import request_bp

migrate = Migrate()  # Instantiate the Migrate object

def create_app():
    app = Flask(__name__, static_folder='static', template_folder='templates')
    app.config.from_object(Config)

    # Initialize database
    init_db(app)  # This sets up db.init_app(app) and db.create_all()

    # Initialize Flask-Migrate
    migrate.init_app(app, db)

    # Initialize Blockchain
    bc = BlockchainManager(app)

    # Register Blueprints
    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(verification_bp, url_prefix='/verify')
    app.register_blueprint(request_bp, url_prefix='/request')

    @app.route('/')
    def dashboard():
        return render_template('dashboard.html')

    return app
