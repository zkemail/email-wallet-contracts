// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IVerifierWrapper {
    function verifyWrap(
        bytes memory params,
        bytes calldata proof
    ) external view returns (bool);

    function getHeaderHash(bytes memory params) external pure returns (bytes32);

    function getFromSalt(
        bytes memory params
    ) external pure returns (bytes32, bytes32);

    function getSubjectStr(
        bytes memory params
    ) external pure returns (string memory);

    function getSubjectSalt(
        bytes memory params
    ) external pure returns (bytes32, bytes32);

    function getCcSalt(
        bytes memory params
    ) external pure returns (bytes32, bytes32);

    function getSaltRandHash(
        bytes memory params
    ) external pure returns (bytes32);
}
