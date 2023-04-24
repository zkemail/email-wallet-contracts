import { ethers } from "hardhat";
import * as fs from "fs/promises";

async function main() {
    const Factory1 = await ethers.getContractFactory("contracts/rule1/Verifier.sol:Verifier");
    const Factory2 = await ethers.getContractFactory("contracts/rule1/Manipulator.sol:Manipulator");
    const Factory3 = await ethers.getContractFactory("contracts/rule2/Verifier.sol:Verifier");
    const Factory4 = await ethers.getContractFactory("contracts/rule2/Manipulator.sol:Manipulator");
    const Factory5 = await ethers.getContractFactory("EmailWallet");
    // const Verifier = await Factory1.deploy();
    // await Verifier.deployed();
    // const verifierAddress = Verifier.address;
    // const Manipulator = await Factory2.deploy(verifierAddress);
    // await Manipulator.deployed();
    const Verifier = await Factory3.deploy();
    await Verifier.deployed();
    const verifierAddress = Verifier.address;
    const Manipulator = await Factory4.deploy(verifierAddress);
    await Manipulator.deployed();
    // console.log(Manipulator.address);
    const pk = await fs.readFile("./test_data/gmail_pk.hex", "utf-8");
    const wethAddress = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6" // testnet
    const EmailWallet = await Factory5.deploy("emailwallet.relayer@gmail.com", 0, pk, [Manipulator.address], ["DAI"], ["0x73967c6a0904aA032C103b4104747E88c566B1A2"], wethAddress);
    console.log(EmailWallet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
