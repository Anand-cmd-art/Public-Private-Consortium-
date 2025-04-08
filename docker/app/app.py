from flask import Flask, render_template
from flask_migrate import Migrate
from config import Config
from db import db, init_db
from blockchain import BlockchainManager
from auth import auth_bp
from user_verification import verification_bp
from user_request import request_bp

migrate = Migrate()  # Instantiate Flask-Migrate

def create_app():
    # Point to the correct static and templates folders
    app = Flask(
        __name__,
        static_folder='flaskr/static',
        template_folder='flaskr/templates'
    )

    # Load config from config.py
    app.config.from_object(Config)

    # Initialize database (creates tables if using db.create_all())
    init_db(app)

   
    migrate.init_app(app, db)

    
    bc = BlockchainManager(app)

    # Register Blueprints for modular routes
    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(verification_bp, url_prefix='/verify')
    app.register_blueprint(request_bp, url_prefix='/request')

    @app.route('/')
    def dashboard():
        # Render the user/dashboard.html template
        return render_template('user/dashboard.html')

    return app

if __name__ == '__main__':
    # Create the Flask app and run for local dev
    flask_app = create_app()
    flask_app.run(host='0.0.0.0', port=5000, debug=True)
