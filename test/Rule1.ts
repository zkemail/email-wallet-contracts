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


        const Factory1 = await ethers.getContractFactory("Verifier");
        const Factory2 = await ethers.getContractFactory("VerifierWrapper");
        const Factory3 = await ethers.getContractFactory("Manipulator");
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
        EmailWallet = await Factory4.deploy("emailwallet.relayer@gmail.com", 0, [Manipulator.address], [], []);
        param = {
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
            substr0DecimalPart: 2,
            substr1Start: 90,
            substr1String: "ETH",
            substr2Start: 97,
            substr2String: "alice@gmail.com"
        };
        paramBytes = ethers.utils.defaultAbiCoder.encode([ethers.utils.ParamType.from(
            {
                components: [
                    {
                        "internalType": "uint256",
                        "name": "bodyHashStart",
                        "type": "uint256"
                    },
                    {
                        "internalType": "string",
                        "name": "bodyHashString",
                        "type": "string"
                    },
                    {
                        "internalType": "uint256",
                        "name": "fromAddressStart",
                        "type": "uint256"
                    },
                    {
                        "internalType": "string",
                        "name": "fromAddressString",
                        "type": "string"
                    },
                    {
                        "internalType": "uint256",
                        "name": "toAddressStart",
                        "type": "uint256"
                    },
                    {
                        "internalType": "string",
                        "name": "toAddressString",
                        "type": "string"
                    },
                    {
                        "internalType": "uint256",
                        "name": "subjectStart",
                        "type": "uint256"
                    },
                    {
                        "internalType": "uint256",
                        "name": "manipulationIdUint",
                        "type": "uint256"
                    },
                    {
                        "internalType": "uint256",
                        "name": "substr0Start",
                        "type": "uint256"
                    },
                    {
                        "internalType": "uint256",
                        "name": "substr0IntPart",
                        "type": "uint256"
                    },
                    {
                        "internalType": "uint256",
                        "name": "substr0DecimalPart",
                        "type": "uint256"
                    },
                    {
                        "internalType": "uint256",
                        "name": "substr1Start",
                        "type": "uint256"
                    },
                    {
                        "internalType": "string",
                        "name": "substr1String",
                        "type": "string"
                    },
                    {
                        "internalType": "uint256",
                        "name": "substr2Start",
                        "type": "uint256"
                    },
                    {
                        "internalType": "string",
                        "name": "substr2String",
                        "type": "string"
                    }
                ],
                internalType: "struct VerifierWrapper.Param",
                name: "param",
                type: "tuple"
            },
        )], [param])
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
        const initBalance = BigInt(await EmailWallet.ethBalanceOfUser(param.fromAddressString));
        const tx = await EmailWallet.connect(signer).process(1, paramBytes, acc, proof);
        const receipt = await tx.wait();
        console.log(receipt);
        const newBalance = BigInt(await EmailWallet.ethBalanceOfUser(param.fromAddressString));
        const transferAmount = BigInt(param.substr0IntPart) * BigInt(1e18) + BigInt(param.substr0DecimalPart) * BigInt(1e17)
        expect(initBalance - newBalance).to.equal(transferAmount);
        const recepientBalance = await EmailWallet.ethBalanceOfUser(param.substr2String);
        expect(recepientBalance).to.equal(transferAmount);
    });
});