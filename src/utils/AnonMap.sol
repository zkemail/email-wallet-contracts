// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "../verifier/IGlobalVerifier.sol";

contract AnonMap is Ownable {
    address public verifier;
    bytes32 public valuesRoot;
    bytes32 public nullifiersRoot;
    mapping(bytes32 => uint) public valueNonce;
    mapping(bytes32 => bool) public nullifiers;

    constructor(address _verifier) {
        verifier = _verifier;
    }

    function isStored(
        bytes32 viewingKeyCommit,
        bytes memory value,
        bytes memory proof
    ) external view returns (bool) {
        IGlobalVerifier verifier = IGlobalVerifier(verifier);
        bytes32 valueHash = keccak256(value);
        return
            verifier.verifyAnonMapInclusionProof(
                valuesRoot,
                nullifiersRoot,
                viewingKeyCommit,
                valueHash,
                proof
            );
    }

    function insert(
        bytes32 newValuesRoot,
        bytes32 viewingKeyCommit,
        bytes32 newValueCommit,
        bytes memory newValue,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifier);
        bytes32 valueHash = keccak256(newValue);
        require(
            verifier.verifyAnonMapInsertProof(
                valuesRoot,
                newValuesRoot,
                nullifiersRoot,
                viewingKeyCommit,
                valueHash,
                valueNonce[valueHash],
                newValueCommit,
                proof
            ),
            "Invalid proof"
        );
        valuesRoot = newValuesRoot;
        valueNonce[valueHash] += 1;
    }

    function remove(
        bytes32 newNullifierRoot,
        bytes32 viewingKeyCommit,
        bytes32 nullifier,
        bytes memory value,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifier);
        bytes32 valueHash = keccak256(value);
        require(
            verifier.verifyAnonMapRemoveProof(
                nullifiersRoot,
                newNullifierRoot,
                valuesRoot,
                viewingKeyCommit,
                valueHash,
                nullifier,
                proof
            ),
            "Invalid proof"
        );
        nullifiersRoot = newNullifierRoot;
        nullifiers[nullifier] = true;
    }
}
