// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../verifier/IVerifierWrapper.sol";

interface IExtension {
    event Executed(
        uint indexed extensionId,
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
    ) external returns (string memory);

    function execute(
        address subjectAddr,
        bytes memory extensionParams
    ) external;
}
