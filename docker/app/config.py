import os

# Read the database URL from the environment if available, otherwise use a local SQLite database.
DATABASE_URL = os.environ.get('DATABASE_URL', "sqlite:///mydb.sqlite3")

class Config:
    # Flask configuration
    SECRET_KEY = os.environ.get('SECRET_KEY', 'mysecretkey')
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # Blockchain configuration defaults
    # This is the URL of your Ethereum/Polygon node.
    WEB3_PROVIDER_URL = os.environ.get("WEB3_PROVIDER_URL", "http://127.0.0.1:8545")
    
    # The address of your deployed User Verification smart contract.
    USER_VERIFICATION_CONTRACT = os.environ.get(
        "USER_VERIFICATION_CONTRACT",
        "0x0000000000000000000000000000000000000000"  # Use a valid default or placeholder if needed.
    )
    
    # The address of your deployed User Request smart contract.
    USER_REQUEST_CONTRACT = os.environ.get(
        "USER_REQUEST_CONTRACT",
        "0x0000000000000000000000000000000000000000" # i need to put 
    )
