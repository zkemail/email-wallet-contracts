// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../VersionManager.sol";
import "../DevManager.sol";

contract ConfigRegistry {
    DevManager public devManager;
    VersionManager public accountLogicManager;
    VersionManager public verifierManager;
    mapping(address => string) public devOfAddress;

    // mapping(address => string) public accountCurrentDevOfUser;
    // mapping(address => string) public verifierCurrentDevOfUser;

    constructor(address _devManager) {
        devManager = DevManager(_devManager);
        accountLogicManager = new VersionManager();
        verifierManager = new VersionManager();
    }

    // function getAccountCurrentDev(
    //     address accountAddr
    // ) public view returns (string memory) {
    //     return accountCurrentDevOfUser[accountAddr];
    // }

    // function getVerifierCurrentDev(
    //     address accountAddr
    // ) public view returns (string memory) {
    //     return verifierCurrentDevOfUser[accountAddr];
    // }

    // function setAccountCurrentDev(string memory devName) public {
    //     require(bytes(devName).length > 0, "devName must not be empty");
    //     require(
    //         devManager.getAddress(devName) != address(0),
    //         "devName is not registered"
    //     );
    //     accountCurrentDevOfUser[msg.sender] = devName;
    // }

    // function setVerifierCurrentDev(string memory devName) public {
    //     require(bytes(devName).length > 0, "devName must not be empty");
    //     require(
    //         devManager.getAddress(devName) != address(0),
    //         "devName is not registered"
    //     );
    //     verifierCurrentDevOfUser[msg.sender] = devName;
    // }

    function getDevOfAddress(
        address contractAddr
    ) public view returns (string memory) {
        return devOfAddress[contractAddr];
    }

    function registerNewAccountLogic(
        string memory devName,
        string memory versionName,
        address contractAddr
    ) public {
        require(
            devManager.getAddress(devName) == msg.sender,
            "Invalid devName"
        );
        accountLogicManager.registerAddress(versionName, contractAddr);
        devOfAddress[contractAddr] = devName;
    }

    function registerNewVerifierLogic(
        string memory devName,
        string memory versionName,
        address contractAddr
    ) public {
        require(
            devManager.getAddress(devName) == msg.sender,
            "Invalid devName"
        );
        verifierManager.registerAddress(versionName, contractAddr);
        devOfAddress[contractAddr] = devName;
    }
}
