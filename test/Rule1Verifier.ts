import { ethers } from "hardhat";
import { Signer, Contract } from "ethers";
import { expect } from "chai";
import * as fs from "fs/promises";
import { AbiCoder } from "@ethersproject/abi";


describe("Rule1VerifierWrapper", function () {
    let accounts: Signer[];
    let Verifier: Contract;
    let VerifierWrapper: Contract;

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
        Verifier = await Factory1.deploy();
        await Verifier.deployed();
        const verifierAddress = Verifier.address;
        VerifierWrapper = await Factory2.deploy(verifierAddress);
        await VerifierWrapper.deployed();
        console.log(VerifierWrapper.address);
    });

    it("should pass the verification", async function () {
        const signer = (await ethers.getSigners())[0];
        const param = {
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
        const acc = await fs.readFile("./test_data/evm_agg_acc.hex", "utf-8");
        const proof = await fs.readFile("./test_data/evm_app_proof.hex", "utf-8");
        const result = await VerifierWrapper.verifyWrap(param, acc, proof);
        console.log(result);
        expect(result).to.equal(true);
        // const input = JSON.parse(await fs.readFile("./test_data/evm_public_input.json", "utf-8"));
        // await VoiceKeyRecover.connect(wallet).registerOwner(user.address);
        // expect(await VoiceKeyRecover.connect(wallet).getOwner()).to.equal(user.address);
        // await VoiceKeyRecover.connect(user).registerVoiceOfWallet(wallet.address, input.feature_hash, input.commitment_hash, input.commitment);
        // const registeredData = await VoiceKeyRecover.voiceDataOfWallet(wallet.address);
        // expect(registeredData.featureHash).to.equal(input.feature_hash);
        // expect(registeredData.commitmentHash).to.equal(input.commitment_hash);
        // expect(ethers.utils.hexlify(registeredData.commitment)).to.equal(ethers.utils.hexlify(input.commitment));
    });
});