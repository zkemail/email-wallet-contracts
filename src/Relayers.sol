// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";
import "./ViewingKeysMap.sol";

contract Relayers {
    /// Global parameters.
    address public globalVerifier;
    uint public verifierListUpdateFrequency;

    constructor(address _globalVerifier, uint _verifierListUpdateFrequency) {
        globalVerifier = _globalVerifier;
        verifierListUpdateFrequency = _verifierListUpdateFrequency;
    }

    /// Relayer functions.
    struct RelayerConfig {
        bytes32 relayerHash;
        uint nonce;
        address[] supportedVerifierList;
        uint nextVerifierListUpdatableTime;
        address viewingKeysMap;
    }
    mapping(address => bool) public relayers;
    mapping(address => RelayerConfig) public relayerConfigs;

    function registerRelayer(
        bytes32 _relayerHash,
        address[] memory _supportedVerifierList
    ) public {
        require(!relayers[msg.sender], "relayer already registered");
        require(_relayerHash != bytes32(0), "relayer hash must not be zero");
        RelayerConfig memory relayerConfig;
        relayerConfig.relayerHash = _relayerHash;
        relayerConfig.nonce = 0;
        relayerConfig.nextVerifierListUpdatableTime =
            block.timestamp +
            verifierListUpdateFrequency;
        relayerConfig.viewingKeysMap = address(
            new ViewingKeysMap(globalVerifier, _relayerHash)
        );
        relayerConfigs[msg.sender] = relayerConfig;
        for (uint i = 0; i < _supportedVerifierList.length; i++) {
            require(
                _supportedVerifierList[i] != address(0),
                "verifier must not be zero address"
            );
            relayerConfigs[msg.sender].supportedVerifierList.push(
                _supportedVerifierList[i]
            );
        }
    }

    function addVerifierList(address newVerifier) public {
        require(relayers[msg.sender], "relayer not registered");
        require(
            block.timestamp >=
                relayerConfigs[msg.sender].nextVerifierListUpdatableTime,
            "cannot update verifier list yet"
        );
        relayerConfigs[msg.sender].supportedVerifierList.push(newVerifier);
        relayerConfigs[msg.sender].nextVerifierListUpdatableTime =
            block.timestamp +
            verifierListUpdateFrequency;
    }
}
