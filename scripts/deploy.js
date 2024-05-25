// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  console.log("Deploying...");
  const HogwartsNFT = await hre.ethers.getContractFactory("HogwartsNFT");
  const hogwartsNFT = await HogwartsNFT.deploy();
  let currentBlock = await hre.ethers.provider.getBlockNumber();

  
  while(currentBlock + 5 > (await ethers.provider.getBlockNumber())) {
    const hogwartsAddress = await hogwartsNFT.getAddress();
    console.log("HogwartsNFT deployed to:", hogwartsAddress);
  }


  console.log("Deploying the Random House Contract...");
  const RandomHouse = await hre.ethers.getContractFactory("RandomHouse");
  const randomHouse = await RandomHouse.deploy(hogwartsAddress, VRFCoordinatorV2Address, subId, keyHash, callbackGasLimit);
  while(currentBlock + 5 > (await ethers.provider.getBlockNumber())) {
    const randomHouseAddress = await randomHouse.getAddress();
    console.log("Random House deployed to:", randomHouseAddress);
  }

  await hogwartsNFT.transferOwnership(randomAddress);
  console.log("Ownership transferred");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
