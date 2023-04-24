import { ethers } from "hardhat";
import * as fs from "fs/promises";

async function main() {
    const signer = (await ethers.getSigners())[0];
    const Factory = await ethers.getContractFactory("EmailWallet");
    const contractAddress = "0xB163A36132c23F2dc4C6D9719C918E356655DfC8"
    console.log(contractAddress);
    const value = "0.000002";
    console.log(value);
    const emailAddress = "suegamisora@gmail.com";
    console.log(emailAddress);
    const EmailWallet = await Factory.attach(contractAddress);
    const depositValue = ethers.utils.parseEther(value);
    const tx1 = await EmailWallet.connect(signer).depositETH(emailAddress, { value: depositValue });
    const receipt1 = await tx1.wait();
    console.log(receipt1);
    console.log(await EmailWallet.balanceOfUser(emailAddress, "ETH"));
    const pk = await fs.readFile("./test_data/gmail_pk.hex", "utf-8");
    const param = {
        headerHash: "0xfd5fec7a117b02b6da3ccbae1a898bf6cf6b7be803e45ba148e78a3b9d6c4ca0",
        publicKey: pk,
        bodyHashStart: 441,
        bodyHashString: "GxMlgwLiypnVrE2C0Sf4yzhcWTkAhSZ5+WERhKhXtlU=",
        fromAddressStart: 198,
        fromAddressString: "suegamisora@gmail.com",
        toAddressStart: 3,
        toAddressString: "emailwallet.relayer@gmail.com",
        subjectStart: 42,
        manipulationIdUint: 1,
        substr0Start: 86,
        substr0IntPart: 0,
        substr0DecNumZero: 6,
        substr0DecimalPart: 5,
        substr1Start: 90,
        substr1String: "ETH",
        substr2Start: 97,
        substr2String: "DAI"
    };
    const paramBytes = ethers.utils.defaultAbiCoder.encode(["(bytes32,bytes,uint256,string,uint256,string,uint256,string,uint256,uint256,uint256,uint256,uint256,uint256,uint256,string,uint256,string)"], [[param.headerHash, param.publicKey, param.bodyHashStart, param.bodyHashString, param.fromAddressStart, param.fromAddressString, param.toAddressStart, param.toAddressString, param.subjectStart, param.manipulationIdUint, param.substr0Start, param.substr0IntPart, param.substr0DecNumZero, param.substr0DecimalPart, param.substr1Start, param.substr1String, param.substr2Start, param.substr2String]])
    const acc = await fs.readFile("./test_data/evm_agg_acc.hex", "utf-8");
    const proof = await fs.readFile("./test_data/evm_agg_proof.hex", "utf-8");
    const tx2 = await EmailWallet.process(1, paramBytes, acc, proof);
    const receipt2 = await tx2.wait();
    console.log(receipt2);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
