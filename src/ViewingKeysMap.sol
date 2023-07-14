// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier/IGlobalVerifier.sol";

contract ViewingKeysMap is Ownable {
    address public verifierAddr;
    bytes32 public viewingKeysRoot;
    bytes32 public nullifiersRoot;
    mapping(bytes32 => bytes32) public indicatorOfPointer;
    mapping(bytes32 => bool) public indicators;
    mapping(bytes32 => bool) public nullifiers;

    constructor(address _verifierAddr) {
        verifierAddr = _verifierAddr;
    }

    function isMapped(
        bytes32 relayerHash,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes memory proof
    ) external view returns (bool) {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        return
            verifier.verifyViewingKeysMapInclusionProof(
                viewingKeysRoot,
                nullifiersRoot,
                relayerHash,
                emailAddrCommit,
                viewingKeyCommit,
                proof
            );
    }

    function insert(
        bytes32 newViewingKeysRoot,
        bytes32 relayerHash,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 newPointer,
        bytes32 indicator,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        require(
            verifier.verifyViewingKeysMapInsertProof(
                viewingKeysRoot,
                newViewingKeysRoot,
                nullifiersRoot,
                relayerHash,
                emailAddrCommit,
                viewingKeyCommit,
                newPointer,
                indicator,
                proof
            ),
            "Invalid proof"
        );
        indicatorOfPointer[newPointer] = indicator;
        indicators[indicator] = true;
    }

    function remove(
        bytes32 newNullifiersRoot,
        bytes32 relayerHash,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 nullifier,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        require(
            verifier.verifyViewingKeysMapRemoveProof(
                nullifiersRoot,
                newNullifiersRoot,
                viewingKeysRoot,
                relayerHash,
                emailAddrCommit,
                viewingKeyCommit,
                nullifier,
                proof
            ),
            "Invalid proof"
        );
        nullifiers[nullifier] = true;
    }
}
