const { ethers } = require("hardhat");

async function main() {
  const Greeter = await ethers.getContractFactory("WrapEther");
  const greeter = await Greeter.deploy();

  await greeter.deployed();

  await hre.tenderly.persistArtifacts({
    name: "DirectSwapOnPool",
    address: greeter.address,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
