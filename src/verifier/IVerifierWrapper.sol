// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IVerifierWrapper {
    function verifyWrap(
        bytes memory params,
        bytes calldata proof
    ) external view returns (bool);

    function getHeaderHash(bytes memory params) external pure returns (bytes32);

    function getFromAddrSalt(
        bytes memory params
    ) external pure returns (bytes32);

    function getSubjectStr(
        bytes memory params
    ) external pure returns (string memory);

    function getSubjectAddrSalt(
        bytes memory params
    ) external pure returns (bytes32);
}
