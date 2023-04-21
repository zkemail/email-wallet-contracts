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

    function process(
        bytes memory param,
        bytes calldata acc,
        bytes calldata proof
    ) external {
        Param memory param = abi.decode(param, (Param));
        require(VerifierWrapper.verifyWrap(param, acc, proof), "invalid proof");
        if (keccak256(bytes(param.substr1String)) == ETH_NAME_HASH) {
            uint amount = param.substr0IntPart *
                1e18 +
                param.substr0DecimalPart;
            require(ethBalanceOfUser[param.fromAddressString] >= amount);
            ethBalanceOfUser[param.fromAddressString] -= amount;
            ethBalanceOfUser[param.toAddressString] += amount;
        } else {
            require(isRegisteredToken[param.substr1String]);
            uint amount = param.substr0IntPart *
                1e18 +
                param.substr0DecimalPart;
            require(
                erc20BalanceOfUser[param.fromAddressString][
                    param.substr1String
                ] >= amount
            );
            erc20BalanceOfUser[param.fromAddressString][
                param.substr1String
            ] -= amount;
            erc20BalanceOfUser[param.toAddressString][
                param.substr1String
            ] += amount;
        }
    }

    function retrieveFromAddress(
        bytes calldata param
    ) external view returns (string memory) {
        Param memory param = abi.decode(param, (Param));
        return param.fromAddressString;
    }

    function retrieveToAddress(
        bytes calldata param
    ) external view returns (string memory) {
        Param memory param = abi.decode(param, (Param));
        return param.toAddressString;
    }

    function retrieveManipulationId(
        bytes calldata param
    ) external view returns (uint) {
        Param memory param = abi.decode(param, (Param));
        return param.manipulationIdUint;
    }

    function retrieveBodyHash(
        bytes calldata param
    ) external view returns (string memory) {
        Param memory param = abi.decode(param, (Param));
        return param.bodyHashString;
    }

    // function processOne(Param memory params) private {
    //     if (keccak256(bytes(params.tokenNameString)) == ETH_NAME_HASH) {
    //         require(
    //             ethBalanceOfUser[params.fromAddressString] >= params.amountUint
    //         );
    //         ethBalanceOfUser[params.fromAddressString] -= params.amountUint;
    //         ethBalanceOfUser[params.toAddressString] += params.amountUint;
    //     } else {
    //         require(isRegisteredToken[params.tokenNameString]);
    //         require(
    //             erc20BalanceOfUser[params.fromAddressString][
    //                 params.tokenNameString
    //             ] >= params.amountUint
    //         );
    //         erc20BalanceOfUser[params.fromAddressString][
    //             params.tokenNameString
    //         ] -= params.amountUint;
    //         erc20BalanceOfUser[params.toAddressString][
    //             params.tokenNameString
    //         ] += params.amountUint;
    //     }
    // }
}
