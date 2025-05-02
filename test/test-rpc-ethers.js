// test/test-rpc-ethers.js
require("dotenv").config();
const { JsonRpcProvider } = require("ethers");

async function main() {
  const url = process.env.INFURA_URL_SEPOLIA;
  const provider = new JsonRpcProvider(url);

  try {
    const blockNumber = await provider.getBlockNumber();
    console.log("✅ Latest Sepolia block #:", blockNumber);
  } catch (err) {
    console.error("❌ RPC error:", err.message);
  }
}

main();
