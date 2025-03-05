// Import the Web3 package (use uppercase for the constructor)
const Web3 = require('web3');

// Import file system and path modules
const fs = require('fs');
const path = require('path');

// Use the global web3 instance provided by Truffle if it exists, otherwise create a new one
const web3Instance = (typeof web3 !== 'undefined') ? web3 : new Web3("http://127.0.0.1:8545");

// Define the path to the compiled contract artifact (Voter.json)
const contractPath = path.resolve(__dirname, "../build", "contracts", "Voter.json");
const contractArtifact = JSON.parse(fs.readFileSync(contractPath, "utf-8"));

// Destructure the ABI and bytecode from the contract artifact
const { abi, bytecode } = contractArtifact;

// Async function to deploy the contract
async function deploy() {
  try {
    const accounts = await web3Instance.eth.getAccounts();
    console.log("Deploying from account:", accounts[0]);

    const proposals = [
      web3Instance.utils.asciiToHex("Proposal1"),
      web3Instance.utils.asciiToHex("Proposal2"),
      web3Instance.utils.asciiToHex("Proposal3")
    ];

    const contractInstance = new web3Instance.eth.Contract(abi);

    const deployedContract = await contractInstance.deploy({
      data: bytecode,
      arguments: [proposals]
    }).send({
      from: accounts[0],
      gas: 3000000
    });
    
    console.log("The contract is deployed at the address:", deployedContract.options.address);
  } catch (error) {
    console.error("Deployment failed:", error);
    throw error;
  }
}

// Async function for verifying users (example logic)
async functions verifyUsers() {
  try {
    const accounts = await web3Instance.eth.getAccounts();
    console.log("Accounts:", accounts);
    // Additional user verification logic can go here.
  } catch (error) {
    console.error("Error during user verification:", error);
    throw error;
  }
}

// Export a function for Truffle exec
module.exports = async function(callback) {
  try {
    await  verifyUsers();
    await deploy();
    console.log("User verification and contract deployment completed successfully.");
    callback();
    
  } catch (error) {
    callback(error);
  }
};
