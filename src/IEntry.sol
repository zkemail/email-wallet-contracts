// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier/IVerifierWrapper.sol";
import "./extension/IExtension.sol";
import "./account/IAccount.sol";
import "./account/IAccountDeployer.sol";
import "./utils/Create2.sol";
import "./utils/Constants.sol";

interface IEntry {
    function getAddressOfSalt(bytes32 salt) external view returns (address);

    function getAccountDeployer() external view returns (IAccountDeployer);

    function getAccountLogicOfNonRegisteredUser(
        address accountAddr
    ) external view returns (address);

    function isExportedAccountSalt(
        bytes32 accountSalt
    ) external view returns (bool);

    function changeDefaultAccountLogic(address accountLogic) external;

    function changeDefaultVerifier(address verifierAddress) external;

    function changeDefaultExtensionOfId(
        uint256 extensionId,
        address extensionAddress
    ) external;

    function entry(
        bytes32 accountAddrSalt,
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external;

    function depositFirst(
        bytes32 accountAddrSalt,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external;

    function exportAccount(
        bytes32 accountAddrSalt,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external;
}
