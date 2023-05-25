// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../verifier/IVerifierWrapper.sol";
import "../extension/IExtension.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

interface IAccount is Initializable {
    function initialize(
        address _verifier,
        address _walletExtension,
        address _extensionsExtension,
        address _transportExtension
    ) public initializer;

    function getVerifierWrapper() external view returns (IVerifierWrapper);

    function getExtension(uint extensionId) external view returns (IExtension);

    function callExtension(
        uint extensionId,
        address subjectAddr,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external;
}
