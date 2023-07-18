// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./Wallets.sol";

interface IExtension {
    event Executed(
        string indexed command,
        string indexed msg,
        address indexed account
    );

    struct DecomposedRegex {
        bool isPublic;
        string typeName;
        string regexDefOfString;
    }

    struct ExtValidationParams {
        string expectedSubject;
        Wallets.TransferRequest transferRequest;
        bool getSenderAnonMap;
        bool getRecipientAnonMap;
    }

    struct ExtResult {
        Wallets.TransferRequest transferRequest;
        bytes senderAnonMapNewValue;
        bytes recipientAnonMapNewValue;
    }

    // struct CallContext {
    //     uint256 extensionId;
    //     bytes32 fromEmailNullifier;
    //     address subjectAddr;
    // }

    // struct ForwardContext {
    //     bool isForwarded;
    //     uint256 forwarderId;
    // }

    function commandName() external pure returns (string memory);

    function queryDecomposedRegexes()
        external
        pure
        returns (DecomposedRegex[] memory);

    function executeDecomposedRegexes()
        external
        pure
        returns (DecomposedRegex[] memory);

    // function permissionRequests() external pure returns (uint256[] memory);

    // function query(
    //     address accountAddr,
    //     bytes memory queryData
    // ) external view returns (string memory);

    function buildValidationParams(
        bytes memory extensionParams,
        bool isRecipientInitialized
    ) external pure returns (ExtValidationParams memory);

    function execute(
        bytes memory extensionParams,
        bool isRecipientInitialized,
        Wallets.TransferRequest memory transferRequest,
        bytes memory senderAnonMapValue,
        bytes memory recipientAnonMapValue
    ) external returns (ExtResult memory);

    // function execute(
    //     CallContext memory callCtx,
    //     ForwardContext memory forwardCtx,
    //     bytes memory extensionParams
    // ) external;

    // function install(
    //     address subjectAddr,
    //     bytes memory extensionParams
    // ) external;

    // function unInstall(
    //     address subjectAddr,
    //     bytes memory extensionParams
    // ) external;
}
