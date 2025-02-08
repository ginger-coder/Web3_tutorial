const { ethers } = require("hardhat");

async function main() {
    // 获取部署者账号（这里使用的是配置文件中指定的私钥）
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with account:", deployer.address);

    const balance = await ethers.provider.getBalance(deployer.address);
    console.log("Account balance:", balance.toString());

    // 获取合约工厂并部署合约
    const ContractFactory = await ethers.getContractFactory("DepositWithdraw");

    const contract = await ContractFactory.deploy();
    console.log("Deploying contract...");
    // console.log('contract', contract);

    await contract.deployTransaction.wait(); // 等待交易确认
    console.log("Contract deployed to:", contract.address);

    // await contract.deployed();
    // console.log("Contract deployed to:", contract.target);
}

// 运行部署脚本
main()
    .then(() => {})
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
