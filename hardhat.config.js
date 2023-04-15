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
  },
  solidity: "0.8.18",
};
