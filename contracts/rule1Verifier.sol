// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./emailVerifier.sol";

contract Rule1Verifier is EmailVerifier {
    struct Params {
        uint[] bodyHashesStart;
        string[] bodyHashesString;
        uint[] fromAddressesStart;
        string[] fromAddressesString;
        uint[] toAddressesStart;
        string[] toAddressesString;
        uint[] manipulationIdsStart;
        string[] manipulationIdsString;
        uint[] amountsStart;
        string[] amountsString;
        uint[] tokenNamesStart;
        string[] tokenNamesString;
        uint[] recipientsStart;
        string[] recipientsString;
    }

    constructor(
        address _rawVerifier,
        uint _headerMaxBytesLen,
        uint _bodyMaxBytesLen,
        uint _numAggregatedEmails
    )
        EmailVerifier(
            _rawVerifier,
            _headerMaxBytesLen,
            _bodyMaxBytesLen,
            _numAggregatedEmails
        )
    {}

    // function verifyBatch(
    //     bytes calldata paramsBytes,
    //     bytes calldata acc,
    //     bytes calldata proof
    // ) external view returns (bool) {
    //     (
    //         uint[] memory bodyHashesStart,
    //         string[] memory bodyHashesString,
    //         uint[] memory fromAddressesStart,
    //         string[] memory fromAddressesString,
    //         uint[] memory toAddressesStart,
    //         string[] memory toAddressesString,
    //         uint[] memory manipulationIdsStart,
    //         string[] memory manipulationIdsString,
    //         uint[] memory amountsStart,
    //         string[] memory amountsString,
    //         uint[] memory amountsStart,
    //         string[] memory amountsString,

    //     ) = abi.decode(
    //             substringBytes,
    //             (string[], uint[][], string[][], uint[][], string[][])
    //         );
    // }

    function 
}
