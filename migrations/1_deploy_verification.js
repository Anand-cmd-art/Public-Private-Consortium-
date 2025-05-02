const UserVerification = artifacts.require("UserVerification");

module.exports = async function (deployer) {
  // Example proposals array; replace or leave empty as needed
  const proposals = [
    web3.utils.asciiToHex("Proposal A"),
    web3.utils.asciiToHex("Proposal B")
  ];
  await deployer.deploy(UserVerification, proposals);
};
