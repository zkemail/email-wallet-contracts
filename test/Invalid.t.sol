// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";
import "forge-std/console.sol";
import "../src/interfaces/IManipulator.sol";
import "../src/interfaces/IERC20.sol";
import "forge-std/console.sol";
import "../src/EmailWallet.sol";
import "forge-std/Test.sol";
import "./VerifierApp.sol";

contract VerifierAppWrapper {
    using Strings for uint;
    uint constant HEADER_MAX_BYTE_SIZE = 512;
    uint constant BODY_MAX_BYTE_SIZE = 512;
    address verifier;

    struct Param {
        bytes32 headerHash;
        bytes publicKey;
        uint bodyHashStart;
        string bodyHashString;
        uint fromAddressStart;
        string fromAddressString;
        uint toAddressStart;
        string toAddressString;
        uint subjectStart;
        uint manipulationIdUint;
        uint substr0Start;
        uint substr0IntPart;
        uint substr0DecNumZero;
        uint substr0DecimalPart;
        uint substr1Start;
        string substr1String;
        uint substr2Start;
        string substr2String;
    }

    constructor(address _verifier) {
        verifier = _verifier;
    }

    function _verifyWrap(
        Param memory param,
        bytes calldata proof
    ) internal view returns (bool) {
        bytes memory publicInputBytes = convertParamToBytes(param);
        bytes32 publicHash = sha256(publicInputBytes);
        uint[] memory pubInputs = new uint[](1);
        uint coeff = 1;
        pubInputs[0] = 0;
        for (uint i = 0; i < 31; i++) {
            pubInputs[0] += (coeff * uint(uint8(publicHash[i])));
            coeff = coeff << 8;
        }
        console.log("public input %s", pubInputs[0]);
        return VerifierApp(verifier).verify(pubInputs, proof);
    }

    function convertParamToBytes(
        Param memory param
    ) private pure returns (bytes memory) {
        bytes memory metaBytes = abi.encodePacked(
            abi.encodePacked(param.headerHash),
            bytes(param.bodyHashString),
            new bytes(128 - 32 - 44),
            param.publicKey
        );
        bytes memory maskedStrPart = new bytes(
            HEADER_MAX_BYTE_SIZE + BODY_MAX_BYTE_SIZE
        );
        bytes memory substrIdsPart = new bytes(
            HEADER_MAX_BYTE_SIZE + BODY_MAX_BYTE_SIZE
        );
        bytes memory bodyHashBytes = bytes(param.bodyHashString);
        for (uint i = 0; i < bodyHashBytes.length; i++) {
            maskedStrPart[param.bodyHashStart + i] = bodyHashBytes[i];
            substrIdsPart[param.bodyHashStart + i] = bytes1(uint8(1));
        }
        bytes memory fromAddressBytes = bytes(param.fromAddressString);
        for (uint i = 0; i < fromAddressBytes.length; i++) {
            maskedStrPart[param.fromAddressStart + i] = fromAddressBytes[i];
            substrIdsPart[param.fromAddressStart + i] = bytes1(uint8(2));
        }
        bytes memory toAddressBytes = bytes(param.toAddressString);
        for (uint i = 0; i < toAddressBytes.length; i++) {
            maskedStrPart[param.toAddressStart + i] = toAddressBytes[i];
            substrIdsPart[param.toAddressStart + i] = bytes1(uint8(3));
        }
        bytes memory subjectBytes = bytes(
            string.concat(
                "Email Wallet Manipulation ID ",
                param.manipulationIdUint.toString()
            )
        );
        for (uint i = 0; i < subjectBytes.length; i++) {
            maskedStrPart[param.subjectStart + i] = subjectBytes[i];
            substrIdsPart[param.subjectStart + i] = bytes1(uint8(4));
        }

        bytes memory substr0Bytes = bytes(
            decString(
                param.substr0IntPart,
                param.substr0DecNumZero,
                param.substr0DecimalPart
            )
        );
        for (uint i = 0; i < substr0Bytes.length; i++) {
            maskedStrPart[
                HEADER_MAX_BYTE_SIZE + param.substr0Start + i
            ] = substr0Bytes[i];
            substrIdsPart[
                HEADER_MAX_BYTE_SIZE + param.substr0Start + i
            ] = bytes1(uint8(1));
        }
        bytes memory substr1Bytes = bytes(param.substr1String);
        for (uint i = 0; i < substr1Bytes.length; i++) {
            maskedStrPart[
                HEADER_MAX_BYTE_SIZE + param.substr1Start + i
            ] = substr1Bytes[i];
            substrIdsPart[
                HEADER_MAX_BYTE_SIZE + param.substr1Start + i
            ] = bytes1(uint8(2));
        }
        bytes memory substr2Bytes = bytes(param.substr2String);
        for (uint i = 0; i < substr2Bytes.length; i++) {
            maskedStrPart[
                HEADER_MAX_BYTE_SIZE + param.substr2Start + i
            ] = substr2Bytes[i];
            substrIdsPart[
                HEADER_MAX_BYTE_SIZE + param.substr2Start + i
            ] = bytes1(uint8(3));
        }
        return abi.encodePacked(metaBytes, maskedStrPart, substrIdsPart);
    }

    function decString(
        uint intPart,
        uint decNumZero,
        uint decPart
    ) internal pure returns (string memory) {
        string memory decString = string.concat(intPart.toString(), ".");
        for (uint i = 0; i < decNumZero; i++) {
            decString = string.concat(decString, "0");
        }
        decString = string.concat(decString, decPart.toString());
        return decString;
    }
}

contract Rule1InvalidManipulator is IManipulator, VerifierAppWrapper {
    EmailWallet wallet;
    event EmailTransfer(
        string indexed amount,
        string indexed currency,
        string indexed recipient
    );

    constructor(
        address _verifier,
        address payable _wallet
    ) VerifierAppWrapper(_verifier) {
        wallet = EmailWallet(_wallet);
    }

    function verifyWrap(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool) {
        Param memory param = abi.decode(param, (Param));
        return _verifyWrap(param, proof);
    }

    function process(bytes calldata param) external {
        Param memory param = abi.decode(param, (Param));
        string memory tokenStr = param.substr1String;
        require(wallet.isRegisteredToken(tokenStr), "not registered token");
        IERC20 token = IERC20(wallet.erc20OfTokenName(tokenStr));
        uint decimals = uint(token.decimals());
        uint amount = param.substr0IntPart *
            10 ** decimals +
            param.substr0DecimalPart *
            10 ** (decimals - 1 - param.substr0DecNumZero);
        require(
            wallet.balanceOfUser(param.fromAddressString, tokenStr) >= amount
        );
        wallet.manipulateBalanceOfUser(
            param.fromAddressString,
            tokenStr,
            wallet.balanceOfUser(param.fromAddressString, tokenStr) - amount
        );
        wallet.manipulateBalanceOfUser(
            param.substr2String,
            tokenStr,
            wallet.balanceOfUser(param.substr2String, tokenStr) + amount
        );
        string memory amountStr = decString(
            param.substr0IntPart,
            param.substr0DecNumZero,
            param.substr0DecimalPart
        );
        emit EmailTransfer(amountStr, param.substr1String, param.substr2String);
    }

    function retrieveData(
        bytes calldata param
    ) external view returns (RetrievedData memory) {
        Param memory param = abi.decode(param, (Param));
        RetrievedData memory data;
        data.headerHash = param.headerHash;
        data.publicKey = param.publicKey;
        data.fromAddress = param.fromAddressString;
        data.toAddress = param.toAddressString;
        data.manipulationId = param.manipulationIdUint;
        return data;
    }
}

contract InvalidTest is Test {
    VerifierApp public verifier;
    Rule1InvalidManipulator public manipulator;
    EmailWallet public wallet;

    bytes publicKey;
    Rule1InvalidManipulator.Param param;

    function setUp() public {
        publicKey = vm.parseBytes(vm.readFile("./test_data/gmail_pk.hex"));
        wallet = new EmailWallet(
            "emailwallet.relayer@gmail.com",
            0,
            publicKey,
            new string[](0),
            new address[](0),
            address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1)
        );
        verifier = new VerifierApp();
        manipulator = new Rule1InvalidManipulator(
            address(verifier),
            payable(address(wallet))
        );
        wallet.addManipulation(address(manipulator));
        param.headerHash = bytes32(
            0xfd5fec7a117b02b6da3ccbae1a898bf6cf6b7be803e45ba148e78a3b9d6c4ca0
        );
        param.publicKey = publicKey;
        param.bodyHashStart = 441;
        param.bodyHashString = "GxMlgwLiypnVrE2C0Sf4yzhcWTkAhSZ5+WERhKhXtlU=";
        param.fromAddressStart = 198;
        param.fromAddressString = "suegamisora@gmail.com";
        param.toAddressStart = 3;
        param.toAddressString = "emailwallet.relayer@gmail.com";
        param.subjectStart = 42;
        param.manipulationIdUint = 1;
        param.substr0Start = 86;
        param.substr0IntPart = 0;
        param.substr0DecNumZero = 0;
        param.substr0DecimalPart = 2;
        param.substr1Start = 90;
        param.substr1String = "ETH";
        param.substr2Start = 97;
        param.substr2String = "alice@gmail.com";
    }

    function testValidProof() public {
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = new bytes(0);
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_app_proof_valid1.hex")
        );
        bool isValid = manipulator.verifyWrap(paramBytes, acc, proof);
        assertEq(isValid, true);
    }

    function testInvalid1Proof() public {
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = new bytes(0);
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_app_proof_invalid1.hex")
        );
        bool isValid = manipulator.verifyWrap(paramBytes, acc, proof);
        assertEq(isValid, false);
    }

    function testInvalid2Proof() public {
        param.headerHash = bytes32(
            0x8a1334d6c3daf5a8e25a0bd36e41780eabfab3b8ad29525fd93298ada4dce5a2
        );
        param.publicKey = publicKey;
        param.bodyHashString = "a8aigxYi+c4F+qyWJg+TW8ur8gkehHInysko3xtlayM=";
        param.substr0Start = 90;
        param.substr1Start = 94;
        param.substr2Start = 101;
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = new bytes(0);
        bytes memory proof = vm.parseBytes(
            vm.readFile("./test_data/evm_app_proof_invalid2.hex")
        );
        vm.expectRevert();
        manipulator.verifyWrap(paramBytes, acc, proof);
    }

    function testSimpleTransferWithValidAndInvalid() public {
        startHoax(vm.addr(1));
        wallet.depositETH{value: 0.5 ether}(param.fromAddressString);
        vm.stopPrank();
        uint initBalance = wallet.balanceOfUser(param.fromAddressString, "ETH");
        bytes memory paramBytes = abi.encode(param);
        bytes memory acc = new bytes(0);
        bytes memory proofInvalid1 = vm.parseBytes(
            vm.readFile("./test_data/evm_app_proof_invalid1.hex")
        );
        vm.expectRevert("invalid proof");
        wallet.process(1, paramBytes, acc, proofInvalid1);
        bytes memory proofValid = vm.parseBytes(
            vm.readFile("./test_data/evm_app_proof_valid1.hex")
        );
        wallet.process(1, paramBytes, acc, proofValid);
        param.headerHash = bytes32(
            0x8a1334d6c3daf5a8e25a0bd36e41780eabfab3b8ad29525fd93298ada4dce5a2
        );
        param.publicKey = publicKey;
        param.bodyHashString = "a8aigxYi+c4F+qyWJg+TW8ur8gkehHInysko3xtlayM=";
        param.substr0Start = 90;
        param.substr1Start = 94;
        param.substr2Start = 101;
        paramBytes = abi.encode(param);
        bytes memory proofInvalid2 = vm.parseBytes(
            vm.readFile("./test_data/evm_app_proof_invalid2.hex")
        );
        vm.expectRevert();
        wallet.process(1, paramBytes, acc, proofInvalid2);
        uint newBalance = wallet.balanceOfUser(param.fromAddressString, "ETH");
        uint transferAmount = 0.2 ether;
        assertEq(initBalance - transferAmount, newBalance);
        uint recepientBalance = wallet.balanceOfUser(
            param.substr2String,
            "ETH"
        );
        assertEq(recepientBalance, transferAmount);
    }
}
