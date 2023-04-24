// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EmailWallet.sol";
import "../src/rule1/Verifier.sol";
import "../src/rule1/VerifierWrapper.sol";
import "../src/rule1/Manipulator.sol";
import "../src/rule2/Verifier.sol";
import "../src/rule2/VerifierWrapper.sol";
import "../src/rule2/Manipulator.sol";

contract Rule2Test is Test {
    Rule1Verifier public verifier1;
    Rule1Manipulator public manipulator1;
    Rule2Verifier public verifier2;
    Rule2Manipulator public manipulator2;
    EmailWallet public wallet;

    bytes publicKey;
    Rule1VerifierWrapper.Param param;

    function setUp() public {
        verifier1 = new Rule1Verifier();
        manipulator1 = new Rule1Manipulator(address(verifier1));
        verifier2 = new Rule2Verifier();
        manipulator2 = new Rule2Manipulator(address(verifier2));
        address[] memory manipulators = new address[](2);
        manipulators[0] = address(manipulator1);
        manipulators[1] = address(manipulator2);
        publicKey = vm.parseBytes(vm.readFile("./test_data/gmail_pk.hex"));
        string[] memory tokenNames = new string[](1);
        tokenNames[0] = "DAI";
        address[] memory tokenAddresses = new address[](1);
        tokenAddresses[0] = 0x73967c6a0904aA032C103b4104747E88c566B1A2;
        wallet = new EmailWallet(
            "emailwallet.relayer@gmail.com",
            0,
            publicKey,
            manipulators,
            tokenNames,
            tokenAddresses,
            address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6)
        );
        param.headerHash = bytes32(
            0x0443b5a48ff9163fda82e1bd2a88f4e8314abfa5ddbaf2eb794604e77741fd59
        );
        param.publicKey = publicKey;
        param.bodyHashStart = 441;
        param.bodyHashString = "YQl5mZXdjibPYA3eg5R108LHYUONSTVXRDO+TdPl9KM=";
        param.fromAddressStart = 198;
        param.fromAddressString = "suegamisora@gmail.com";
        param.toAddressStart = 3;
        param.toAddressString = "emailwallet.relayer@gmail.com";
        param.subjectStart = 42;
        param.manipulationIdUint = 2;
        param.substr0Start = 82;
        param.substr0IntPart = 0;
        param.substr0DecNumZero = 5;
        param.substr0DecimalPart = 5;
        param.substr1Start = 91;
        param.substr1String = "ETH";
        param.substr2Start = 98;
        param.substr2String = "DAI";
    }

    function testProof() public {
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_acc_2.hex")
        );
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_proof_2.hex")
        );
        bool isValid = manipulator2.verifyWrap(paramBytes, acc, proof);
        assertEq(isValid, true);
    }

    function testSimpleSwap() public {
        wallet.depositETH{value: 0.5 ether}(param.fromAddressString);
        uint initETHBalance = wallet.balanceOfUser(
            param.fromAddressString,
            "ETH"
        );
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_acc_2.hex")
        );
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_agg_proof_2.hex")
        );
        wallet.process(2, paramBytes, acc, proof);
    }

    // function testSimpleTransfer() public {
    //     wallet.depositETH{value: 0.5 ether}(param.fromAddressString);
    //     uint initBalance = wallet.balanceOfUser(param.fromAddressString, "ETH");
    //     bytes memory paramBytes = abi.encode(param);
    //     bytes memory acc = vm.parseBytes(
    //         vm.readFile("./test_data/evm_agg_acc_1.hex")
    //     );
    //     bytes memory proof = vm.parseBytes(
    //         vm.readFile("./test_data/evm_agg_proof_1.hex")
    //     );
    //     wallet.process(1, paramBytes, acc, proof);
    //     uint newBalance = wallet.balanceOfUser(param.fromAddressString, "ETH");
    //     uint transferAmount = 0.0001 ether;
    //     assertEq(initBalance - transferAmount, newBalance);
    //     uint recepientBalance = wallet.balanceOfUser(
    //         param.substr2String,
    //         "ETH"
    //     );
    //     assertEq(recepientBalance, transferAmount);
    // }
}
