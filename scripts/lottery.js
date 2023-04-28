const { ethers } = require("hardhat")

const main = async () => {
    const RaffleContract = await ethers.getContract("Raffle");
    const value = await ethers.utils.parseEther("0.1");
    const transactionResponse = await RaffleContract.enterRaffle({ value });
    await transactionResponse.wait()
    console.log('RaffleContract.getOwner()', await RaffleContract.getOwner())
}
main().catch(err => { console.log('error occured while running lottery script', err); process.exit(1) })