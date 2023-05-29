// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract VersionManager {
    mapping(address => mapping(string => address))
        public contractOfVersionAndDev;
    mapping(address => string) public versionOfContract;

    function getContract(
        address dev,
        string memory versionName
    ) public view returns (address) {
        return contractOfVersionAndDev[dev][versionName];
    }

    function getVersion(
        address contractAddr
    ) public view returns (string memory) {
        return versionOfContract[contractAddr];
    }

    function registerAddress(
        string memory versionName,
        address contractAddr
    ) public {
        require(
            contractOfVersionAndDev[msg.sender][versionName] == address(0),
            "Already registered"
        );
        require(
            contractAddr != address(0),
            "contractAddr must not be zero address."
        );
        contractOfVersionAndDev[msg.sender][versionName] = contractAddr;
        versionOfContract[contractAddr] = versionName;
    }
}
