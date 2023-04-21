// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract EmailVerifier {
    address rawVerifier;
    uint headerMaxBytesLen;
    uint bodyMaxBytesLen;
    uint numAggregatedEmails;
    uint constant bodyHashBytesLen = 44;

    struct SubstrParams {
        string bodyHash;
        uint[] headerSubstrsStart;
        string[] headerSubstrsString;
        uint[] bodySubstrsStart;
        string[] bodySubstrsString;
    }

    constructor(
        address _rawVerifier,
        uint _headerMaxBytesLen,
        uint _bodyMaxBytesLen,
        uint _numAggregatedEmails
    ) {
        rawVerifier = _rawVerifier;
        headerMaxBytesLen = _headerMaxBytesLen;
        bodyMaxBytesLen = _bodyMaxBytesLen;
        numAggregatedEmails = _numAggregatedEmails;
    }

    function verify(
        bytes calldata acc,
        bytes calldata substringBytes,
        bytes calldata proof
    ) public view returns (bool) {
        SubstrParams[] memory substrParams = abi.decode(
            substringBytes,
            (SubstrParams[])
        );
        return verifyInternal(acc, substrParams, proof);
    }

    function verifyInternal(
        bytes calldata acc,
        SubstrParams[] memory substrParams,
        bytes calldata proof
    ) internal view returns (bool) {
        bytes memory verifyInput = acc;
        require(substrParams.length == numAggregatedEmails);
        for (uint i = 0; i < numAggregatedEmails; i++) {
            bytes memory emailInstances = encodeInstancesPerEmail(
                substrParams[i].bodyHash,
                substrParams[i].headerSubstrsStart,
                substrParams[i].headerSubstrsString,
                substrParams[i].bodySubstrsStart,
                substrParams[i].bodySubstrsString
            );
            verifyInput = abi.encodePacked(verifyInput, emailInstances);
        }
        verifyInput = abi.encodePacked(verifyInput, proof);
        return _verify(verifyInput);
    }

    function encodeInstancesPerEmail(
        string memory bodyHash,
        uint[] memory headerSubstrsStart,
        string[] memory headerSubstrsString,
        uint[] memory bodySubstrsStart,
        string[] memory bodySubstrsString
    ) private view returns (bytes memory) {
        require(headerSubstrsStart.length == headerSubstrsString.length);
        require(bodySubstrsStart.length == bodySubstrsString.length);
        uint instanceBytesLen = 32 *
            (bodyHashBytesLen + 2 * (headerMaxBytesLen + bodyMaxBytesLen));
        bytes memory substrInstances = new bytes(instanceBytesLen);
        bytes memory bodyHashBytes = bytes(bodyHash);
        for (uint i = 0; i < bodyHashBytes.length; i++) {
            substrInstances[32 * i + 31] = bodyHashBytes[i];
        }
        for (
            uint substrIdx = 0;
            substrIdx < headerSubstrsStart.length;
            substrIdx++
        ) {
            uint start = headerSubstrsStart[substrIdx];
            bytes memory substrBytes = bytes(headerSubstrsString[substrIdx]);
            for (uint i = 0; i < substrBytes.length; i++) {
                substrInstances[
                    32 * bodyHashBytesLen + 32 * (start + i) + 31
                ] = substrBytes[i];
                substrInstances[
                    32 *
                        (bodyHashBytesLen +
                            headerMaxBytesLen +
                            bodyMaxBytesLen) +
                        32 *
                        (start + i) +
                        31
                ] = bytes1(uint8(substrIdx) + 1);
            }
        }
        for (
            uint substrIdx = 0;
            substrIdx < bodySubstrsStart.length;
            substrIdx++
        ) {
            uint start = bodySubstrsStart[substrIdx];
            bytes memory substrBytes = bytes(bodySubstrsString[substrIdx]);
            for (uint i = 0; i < substrBytes.length; i++) {
                substrInstances[
                    32 *
                        (bodyHashBytesLen + headerMaxBytesLen) +
                        32 *
                        (start + i) +
                        31
                ] = substrBytes[i];
                substrInstances[
                    32 *
                        (bodyHashBytesLen +
                            2 *
                            headerMaxBytesLen +
                            bodyMaxBytesLen) +
                        32 *
                        (start + i) +
                        31
                ] = bytes1(uint8(substrIdx) + 1);
            }
        }
        return substrInstances;
    }

    function _verify(bytes memory input) private view returns (bool) {
        (bool success, ) = rawVerifier.staticcall(input);
        return success;
    }
}
