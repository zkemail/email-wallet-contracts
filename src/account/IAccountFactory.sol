// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../verifier/IVerifierWrapper.sol";
import "../extension/IExtension.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

interface IAccountFactory {
    function isOwnedAccount(address _address) external view returns (bool);

    function computeAccountAddress(
        bytes32 salt,
        address logic
    ) external view returns (address);

    function deployAccount(
        bytes32 salt,
        address logic
    ) external returns (address);

    function upgradeLogic(address newLogic) external;

    function changeAdmin(address accountAddr, address newAdmin) external;
}
