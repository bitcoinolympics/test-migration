const tdly = require("@tenderly/hardhat-tenderly");

tdly.setup();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      // // If you want to do some forking, uncomment this
      // forking: {
      //   url: MAINNET_RPC_URL
      // }
      chainId: 31337,
    },
    localhost: {
      chainId: 31337,
    },
    rsk_testnet: {
      chainId: 31,
      url: "https://public-node.testnet.rsk.co",
    },
    rsk_local: {
      chainId: 33,
      url: "http://localhost:4444",
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.18",
      },
      {
        version: "0.4.18",
      },
    ],
  },
};
