// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ILocalVerifier {
    function verifyEmailProof(
        bytes32 senderEmailAddrCommit,
        bytes32 recipientEmailAddrCommit,
        bytes32 emailNullifier,
        bytes32 pubKeyHash,
        bytes32 domainHash,
        string memory maskedSubjectStr,
        bool isSubjectAddrNull,
        bytes memory proof
    ) external view returns (bool);

    // struct PointersPublicInput {
    //     bytes32 relayerHash;
    //     bytes32 viewingKeyCommit;
    //     bytes others;
    // }
    // struct SenderPublicInput {
    //     bytes32 fromRelayerHash;
    //     bytes32[] fromSalts;
    //     uint[] addrIndexes;
    //     bytes32 emailNullifier;
    //     bytes pubKey;
    //     string maskedSubjectStr;
    //     bool isSubjectAddrNull;
    //     bytes32 fromAddrCommit;
    //     bytes32 subjectAddrCommit;
    //     bytes others;
    // }
    // struct AnonAddrMapInclusionPublicInput {
    //     bytes32 relayerHash;
    //     bytes32 addrCommit;
    //     bytes32[] addrNullifiers;
    //     bytes32[] addrIndexes;
    //     bytes32[] addrSalts;
    //     bytes others;
    // }
    // struct RecipientPublicInput {
    //     bytes32 subjectRelayerHash;
    //     bytes32 subjectSalt;
    //     bytes32 subjectAddrCommit;
    //     bytes others;
    // }
    // struct TransportPublicInput {
    //     bytes32 emailNullifier;
    //     bytes32 fromAddrCommit;
    //     bytes others;
    // }
    // struct PsiPublicInput {
    //     bytes32 relayerHash;
    //     bytes32 addrCommit;
    //     bytes psiPoint;
    //     bytes others;
    // }
    // function verifySenderProof(
    //     SenderPublicInput memory publicInput,
    //     bytes calldata proof
    // ) external view returns (bool);
    // function verifyRecipientProof(
    //     RecipientPublicInput memory publicInput,
    //     bytes calldata proof
    // ) external view returns (bool);
    // function verifyTransportProof(
    //     TransportPublicInput memory publicInput,
    //     bytes calldata proof
    // ) external view returns (bool);
    // function verifyPsiProof(
    //     PsiPublicInput memory publicInput,
    //     bytes calldata proof
    // ) external view returns (bool);
}
