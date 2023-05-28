// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../verifier/IVerifierWrapper.sol";
import "../extension/IExtension.sol";
import "./IAccountFactory.sol";
import "./AccountProxy.sol";
import "./IAccount.sol";
import "../utils/Create2.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract AccountFactory is IAccountFactory, ProxyAdmin {
    using Create2 for *;
    mapping(address => bool) public ownedAccounts;

    function isOwnedAccount(address _address) external view returns (bool) {
        return ownedAccounts[_address];
    }

    function computeAccountAddress(
        bytes32 salt,
        address logic
    ) public view returns (address) {
        return
            salt.computeAddress(
                keccak256(_getAccountBytecode(logic)),
                address(this)
            );
    }

    function deployAccount(
        bytes32 salt,
        address logic
    ) external onlyOwner returns (address) {
        address addrExpected = computeAccountAddress(salt, logic);
        require(!ownedAccounts[addrExpected], "already deployed");
        address addr = Create2.deploy(0, salt, _getAccountBytecode(logic));
        require(addr == addrExpected, "account deploy failed");
        ownedAccounts[addr] = true;
        return addr;
    }

    function upgradeLogic(address newLogic) external {
        require(ownedAccounts[msg.sender], "Not owned account");
        upgrade(ITransparentUpgradeableProxy(msg.sender), newLogic);
    }

    function changeAdmin(
        address accountAddr,
        address newAdmin
    ) external onlyOwner {
        require(ownedAccounts[accountAddr], "Not owned account");
        changeProxyAdmin(ITransparentUpgradeableProxy(accountAddr), newAdmin);
        ownedAccounts[accountAddr] = false;
    }

    function _getAccountBytecode(
        address logic
    ) private view returns (bytes memory) {
        return
            abi.encodePacked(
                type(AccountProxy).creationCode,
                abi.encode(logic, address(this), bytes(""))
            );
    }
}
