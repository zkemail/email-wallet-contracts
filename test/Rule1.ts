import { ethers } from "hardhat";
import { Signer, Contract } from "ethers";
import { expect } from "chai";
import * as fs from "fs/promises";
import { AbiCoder } from "@ethersproject/abi";


describe("Rule1Test", function () {
    let Verifier: Contract;
    let VerifierWrapper: Contract;
    let Manipulator: Contract;
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


        const Factory1 = await ethers.getContractFactory("contracts/rule1/Verifier.sol:Verifier");
        const Factory2 = await ethers.getContractFactory("contracts/rule1/VerifierWrapper.sol:VerifierWrapper");
        const Factory3 = await ethers.getContractFactory("contracts/rule1/Manipulator.sol:Manipulator");
        const Factory4 = await ethers.getContractFactory("EmailWallet");
        Verifier = await Factory1.deploy();
        await Verifier.deployed();
        const verifierAddress = Verifier.address;
        // console.log("verifier address: " + verifierAddress);
        VerifierWrapper = await Factory2.deploy(verifierAddress);
        await VerifierWrapper.deployed();
        // console.log(VerifierWrapper.address);
        Manipulator = await Factory3.deploy(verifierAddress);
        await Manipulator.deployed();
        // console.log(Manipulator.address);
        const pk = await fs.readFile("./test_data/gmail_pk.hex", "utf-8");
        EmailWallet = await Factory4.deploy("emailwallet.relayer@gmail.com", 0, pk, [Manipulator.address], [], [], "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2");
        param = {
            headerHash: "0xb8d96f390d94a1700360794a5a2b2bfdb32bf85bdf84af86cc71bb6016733523",
            publicKey: pk,
            bodyHashStart: 441,
            bodyHashString: "6oV/dvdjI9OX+lloaA7zQtQCOxFl8mr+n6rPfIGxHpc=",
            fromAddressStart: 198,
            fromAddressString: "suegamisora@gmail.com",
            toAddressStart: 3,
            toAddressString: "emailwallet.relayer@gmail.com",
            subjectStart: 42,
            manipulationIdUint: 1,
            substr0Start: 86,
            substr0IntPart: 0,
            substr0DecNumZero: 3,
            substr0DecimalPart: 1,
            substr1Start: 93,
            substr1String: "ETH",
            substr2Start: 100,
            substr2String: "alice@gmail.com"
        };
        paramBytes = ethers.utils.defaultAbiCoder.encode(["(bytes32,bytes,uint256,string,uint256,string,uint256,string,uint256,uint256,uint256,uint256,uint256,uint256,uint256,string,uint256,string)"], [[param.headerHash, param.publicKey, param.bodyHashStart, param.bodyHashString, param.fromAddressStart, param.fromAddressString, param.toAddressStart, param.toAddressString, param.subjectStart, param.manipulationIdUint, param.substr0Start, param.substr0IntPart, param.substr0DecNumZero, param.substr0DecimalPart, param.substr1Start, param.substr1String, param.substr2Start, param.substr2String]])
        acc = await fs.readFile("./test_data/evm_agg_acc.hex", "utf-8");
        proof = await fs.readFile("./test_data/evm_agg_proof.hex", "utf-8");
    });

    it("should pass the verification", async function () {
        const result = await Manipulator.verifyWrap(paramBytes, acc, proof);
        expect(result).to.equal(true);
    });

    it("should transfer ETH", async function () {
        const signer = (await ethers.getSigners())[0];
        const depositValue = ethers.utils.parseEther("0.5");
        await EmailWallet.connect(signer).depositETH(param.fromAddressString, { value: depositValue });
        const initBalance = BigInt(await EmailWallet.balanceOfUser(param.fromAddressString, "ETH"));
        const tx = await EmailWallet.connect(signer).process(1, paramBytes, acc, proof);
        const receipt = await tx.wait();
        console.log(receipt);
        const newBalance = BigInt(await EmailWallet.balanceOfUser(param.fromAddressString, "ETH"));
        const transferAmount = ethers.utils.parseEther("0.0001");
        expect(initBalance - newBalance).to.equal(transferAmount);
        const recepientBalance = await EmailWallet.balanceOfUser(param.substr2String, "ETH");
        expect(recepientBalance).to.equal(transferAmount);
    });
});