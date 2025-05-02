// test/test-rpc.js
require("dotenv").config();
const Web3 = require("web3");

async function main() {
  try {
    // Pass the URL string directly
    const web3 = new Web3(process.env.INFURA_URL_SEPOLIA);

    const blockNumber = await web3.eth.getBlockNumber();
    console.log("✅ Latest Sepolia block #:", blockNumber);
  } catch (err) {
    console.error("❌ RPC error:", err.message);
  }
}

main();
