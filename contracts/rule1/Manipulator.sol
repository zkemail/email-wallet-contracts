// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Manipulator is IManipulator, VerifierWrapper {
    address payable aggregator;
    string aggregatorToAddress;
    uint numTokens;
    uint fixedFee;
    mapping(string => uint) ethBalanceOfUser;
    mapping(string => address payable) ethAddressOfUser;
    mapping(string => mapping(string => uint)) erc20BalanceOfUser;
    mapping(string => bool) isUsedEmailHash;
    mapping(uint => IManipulator) manipulatorOfRuleId;
    mapping(string => ERC20) erc20OfTokenName;
    mapping(string => bool) isRegisteredToken;

    string constant ETH_NAME = "ETH";
    bytes32 constant ETH_NAME_HASH = keccak256("ETH");

    constructor(address _verifier) VerifierWrapper(_verifier) {}

    // function verifyBatch(
    //     bytes calldata paramsBytes,
    //     bytes calldata acc,
    //     bytes calldata proof
    // ) external view returns (bool) {
    //     Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
    //     require(paramsArray.length == numAggregatedEmails);
    //     SubstrParams[] memory substrParams = new SubstrParams[](
    //         numAggregatedEmails
    //     );
    //     for (uint i = 0; i < numAggregatedEmails; i++) {
    //         substrParams[i] = convertToSubstrParams(paramsArray[i]);
    //     }
    //     return verifyInternal(acc, substrParams, proof);
    // }

    // function processBatch(bytes calldata paramsBytes) external {
    //     Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
    //     for (uint i = 0; i < numAggregatedEmails; i++) {
    //         processOne(paramsArray[i]);
    //     }
    // }

    function verifyWrap(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool) {
        Param memory param = abi.decode(param, (Param));
        return _verifyWrap(param, acc, proof);
    }

    function process(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external {
        Param memory param = abi.decode(param, (Param));
        if (keccak256(bytes(param.substr1String)) == ETH_NAME_HASH) {
            uint amount = param.substr0IntPart *
                1e18 +
                param.substr0DecimalPart *
                1e17;
            require(ethBalanceOfUser[param.fromAddressString] >= amount);
            ethBalanceOfUser[param.fromAddressString] -= amount;
            ethBalanceOfUser[param.substr2String] += amount;
        } else {
            require(isRegisteredToken[param.substr1String]);
            uint amount = param.substr0IntPart *
                1e18 +
                param.substr0DecimalPart *
                1e17;
            require(
                erc20BalanceOfUser[param.fromAddressString][
                    param.substr1String
                ] >= amount
            );
            erc20BalanceOfUser[param.fromAddressString][
                param.substr1String
            ] -= amount;
            erc20BalanceOfUser[param.substr2String][
                param.substr1String
            ] += amount;
        }
    }

    function retrieveData(
        bytes calldata param
    ) external view returns (RetrievedData memory) {
        Param memory param = abi.decode(param, (Param));
        RetrievedData memory data;
        data.fromAddress = param.fromAddressString;
        data.toAddress = param.toAddressString;
        data.manipulationId = param.manipulationIdUint;
        data.bodyHash = param.bodyHashString;
        return data;
    }
}
