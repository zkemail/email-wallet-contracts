import { ethers } from "hardhat";
import { Signer, Contract } from "ethers";
import { expect } from "chai";
import * as fs from "fs/promises";
import { AbiCoder } from "@ethersproject/abi";


describe("Rule2Test", function () {
    let Verifier1: Contract;
    let Manipulator1: Contract;
    let Verifier2: Contract;
    let Manipulator2: Contract;
    let EmailWallet: Contract;
    let param: any;
    let paramBytes: string;
    let acc: string;
    let proof: string;


    beforeEach(async function () {
        // const verifier = await fs.readFile("./test_data/verifier.hex", "hex");
        // console.log(verifier.length);
        // const signer = (await ethers.getSigners())[0];
        // const factory = ethers.ContractFactory.fromSolidity(
        //     { bytecode: verifier, abi: [] },
        //     signer
        // );
        // const contract = await factory.deploy();
        // await contract.deployed();

        console.log(await ethers.provider.getBlockNumber());
        // const Factory1 = await ethers.getContractFactory("contracts/rule1/Verifier.sol:Verifier");
        // const Factory2 = await ethers.getContractFactory("contracts/rule1/Manipulator.sol:Manipulator");
        const Factory3 = await ethers.getContractFactory("contracts/rule2/Verifier.sol:Verifier");
        const Factory4 = await ethers.getContractFactory("contracts/rule2/Manipulator.sol:Manipulator");
        const Factory5 = await ethers.getContractFactory("EmailWallet");
        // Verifier1 = await Factory1.deploy();
        // await Verifier1.deployed();
        // const verifierAddress1 = Verifier1.address;
        // Manipulator1 = await Factory2.deploy(verifierAddress1);
        // await Manipulator1.deployed();
        Verifier2 = await Factory3.deploy();
        await Verifier2.deployed();
        const verifierAddress2 = Verifier2.address;
        Manipulator2 = await Factory4.deploy(verifierAddress2);
        await Manipulator2.deployed();
        // console.log(Manipulator.address);
        const pk = await fs.readFile("./test_data/gmail_pk.hex", "utf-8");
        EmailWallet = await Factory5.deploy("emailwallet.relayer@gmail.com", 0, pk, [/*Manipulator1.address,*/ Manipulator2.address], ["DAI"], ["0x73967c6a0904aA032C103b4104747E88c566B1A2"/*"0x6B175474E89094C44Da98b954EedeAC495271d0F"*/], "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6"/*"0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"*/);
        param = {
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
        paramBytes = ethers.utils.defaultAbiCoder.encode(["(bytes32,bytes,uint256,string,uint256,string,uint256,string,uint256,uint256,uint256,uint256,uint256,uint256,uint256,string,uint256,string)"], [[param.headerHash, param.publicKey, param.bodyHashStart, param.bodyHashString, param.fromAddressStart, param.fromAddressString, param.toAddressStart, param.toAddressString, param.subjectStart, param.manipulationIdUint, param.substr0Start, param.substr0IntPart, param.substr0DecNumZero, param.substr0DecimalPart, param.substr1Start, param.substr1String, param.substr2Start, param.substr2String]])
        acc = await fs.readFile("./test_data/evm_agg_acc.hex", "utf-8");
        proof = await fs.readFile("./test_data/evm_agg_proof.hex", "utf-8");
    });

    it("should pass the verification", async function () {
        const result = await Manipulator2.verifyWrap(paramBytes, acc, proof);
        // expect(result).to.equal(true);
    });

    it("should swap ETH to DAI", async function () {
        const signer = (await ethers.getSigners())[0];
        const depositValue = ethers.utils.parseEther("0.000001");
        await EmailWallet.depositETH(param.fromAddressString, { value: depositValue });
        const initBalanceETH = BigInt(await EmailWallet.balanceOfUser(param.fromAddressString, "ETH"));
        const initBalanceDAI = BigInt(await EmailWallet.balanceOfUser(param.fromAddressString, "DAI"));
        const tx = await EmailWallet.process(1, paramBytes, acc, proof);
        const receipt = await tx.wait();
        console.log(receipt);
        const newBalanceETH = BigInt(await EmailWallet.balanceOfUser(param.fromAddressString, "ETH"));
        const swapAmount = ethers.utils.parseEther("0.0000005");
        expect(initBalanceETH - newBalanceETH).to.equal(swapAmount);
        expect(await EmailWallet.balanceOfUser(param.fromAddressString, "DAI")).not.equal(ethers.BigNumber.from(0));
    });
});