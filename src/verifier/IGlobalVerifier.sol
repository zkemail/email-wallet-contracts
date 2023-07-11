// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IGlobalVerifier {
    // function verifyPointerInclusionProof(
    //     bytes32 valueCommit,
    //     bytes32 nullifierCommit,
    //     bytes32 relayerHash,
    //     uint nonce,
    //     bytes32 vkIndicator,
    //     bytes32 senderEmailAddrCommit,
    //     bytes32 recipientEmailAddrCommit,
    //     bytes memory proof
    // ) external view returns (bool);

    function verifyAnonMapInclusionProof(
        bytes32 valuesRoot,
        bytes32 nullifiersRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        bytes memory proof
    ) external view returns (bool);

    function verifyAnonMapInsertProof(
        bytes32 oldValuesRoot,
        bytes32 newValuesRoot,
        bytes32 nullifiersRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        uint nonce,
        bytes32 valueCommit,
        bytes memory proof
    ) external view returns (bool);

    function verifyAnonMapRemoveProof(
        bytes32 oldNullifiersRoot,
        bytes32 newNullifiersRoot,
        bytes32 valuesRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        bytes32 nullifier,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapInclusionProof(
        bytes32 viewingKeysRoot,
        bytes32 nullifiersRoot,
        bytes32 relayerHash,
        bytes32 senderEmailAddrCommit,
        bytes32 recipientEmailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapInsertProof(
        bytes32 oldViewingKeysRoot,
        bytes32 newViewingKeysRoot,
        bytes32 nullifiersRoot,
        bytes32 relayerHash,
        bytes32 senderEmailAddrCommit,
        bytes32 recipientEmailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 pointer,
        bytes32 indicator,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapRemoveProof(
        bytes32 oldNullifiersRoot,
        bytes32 newNullifierRoot,
        bytes32 viewingKeysRoot,
        bytes32 relayerHash,
        bytes32 senderEmailAddrCommit,
        bytes32 recipientEmailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 nullifier,
        bytes memory proof
    ) external view returns (bool);
}
