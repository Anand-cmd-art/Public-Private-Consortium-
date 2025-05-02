require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    // Local development network (Ganache)
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      skipDryRun: true
    },

    // Rinkeby Testnet
    rinkeby: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          process.env.INFURA_URL_RINKEBY
        ),
      network_id: 4,       // Rinkeby's network id
      confirmations: 2,    // # of confirmations to wait between deployments
      timeoutBlocks: 200,  // # of blocks before a deployment times out
      skipDryRun: true     // Skip dry run before migrations
    },

    // Goerli Testnet
    goerli: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          process.env.INFURA_URL_GOERLI
        ),
      network_id: 5,       // Goerli's network id
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // Sepolia Testnet
    sepolia: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          process.env.ALCHEMY_URL_SEPOLIA || process.env.INFURA_URL_SEPOLIA
        ),
      network_id: 11155111,  // Sepolia's network id
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },

  // Add your plugins here
  plugins: ["truffle-plugin-verify"],

  // Etherscan API keys for verifying contracts
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  },

  // Solidity compiler settings
  compilers: {
    solc: {
      version: "0.8.20"
    }
  }
};
