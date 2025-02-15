require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

const SEPOLIA_URL = process.env.SEPOLIA_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const LOCAL_URL = process.env.LOCAL_URL;
const LOCAL_PRIVATE_KEY = process.env.LOCAL_PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
    solidity: "0.8.27",
    settings: {
        evmVersion: "cancun",
        optimizer: {
            enabled: false,
            runs: 200,
        },
    },
    networks: {
        ganache: {
            url: LOCAL_URL,
            accounts: [LOCAL_PRIVATE_KEY],
            chainId: 1337,
        },
        sepolia: {
            url: SEPOLIA_URL,
            accounts: [PRIVATE_KEY],
            chainId: 11155111,
        },
    },
    etherscan: {
        apiKey: {
            sepolia: process.env.ETHERSCAN_API_KEY,
        },
    },
};
