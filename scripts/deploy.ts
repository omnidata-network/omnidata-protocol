import { ethers } from "hardhat";

async function main() {
  const OmnidataGateWay = await ethers.getContractFactory("OmnidataGateWay");
  const gateway = await OmnidataGateWay.deploy();
  await gateway.deployed();
  console.log("OmnidataGateWay deployed to:", gateway.address);

  const OracleRequest = await ethers.getContractFactory("OracleRequest");
  const oracleRequest = await OracleRequest.deploy(gateway.address);
  await oracleRequest.deployed();
  console.log("OracleRequest deployed to:", oracleRequest.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
