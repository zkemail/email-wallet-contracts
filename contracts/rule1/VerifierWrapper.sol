// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./Verifier.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract VerifierWrapper {
    using Strings for uint;
    uint constant HEADER_MAX_BYTE_SIZE = 512;
    uint constant BODY_MAX_BYTE_SIZE = 512;
    Verifier verifier;
    // uint constant HEADER_SUBSTRS_SIZE = 4;
    // uint constant BODY_SUBSTRS_SIZE = 3;
    // uint constant ALL_INPUT_BYTES_SIZE =
    //     64 + 2 * (HEADER_MAX_BYTE_SIZE + BODY_MAX_BYTE_SIZE);

    struct Param {
        uint bodyHashStart;
        string bodyHashString;
        uint fromAddressStart;
        string fromAddressString;
        uint toAddressStart;
        string toAddressString;
        uint manipulationIdStart;
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
        verifier = Verifier(_verifier);
    }

    function verifyWrap(
        Param memory param,
        bytes calldata proof
    ) internal view returns (bool) {
        bytes memory publicInputBytes = convertParamToBytes(param);
        uint publicHash = uint(sha256(publicInputBytes));
        uint[] memory pubInputs = new uint[](2);
        pubInputs[0] = publicHash & ((1 << 128) - 1);
        pubInputs[1] = publicHash >> 128;
        return verifier.verify(pubInputs, proof);
    }

    function convertParamToBytes(
        Param memory param
    ) private pure returns (bytes memory) {
        bytes memory bodyHashPart = abi.encodePacked(
            bytes(param.bodyHashString),
            new bytes(64 - 44)
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
        bytes memory manipulationIdBytes = bytes(
            param.manipulationIdUint.toString()
        );
        for (uint i = 0; i < manipulationIdBytes.length; i++) {
            maskedStrPart[param.manipulationIdStart + i] = manipulationIdBytes[
                i
            ];
            substrIdsPart[param.manipulationIdStart + i] = bytes1(uint8(4));
        }

        bytes memory substr0Bytes = bytes(
            string.concat(
                param.substr0IntPart.toString(),
                ".",
                param.substr0DecimalPart.toString()
            )
        );
        for (uint i = 0; i < substr0Bytes.length; i++) {
            maskedStrPart[param.substr0Start + i] = substr0Bytes[i];
            substrIdsPart[param.substr0Start + i] = bytes1(uint8(1));
        }
        bytes memory substr1Bytes = bytes(param.substr1String);
        for (uint i = 0; i < substr1Bytes.length; i++) {
            maskedStrPart[param.substr1Start + i] = substr1Bytes[i];
            substrIdsPart[param.substr1Start + i] = bytes1(uint8(2));
        }
        bytes memory substr2Bytes = bytes(param.substr2String);
        for (uint i = 0; i < substr2Bytes.length; i++) {
            maskedStrPart[param.substr2Start + i] = substr2Bytes[i];
            substrIdsPart[param.substr2Start + i] = bytes1(uint8(3));
        }

        // EmailVerifier.SubstrParams memory substrParams;
        // substrParams.bodyHash = params.bodyHashString;
        // uint[] memory headerSubstrsStart = new uint[](HEADER_SUBSTRS_SIZE);
        // string[] memory headerSubstrsString = new string[](HEADER_SUBSTRS_SIZE);
        // headerSubstrsStart[0] = params.bodyHashStart;
        // headerSubstrsString[0] = params.bodyHashString;
        // headerSubstrsStart[1] = params.fromAddressStart;
        // headerSubstrsString[1] = params.fromAddressString;
        // headerSubstrsStart[2] = params.toAddressStart;
        // headerSubstrsString[2] = params.toAddressString;
        // headerSubstrsStart[3] = params.manipulationIdStart;
        // headerSubstrsString[3] = params.manipulationIdUint.toString();
        // substrParams.headerSubstrsStart = headerSubstrsStart;
        // substrParams.headerSubstrsString = headerSubstrsString;
        // uint[] memory bodySubstrsStart = new uint[](BODY_SUBSTRS_SIZE);
        // string[] memory bodySubstrsString = new string[](BODY_SUBSTRS_SIZE);
        // bodySubstrsStart[0] = params.amountStart;
        // bodySubstrsString[0] = params.amountUint.toString();
        // bodySubstrsStart[1] = params.tokenNameStart;
        // bodySubstrsString[1] = params.tokenNameString;
        // bodySubstrsStart[2] = params.recipientStart;
        // bodySubstrsString[2] = params.recipientString;
        // substrParams.bodySubstrsStart = bodySubstrsStart;
        // substrParams.bodySubstrsString = bodySubstrsString;
        return abi.encodePacked(bodyHashPart, maskedStrPart, substrIdsPart);
    }
}
