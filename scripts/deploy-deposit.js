const { ethers, run } = require("hardhat");

async function main() {
    // 获取部署者账号（这里使用的是配置文件中指定的私钥）
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    const balance = await ethers.provider.getBalance(deployer.address);
    console.log("Account balance:", balance.toString());

    // 获取合约工厂并部署合约
    const ContractFactory = await ethers.getContractFactory("DepositWithdraw");
    
    console.log("Deploying contract...");
    const contract = await ContractFactory.deploy();
    await contract.waitForDeployment();
    // console.log('contract', contract);
    const contractAddress = await contract.getAddress();
    console.log("Contract deployed to:", contractAddress);

    
    // 验证合约
    console.log("Verifying contract...");
    try {
        await contract.deploymentTransaction()?.wait(5);
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: [],
        });
    } catch (error) {
        console.log("error", error);
    }
}

// 运行部署脚本
main()
    .then(() => {process.exit(0)})
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
