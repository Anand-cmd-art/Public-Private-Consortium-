import os
import json
from web3 import Web3
from .config import WEB3_PROVIDER_URL, USER_VERIFICATION_CONTRACT, USER_REQUEST_CONTRACT

# Example: load ABI from JSON files (you must create these files or adapt)
def load_abi(filename):
    with open(filename, 'r') as f:
        return json.load(f)

class BlockchainManager:
    def __init__(self, app=None):
        self.w3 = None
        self.verification_contract = None
        self.request_contract = None
        if app:
            self.init_app(app)
    
    def init_app(self, app):
        provider_url = WEB3_PROVIDER_URL
        self.w3 = Web3(Web3.HTTPProvider(provider_url))

        # Load ABIs from files (you must provide them)
        verification_abi = load_abi('abi/UserVerificationABI.json')
        request_abi = load_abi('abi/UserRequestABI.json')

        self.verification_contract = self.w3.eth.contract(
            address=USER_VERIFICATION_CONTRACT,
            abi=verification_abi
        )

        self.request_contract = self.w3.eth.contract(
            address=USER_REQUEST_CONTRACT,
            abi=request_abi
        )
