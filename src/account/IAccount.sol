// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IAccount {
    function getVerifierWrapper() external view returns (address);

    function getExtension(uint extensionId) external view returns (address);

    function callExtension(
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external;
}
