// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../verifier/IVerifierWrapper.sol";

interface IExtension {
    event Executed(
        string indexed command,
        string indexed msg,
        address indexed account
    );

    // enum CallType {
    //     Call,
    //     DelegateCall
    // }

    // function getCallType() external pure returns (CallType);

    function commandName() external pure returns (string memory);

    function buildSubject(
        bytes memory extensionParams
    ) external pure returns (string memory);

    function execute(
        address subjectAddr,
        bytes memory extensionParams
    ) external;

    // function install(
    //     address subjectAddr,
    //     bytes memory extensionParams
    // ) external;

    // function unInstall(
    //     address subjectAddr,
    //     bytes memory extensionParams
    // ) external;
}
