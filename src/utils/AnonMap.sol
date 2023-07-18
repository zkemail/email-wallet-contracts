// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "../verifier/IGlobalVerifier.sol";

/// Anonoymous mapping contract.
/// This can be thought of as providing a mapping from an email address to bytes.
/// However, the email address is not directly reveled and is guaranteed to be equal to that of the sender or recipient of the email.
/// It stores roots of a standart merkle tree called  and a sparse merkle tree.
/// The standard merkle tree stores a value commitment `valueCommit = hash(viewingKey, hash(value), valueNonce)`.
/// The sparse Merkle tree stores its nullifier defined as `nullifier = hash(viewingKey, valueCommit)`.
contract AnonMap is Ownable {
    address public verifierAddr;
    bytes32 public valuesRoot;
    bytes32 public nullifiersRoot;
    /// `valueNonce` is an incremental nonce stored for each value.
    /// It is used to distinguish two `valueCommit` whose value is the same.
    mapping(bytes32 => uint) public valueNonce;
    mapping(bytes32 => bool) public nullifiers;

    constructor(address _verifierAddr) {
        verifierAddr = _verifierAddr;
    }

    function isStored(
        bytes32 viewingKeyCommit,
        bytes memory value,
        bytes memory proof
    ) external view returns (bool) {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
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
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
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
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
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
