// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./emailVerifier.sol";
import "./rule1Helper.sol";
import "./interfaces/manipulator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Rule1Manipulator is Rule1Helper, IManipulator {
    address payable aggregator;
    string aggregatorToAddress;
    uint numRules;
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

    constructor(
        address _rawVerifier,
        uint _headerMaxBytesLen,
        uint _bodyMaxBytesLen,
        uint _numAggregatedEmails
    )
        Rule1Helper(
            _rawVerifier,
            _headerMaxBytesLen,
            _bodyMaxBytesLen,
            _numAggregatedEmails
        )
    {}

    function verifyBatch(
        bytes calldata paramsBytes,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool) {
        Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
        require(paramsArray.length == numAggregatedEmails);
        SubstrParams[] memory substrParams = new SubstrParams[](
            numAggregatedEmails
        );
        for (uint i = 0; i < numAggregatedEmails; i++) {
            substrParams[i] = convertToSubstrParams(paramsArray[i]);
        }
        return verifyInternal(acc, substrParams, proof);
    }

    function processBatch(bytes calldata paramsBytes) external {
        Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
        for (uint i = 0; i < numAggregatedEmails; i++) {
            processOne(paramsArray[i]);
        }
    }

    function retrieveFromAddresses(
        bytes calldata paramsBytes
    ) external view returns (string[] memory) {
        Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
        require(paramsArray.length == numAggregatedEmails);
        string[] memory values = new string[](numAggregatedEmails);
        for (uint i = 0; i < numAggregatedEmails; i++) {
            values[i] = paramsArray[i].fromAddressString;
        }
        return values;
    }

    function retrieveToAddresses(
        bytes calldata paramsBytes
    ) external view returns (string[] memory) {
        Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
        require(paramsArray.length == numAggregatedEmails);
        string[] memory values = new string[](numAggregatedEmails);
        for (uint i = 0; i < numAggregatedEmails; i++) {
            values[i] = paramsArray[i].toAddressString;
        }
        return values;
    }

    function retrieveManipulationIds(
        bytes calldata paramsBytes
    ) external view returns (uint[] memory) {
        Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
        require(paramsArray.length == numAggregatedEmails);
        uint[] memory values = new uint[](numAggregatedEmails);
        for (uint i = 0; i < numAggregatedEmails; i++) {
            values[i] = paramsArray[i].manipulationIdUint;
        }
        return values;
    }

    function retrieveBodyHashes(
        bytes calldata paramsBytes
    ) external view returns (string[] memory) {
        Params[] memory paramsArray = abi.decode(paramsBytes, (Params[]));
        require(paramsArray.length == numAggregatedEmails);
        string[] memory values = new string[](numAggregatedEmails);
        for (uint i = 0; i < numAggregatedEmails; i++) {
            values[i] = paramsArray[i].bodyHashString;
        }
        return values;
    }

    function processOne(Params memory params) private {
        if (keccak256(bytes(params.tokenNameString)) == ETH_NAME_HASH) {
            require(
                ethBalanceOfUser[params.fromAddressString] >= params.amountUint
            );
            ethBalanceOfUser[params.fromAddressString] -= params.amountUint;
            ethBalanceOfUser[params.toAddressString] += params.amountUint;
        } else {
            require(isRegisteredToken[params.tokenNameString]);
            require(
                erc20BalanceOfUser[params.fromAddressString][
                    params.tokenNameString
                ] >= params.amountUint
            );
            erc20BalanceOfUser[params.fromAddressString][
                params.tokenNameString
            ] -= params.amountUint;
            erc20BalanceOfUser[params.toAddressString][
                params.tokenNameString
            ] += params.amountUint;
        }
    }
}
