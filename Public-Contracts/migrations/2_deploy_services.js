const Services = artifacts.require("Services");
const UserVerification = artifacts.require("UserVerification");

module.exports = async function (deployer) {
  const uv = await UserVerification.deployed();
  await deployer.deploy(Services, uv.address);
};
