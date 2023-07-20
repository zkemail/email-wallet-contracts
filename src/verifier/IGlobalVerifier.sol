// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IGlobalVerifier {
    function verifyAnonMapValueInclusionProof(
        bytes32 valuesRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        bytes memory proof
    ) external view returns (bool);

    function verifyAnonMapIsNullifiedProof(
        bytes32 nullifiersRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        bytes memory proof
    ) external view returns (bool);

    function verifyAnonMapInsertProof(
        bytes32 oldValuesRoot,
        bytes32 newValuesRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        uint nonce,
        bytes32 valueCommit,
        bytes memory proof
    ) external view returns (bool);

    function verifyAnonMapNullifyProof(
        bytes32 oldNullifiersRoot,
        bytes32 newNullifiersRoot,
        bytes32 viewingKeyCommit,
        bytes32 valueHash,
        bytes32 nullifier,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapInclusionProof(
        bytes32 viewingKeysRoot,
        bytes32 relayerHash,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bool isExist,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapIsInitializedProof(
        bytes32 initializersRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bool isInitialized,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapIsNullifiedProof(
        bytes32 nullifiersRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bool isNullified,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapInsertProof(
        bytes32 oldViewingKeysRoot,
        bytes32 newViewingKeysRoot,
        bytes32 relayerHash,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 pointer,
        bytes32 indicator,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapInitializeProof(
        bytes32 oldInitializersRoot,
        bytes32 newInitializersRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 initializer,
        bytes memory proof
    ) external view returns (bool);

    function verifyViewingKeysMapNullifyProof(
        bytes32 oldNullifiersRoot,
        bytes32 newNullifierRoot,
        bytes32 emailAddrCommit,
        bytes32 viewingKeyCommit,
        bytes32 nullifier,
        bytes memory proof
    ) external view returns (bool);

    function verifyEmailProof(
        bytes32 senderEmailAddrCommit,
        bytes32 recipientEmailAddrCommit,
        bytes32 emailNullifier,
        bytes32 pubKeyHash,
        string memory domainName,
        string memory maskedSubjectStr,
        bool isSubjectAddrNull,
        bytes memory proof
    ) external view returns (bool);

    function verifyAccountInitializationEmailProof(
        bytes32 emailAddrCommit,
        bytes32 emailNullifier,
        bytes32 pubKeyHash,
        string memory domainName,
        bytes32 viewingKeyCommit,
        bytes memory proof
    ) external view returns (bool);

    function verifyWalletSaltProof(
        bytes32 viewingKeyCommit,
        uint randomNonce,
        bytes32 walletSalt,
        bytes memory proof
    ) external view returns (bool);

    function verifyPsiProof(
        bytes32 emailAddrCommit,
        bytes32 relayerHash,
        bytes memory point,
        bytes memory proof
    ) external view returns (bool);
}
