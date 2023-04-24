// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EmailWallet.sol";
import "../src/rule1/Verifier.sol";
import "../src/rule1/VerifierWrapper.sol";
import "../src/rule1/Manipulator.sol";

contract Rule1Test is Test {
    Rule1Verifier public verifier;
    Rule1Manipulator public manipulator;
    EmailWallet public wallet;

    bytes publicKey;
    Rule1VerifierWrapper.Param param;

    function setUp() public {
        verifier = new Rule1Verifier();
        manipulator = new Rule1Manipulator(address(verifier));
        address[] memory manipulators = new address[](1);
        manipulators[0] = address(manipulator);
        publicKey = vm.parseBytes(vm.readFile("./test_data/gmail_pk.hex"));
        wallet = new EmailWallet(
            "emailwallet.relayer@gmail.com",
            0,
            publicKey,
            manipulators,
            new string[](0),
            new address[](0),
            address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6)
        );
        param.headerHash = bytes32(
            0xb8d96f390d94a1700360794a5a2b2bfdb32bf85bdf84af86cc71bb6016733523
        );
        param.publicKey = publicKey;
        param.bodyHashStart = 441;
        param.bodyHashString = "6oV/dvdjI9OX+lloaA7zQtQCOxFl8mr+n6rPfIGxHpc=";
        param.fromAddressStart = 198;
        param.fromAddressString = "suegamisora@gmail.com";
        param.toAddressStart = 3;
        param.toAddressString = "emailwallet.relayer@gmail.com";
        param.subjectStart = 42;
        param.manipulationIdUint = 1;
        param.substr0Start = 86;
        param.substr0IntPart = 0;
        param.substr0DecNumZero = 3;
        param.substr0DecimalPart = 1;
        param.substr1Start = 93;
        param.substr1String = "ETH";
        param.substr2Start = 100;
        param.substr2String = "alice@gmail.com";
    }

    function testProof() public {
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_acc_1.hex")
        );
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_proof_1.hex")
        );
        bool isValid = manipulator.verifyWrap(paramBytes, acc, proof);
        assertEq(isValid, true);
    }

    function testSimpleTransfer() public {
        wallet.depositETH{value: 0.5 ether}(param.fromAddressString);
        uint initBalance = wallet.balanceOfUser(param.fromAddressString, "ETH");
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_acc_1.hex")
        );
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_proof_1.hex")
        );
        wallet.process(1, paramBytes, acc, proof);
        uint newBalance = wallet.balanceOfUser(param.fromAddressString, "ETH");
        uint transferAmount = 0.0001 ether;
        assertEq(initBalance - transferAmount, newBalance);
        uint recepientBalance = wallet.balanceOfUser(
            param.substr2String,
            "ETH"
        );
        assertEq(recepientBalance, transferAmount);
    }

    // function testIncrement() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
