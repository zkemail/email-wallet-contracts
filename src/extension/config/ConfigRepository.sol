// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../VersionManager.sol";
import "../DevManager.sol";

contract ConfigRepository {
    DevManager public devManager;
    VersionManager public accountLogicManager;
    VersionManager public verifierManager;
    mapping(address => string) public currentDevOfUser;

    constructor(address _devManager) {
        devManager = DevManager(_devManager);
        accountLogicManager = new VersionManager();
        verifierManager = new VersionManager();
    }

    function getCurrentDev(
        address accountAddr
    ) public view returns (string memory) {
        return currentDevOfUser[accountAddr];
    }

    function setCurrentDev(string memory devName) public {
        require(bytes(devName).length > 0, "devName must not be empty");
        require(
            devManager.getAddress(devName) != address(0),
            "devName is not registered"
        );
        currentDevOfUser[msg.sender] = devName;
    }
}
