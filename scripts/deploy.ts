import { ethers } from "hardhat";

async function main() {
    const Factory1 = await ethers.getContractFactory("Verifier");
    const Factory2 = await ethers.getContractFactory("Manipulator");
    const Factory3 = await ethers.getContractFactory("EmailWallet");
    const Verifier = await Factory1.deploy();
    await Verifier.deployed();
    const verifierAddress = Verifier.address;
    // console.log("verifier address: " + verifierAddress);
    // console.log(VerifierWrapper.address);
    const Manipulator = await Factory2.deploy(verifierAddress);
    await Manipulator.deployed();
    // console.log(Manipulator.address);
    const EmailWallet = await Factory3.deploy("emailwallet.relayer@gmail.com", 0, [Manipulator.address], [], []);
    console.log(EmailWallet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
