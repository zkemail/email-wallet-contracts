// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier/IGlobalVerifier.sol";

/// A mapping from an email address to a viewing key.
/// It stores the roots of three sparse merkle trees:
/// 1. viewing keys tree: it stores an indicator of the viewing defined as `indicator=hash(fixedIndicatorTag, viewingKey, emailAddr)` for each pointer defined as `pointer=hash(relayerRand, emailAddr)`. The key is the pointer and the value is the indicator.
/// 2. initializers tree: it stores an existence of the initializer defined as `initializer=hash(fixedInitializerTag, viewingKey, emailAddr)`.
/// 3. nullifiers tree: it stores an existence of the nullifier defined as `nullifier=hash(fixedNullifierTag, viewingKey, emailAddr)`.
contract ViewingKeysMap is Ownable {
    address public verifierAddr;
    bytes32 public relayerHash;
    bytes32 public viewingKeysRoot;
    bytes32 public initializerRoot;
    bytes32 public nullifiersRoot;
    mapping(bytes32 => bytes32) public indicatorOfPointer;
    mapping(bytes32 => bool) public indicators;
    mapping(bytes32 => bool) public initializers;
    mapping(bytes32 => bool) public nullifiers;

    struct ViewingKeyMappingProof {
        bytes inclusionProof;
        bytes isInitializedProof;
        bytes isNullifiedProof;
    }

    constructor(address _verifierAddr, bytes32 _relayerHash) {
        verifierAddr = _verifierAddr;
        relayerHash = _relayerHash;
    }

    /// When mapping an email address to a viewing key, the relayer need to prove that:
    /// 1. If `isExist=true`, the viewing key exists in the viewing keys tree at the pointer corresponding to the email address. Otherwise, it does not exist.
    /// 2. If `isInitialized=true`, the initializer corresponding to the viewing key and the email address exists in the initializers tree. Otherwise, it does not exist.
    /// 3. the nullifier corresponding to the viewing key and the email address does not exist in the nullifiers tree.
    function mapViewingKey(
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bool isExist,
        bool isInitialized,
        bytes memory proof
    ) external view returns (bool) {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        ViewingKeyMappingProof memory mappingProof = abi.decode(
            proof,
            (ViewingKeyMappingProof)
        );
        bool included = verifier.verifyViewingKeysMapInclusionProof(
            viewingKeysRoot,
            relayerHash,
            emailAddrCommit,
            viewingKeyCommit,
            isExist,
            mappingProof.inclusionProof
        );
        bool initialized = verifier.verifyViewingKeysMapIsInitializedProof(
            initializerRoot,
            emailAddrCommit,
            viewingKeyCommit,
            isInitialized,
            mappingProof.isInitializedProof
        );
        bool nullified = verifier.verifyViewingKeysMapIsNullifiedProof(
            nullifiersRoot,
            emailAddrCommit,
            viewingKeyCommit,
            false,
            mappingProof.isNullifiedProof
        );
        return included && initialized && nullified;
    }

    /// To create a new account, after calling `mapViewingKey`, the relayer need to prove that the viewing key is correctly inserted to the current viewing keys tree.
    function createAccount(
        bytes32 newViewingKeysRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 newPointer,
        bytes32 newIndicator,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        require(
            verifier.verifyViewingKeysMapInsertProof(
                viewingKeysRoot,
                newViewingKeysRoot,
                relayerHash,
                emailAddrCommit,
                viewingKeyCommit,
                newPointer,
                newIndicator,
                proof
            ),
            "Invalid proof"
        );
        indicatorOfPointer[newPointer] = newIndicator;
        indicators[newIndicator] = true;
    }

    /// To initialize a new account, after calling `mapViewingKey`, the relayer need to prove that the initializer is correctly inserted to the current initializers tree.
    function initializeAccount(
        bytes32 newInitializerRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 newInitializer,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        require(
            verifier.verifyViewingKeysMapInitializeProof(
                initializerRoot,
                newInitializerRoot,
                emailAddrCommit,
                viewingKeyCommit,
                newInitializer,
                proof
            ),
            "Invalid proof"
        );
        initializers[newInitializer] = true;
    }

    /// To remove an account, the relayer need to prove that the nullifier is correctly inserted to the current nullifiers tree.
    function removeAccount(
        bytes32 newNullifiersRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 newNullifier,
        bytes memory proof
    ) external onlyOwner {
        IGlobalVerifier verifier = IGlobalVerifier(verifierAddr);
        require(
            verifier.verifyViewingKeysMapNullifyProof(
                nullifiersRoot,
                newNullifiersRoot,
                emailAddrCommit,
                viewingKeyCommit,
                newNullifier,
                proof
            ),
            "Invalid proof"
        );
        nullifiers[newNullifier] = true;
    }
}
