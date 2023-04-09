// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "../emailVerifier.sol";

interface IManipulator {
    function verifyBatch(
        bytes calldata paramsBytes,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool);

    function processBatch(bytes calldata paramsBytes) external;

    function retrieveFromAddresses(
        bytes calldata paramsBytes
    ) external view returns (string[] memory);

    function retrieveToAddresses(
        bytes calldata paramsBytes
    ) external view returns (string[] memory);

    function retrieveManipulationIds(
        bytes calldata paramsBytes
    ) external view returns (uint[] memory);

    function retrieveBodyHashes(
        bytes calldata paramsBytes
    ) external view returns (string[] memory);
}
