// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

interface IManipulator {
    // function verifyBatch(
    //     bytes calldata paramsBytes,
    //     bytes calldata acc,
    //     bytes calldata proof
    // ) external view returns (bool);

    // function processBatch(bytes calldata paramsBytes) external;
    struct RetrievedData {
        string headerHash;
        bytes publicKey;
        string fromAddress;
        string toAddress;
        uint manipulationId;
    }

    function verifyWrap(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool);

    function process(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external;

    function retrieveData(
        bytes calldata param
    ) external view returns (RetrievedData memory);
}
