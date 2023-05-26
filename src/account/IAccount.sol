// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../verifier/IVerifierWrapper.sol";
import "../extension/IExtension.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

interface IAccount {
    function initialize(
        address _verifier,
        uint256[] calldata _initExtensionIds,
        address[] calldata _initExtensionAddrs
    ) external;

    function getEntryAddr() external view returns (address);

    function getVerifierWrapper() external view returns (IVerifierWrapper);

    function getExtension(uint extensionId) external view returns (IExtension);

    function callExtension(
        uint extensionId,
        address subjectAddr,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external;

    function callOtherExtension(
        uint extensionId,
        address subjectAddr,
        bytes memory extensionParams
    ) external;

    function updateExtension(uint extensionId, address extensionAddr) external;

    function changeVerifier(address newVerifier) external;

    function changeEntry(address newEntry) external;
}
