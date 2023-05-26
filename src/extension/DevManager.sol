// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract DevManager {
    mapping(string => address) public devAddressOfName;

    function getAddress(string memory devName) public view returns (address) {
        return devAddressOfName[devName];
    }

    function registerName(string memory devName) public {
        require(devAddressOfName[devName] == address(0), "Already registered");
        devAddressOfName[devName] = msg.sender;
    }
}
