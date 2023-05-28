// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../VersionManager.sol";
import "../DevManager.sol";

contract ExtensionRegistry {
    DevManager public devManager;
    mapping(string => uint256) public extIdOfName;
    mapping(uint256 => address) public managerOfId;
    mapping(address => mapping(uint256 => string)) public currentDevOfUserAndId;

    constructor(address _devManager) {
        devManager = DevManager(_devManager);
    }

    function getCurrentDev(
        address accountAddr,
        uint256 extensionId
    ) public view returns (string memory) {
        return currentDevOfUserAndId[accountAddr][extensionId];
    }

    function setCurrentDev(uint256 extensionId, string memory devName) public {
        require(bytes(devName).length > 0, "devName must not be empty");
        require(
            devManager.getAddress(devName) != address(0),
            "devName is not registered"
        );
        currentDevOfUserAndId[msg.sender][extensionId] = devName;
    }

    function getExtensionId(
        string memory extensionName
    ) public view returns (uint256) {
        return extIdOfName[extensionName];
    }

    function getExtensionManager(
        uint256 extensionId
    ) public view returns (address) {
        return managerOfId[extensionId];
    }

    function registerExtension(
        string memory extensionName,
        string memory versionName,
        address extensionAddr
    ) public {
        require(extIdOfName[extensionName] == 0, "Already registered name");
        uint256 extensionId = uint256(
            keccak256(abi.encode(extensionName, versionName, msg.sender))
        );
        extIdOfName[extensionName] = extensionId;
        VersionManager manager = new VersionManager();
        manager.registerAddress(versionName, extensionAddr);
        managerOfId[extensionId] = address(manager);
    }

    function upgradeExtension(
        string memory extensionName,
        string memory versionName,
        address extensionAddr
    ) public {
        uint256 extensionId = getExtensionId(extensionName);
        address managerAddr = getExtensionManager(extensionId);
        require(managerAddr != address(0), "Not registered extension");
        VersionManager(managerAddr).registerAddress(versionName, extensionAddr);
    }
}
