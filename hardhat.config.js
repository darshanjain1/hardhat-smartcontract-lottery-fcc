require("hardhat-contract-sizer")
require("hardhat-deploy")
require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("@nomiclabs/hardhat-etherscan")
require("@nomiclabs/hardhat-ethers")
require("solidity-coverage")
require("dotenv").config()

const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL
const ACCOUNT1_PRIVATE_KEY = process.env.ACCOUNT1_PRIVATE_KEY
const ACCOUNT2_PRIVATE_KEY = process.env.ACCOUNT2_PRIVATE_KEY
const SEPOLIA_ETHERSCAN_API_KEY = process.env.SEPOLIA_ETHERSCAN_API_KEY

module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: {
    sepolia: {
      accounts: [
        ACCOUNT1_PRIVATE_KEY, ACCOUNT2_PRIVATE_KEY
      ],
      chainId: 11155111,
      url: SEPOLIA_RPC_URL,
      blockConfirmations: 6
    }
  },
  etherscan: {
    apiKey: SEPOLIA_ETHERSCAN_API_KEY
  },
  namedAccounts: {
    deployer: {
      default: 0,
      11155111: 1
    },
    user: {
      default: 1
    }
  }
};
