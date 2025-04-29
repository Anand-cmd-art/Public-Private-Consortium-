const UserRequest = artifacts.require("UserRequest");
const UserVerification = artifacts.require("UserVerification");

module.exports = async function (deployer) {
  const uv = await UserVerification.deployed();
  await deployer.deploy(UserRequest, uv.address);
};
