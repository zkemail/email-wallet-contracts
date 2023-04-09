// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./emailVerifier.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract Rule1Helper is EmailVerifier {
    using Strings for uint;
    uint constant HEADER_SUBSTRS_SIZE = 4;
    uint constant BODY_SUBSTRS_SIZE = 3;

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

    struct Params {
        uint bodyHashStart;
        string bodyHashString;
        uint fromAddressStart;
        string fromAddressString;
        uint toAddressStart;
        string toAddressString;
        uint manipulationIdStart;
        uint manipulationIdUint;
        uint amountStart;
        uint amountUint;
        uint tokenNameStart;
        string tokenNameString;
        uint recipientStart;
        string recipientString;
    }

    function convertToSubstrParams(
        Params memory params
    ) internal pure returns (EmailVerifier.SubstrParams memory) {
        EmailVerifier.SubstrParams memory substrParams;
        substrParams.bodyHash = params.bodyHashString;
        uint[] memory headerSubstrsStart = new uint[](HEADER_SUBSTRS_SIZE);
        string[] memory headerSubstrsString = new string[](HEADER_SUBSTRS_SIZE);
        headerSubstrsStart[0] = params.bodyHashStart;
        headerSubstrsString[0] = params.bodyHashString;
        headerSubstrsStart[1] = params.fromAddressStart;
        headerSubstrsString[1] = params.fromAddressString;
        headerSubstrsStart[2] = params.toAddressStart;
        headerSubstrsString[2] = params.toAddressString;
        headerSubstrsStart[3] = params.manipulationIdStart;
        headerSubstrsString[3] = params.manipulationIdUint.toString();
        substrParams.headerSubstrsStart = headerSubstrsStart;
        substrParams.headerSubstrsString = headerSubstrsString;
        uint[] memory bodySubstrsStart = new uint[](BODY_SUBSTRS_SIZE);
        string[] memory bodySubstrsString = new string[](BODY_SUBSTRS_SIZE);
        bodySubstrsStart[0] = params.amountStart;
        bodySubstrsString[0] = params.amountUint.toString();
        bodySubstrsStart[1] = params.tokenNameStart;
        bodySubstrsString[1] = params.tokenNameString;
        bodySubstrsStart[2] = params.recipientStart;
        bodySubstrsString[2] = params.recipientString;
        substrParams.bodySubstrsStart = bodySubstrsStart;
        substrParams.bodySubstrsString = bodySubstrsString;
        return substrParams;
    }
}
