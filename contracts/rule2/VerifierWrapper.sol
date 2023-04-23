// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./Verifier.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract VerifierWrapper {
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
        bytes calldata acc,
        bytes calldata proof
    ) internal view returns (bool) {
        bytes memory publicInputBytes = convertParamToBytes(param);
        bytes32 publicHash = sha256(publicInputBytes);
        // console.log("publicHash %s", uint(publicHash));
        uint[] memory pubInputs = new uint[](13);
        uint[12] memory accInputs = abi.decode(acc, (uint[12]));
        for (uint i = 0; i < 12; i++) {
            console.log("%s-th acc %s", i, accInputs[i]);
            pubInputs[i] = accInputs[i];
        }
        uint coeff = 1;
        pubInputs[12] = 0;
        // pubInputs[17] = 0;
        for (uint i = 0; i < 31; i++) {
            pubInputs[12] += (coeff * uint(uint8(publicHash[i])));
            // pubInputs[17] += (coeff * uint(uint8(publicHash[16 + i])));
            coeff = coeff << 8;
        }
        // pubInputs[12] = 0xa33d4a7bf0543cea77bff0914c046818;
        // pubInputs[13] = 0x5d874980596f029b25350f4a9f45315f;
        console.log("pubInput %s", pubInputs[12]);
        // console.log("pubInput 2 %s", pubInputs[17]);
        return Verifier(verifier).verify(pubInputs, proof);
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
            string.concat(
                param.substr0IntPart.toString(),
                ".",
                param.substr0DecimalPart.toString()
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
}
