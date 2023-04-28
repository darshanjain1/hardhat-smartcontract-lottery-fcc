const { network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat.config.js")
const verify = require("../tasks/verify.js")

module.exports = async ({ deployments, getNamedAccounts, getChainId }) => {
    const { deploy, get } = deployments
    const { deployer } = await getNamedAccounts()
    const isDevelopmentChain = developmentChains.includes(network.name);
    const args = ["100000000000000000"]
    const Raffle = await deploy("Raffle", {
        contract: "Raffle",
        from: deployer,
        args,
        waitConfirmations: network.config.blockConfirmations || 1,
        logs: true
    })
    if (!isDevelopmentChain && process.env.SEPOLIA_ETHERSCAN_API_KEY) {
        const RaffleContract = await get("Raffle")
        await verify(RaffleContract.address, args);
    }

}
module.exports.tags = ["all", "raffle"]