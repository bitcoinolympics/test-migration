const { ethers } = require("hardhat");

const contracts = [
  {
    name: "CreateSovPool",
    address: "0xfc3c19F2Bb3119e5F14c36fC5C697243DDb74D8a",
  },
  {
    name: "SimpleSwap",
    address: "0x8622B97a2A0425d6A872B9dBA91Dd61A540AB6aF",
  },
  {
    name: "DirectSwapOnPool",
    address: "0x91F30170Ed694f294cCfaC92ace6F2Ab80746D6c",
  },
];

async function main() {
  const Greeter = await ethers.getContractFactory("DirectSwapOnPool");
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
