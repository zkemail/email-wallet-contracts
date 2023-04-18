// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "../emailVerifier.sol";

interface IManipulator {
    // function verifyBatch(
    //     bytes calldata paramsBytes,
    //     bytes calldata acc,
    //     bytes calldata proof
    // ) external view returns (bool);

    // function processBatch(bytes calldata paramsBytes) external;
    function process(bytes calldata param, bytes memory proof) external;

    function retrieveFromAddress(
        bytes calldata param
    ) external view returns (string memory);

    function retrieveToAddress(
        bytes calldata param
    ) external view returns (string memory);

    function retrieveManipulationId(
        bytes calldata param
    ) external view returns (uint);

    function retrieveBodyHash(
        bytes calldata param
    ) external view returns (string memory);
}
