// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../verifier/IVerifierWrapper.sol";

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

    function commandName() external pure returns (string memory);

    function queryDecomposedRegexes()
        external
        pure
        returns (DecomposedRegex[] memory);

    function executeDecomposedRegexes()
        external
        pure
        returns (DecomposedRegex[] memory);

    function query(
        address accountAddr,
        bytes memory queryData
    ) external view returns (string memory);

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
