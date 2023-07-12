// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";
import "./verifier/ILocalVerifier.sol";
import "./ViewingKeysMap.sol";
import "./Relayers.sol";
import "./Wallets.sol";
import "./IExtension.sol";
import "./PendingValues.sol";

contract EmailOp is Relayers, Wallets, PendingValues {
    address public verifierMap;
    mapping(string => address) public extensionAddrOfCommandMap;
    mapping(bytes32 => bool) public emailNullifiers;
    mapping(bytes32 => bytes32) public pubkeyHashOfDomainHash;
    mapping(string => address) public extensionAnonMapOfCommand;

    constructor(
        address _globalVerifier,
        uint _verifierListUpdateFrequency
    ) Relayers(_globalVerifier, _verifierListUpdateFrequency) {
        verifierMap = address(new AnonMap(globalVerifier));
    }

    struct EmailOperation {
        address recipientRelayer;
        /// commitments
        bytes32 senderEmailAddrCommit;
        bytes32 recipientEmailAddrCommit;
        bytes32 senderSvkCommit;
        bytes32 recipientSvkCommit;
        // bytes cvkCommit;
        /// viewing key inclusion proof for the sender's svk.
        bytes senderSvkInclusionProof;
        /// viewing key inclusion proof for the recipient's svk.
        bytes recipientSvkInclusionProof;
        /// viewing key inclusion proof for the sender's cvk.
        // bytes cvkInclusionProof;
        /// verifier address inclusion proof.
        address verifier;
        bytes verifierInclusionProof;
        /// command name.
        string command;
        /// email proof
        bytes32 emailNullifier;
        bytes32 pubKeyHash;
        bytes32 domainHash;
        string maskedSubjectStr;
        bool isSubjectAddrNull;
        bytes emailProof;
        /// wallet
        bytes walletProofs;
        uint transferAmount;
        string tokenName;
        /// extension
        bytes extensionParamsAndProof;
    }

    struct SenderWalletProof {
        bytes32 cvkCommit;
        bytes32 oldSenderEmailAddrCommit;
        bytes cvkInclusionProof;
        uint randomNonce;
        bytes32 walletSalt;
        bytes proof;
    }

    struct RecipientWalletProof {
        bytes32 cvkCommit;
        bytes cvkInclusionProof;
        uint randomNonce;
        bytes32 walletSalt;
        bytes proof;
    }

    struct ExtensionParamsAndProof {
        address extension;
        bytes extensionAddrInclusionProof;
        bytes extensionParams;
        bytes senderAnonMapValue;
        bytes senderAnonMapInclusionProof;
        bytes recipientAnonMapValue;
        bytes recipientAnonMapInclusionProof;
    }

    function _validateEmailOp(EmailOperation memory emailOp) internal view {
        /// Check self viewing keys.
        require(
            emailOp.verifier != address(0),
            "verifier must not be zero address"
        );
        IGlobalVerifier globalVerifier = IGlobalVerifier(globalVerifier);
        RelayerConfig memory relayerConfig = relayerConfigs[msg.sender];
        AnonMap viewingKeysMap = AnonMap(relayerConfig.viewingKeysMap);
        require(
            globalVerifier.verifyViewingKeysMapInclusionProof(
                viewingKeysMap.valuesRoot(),
                viewingKeysMap.nullifiersRoot(),
                relayerConfig.relayerHash,
                emailOp.senderEmailAddrCommit,
                emailOp.senderEmailAddrCommit,
                emailOp.senderSvkCommit,
                emailOp.senderSvkInclusionProof
            ),
            "invalid sender's svk inclusion proof."
        );
        if (emailOp.recipientRelayer != address(0)) {
            require(
                relayers[emailOp.recipientRelayer],
                "recipient relayer not registered"
            );
            RelayerConfig memory recipientRelayerConfig = relayerConfigs[
                emailOp.recipientRelayer
            ];
            require(
                globalVerifier.verifyViewingKeysMapInclusionProof(
                    viewingKeysMap.valuesRoot(),
                    viewingKeysMap.nullifiersRoot(),
                    recipientRelayerConfig.relayerHash,
                    emailOp.recipientEmailAddrCommit,
                    emailOp.recipientEmailAddrCommit,
                    emailOp.recipientSvkCommit,
                    emailOp.recipientSvkInclusionProof
                ),
                "invalid recipient's svk inclusion proof."
            );
        }
        require(
            globalVerifier.verifyViewingKeysMapInclusionProof(
                viewingKeysMap.valuesRoot(),
                viewingKeysMap.nullifiersRoot(),
                relayerConfig.relayerHash,
                emailOp.recipientEmailAddrCommit,
                emailOp.recipientEmailAddrCommit,
                emailOp.recipientSvkCommit,
                emailOp.recipientSvkInclusionProof
            ),
            "invalid recipient's svk inclusion proof."
        );

        /// Check verifier addresses.
        AnonMap verifierMap = AnonMap(verifierMap);
        require(
            emailOp.verifier != address(0),
            "verifier must not be zero address"
        );
        require(
            verifierMap.isStored(
                emailOp.senderSvkCommit,
                abi.encodePacked(emailOp.verifier),
                emailOp.verifierInclusionProof
            ),
            "invalid verifier inclusion proof"
        );

        /// Check email proof.
        require(
            emailNullifiers[emailOp.emailNullifier] == false,
            "email nullifier already used"
        );
        require(
            pubkeyHashOfDomainHash[emailOp.domainHash] == emailOp.pubKeyHash,
            "invalid pubkey hash"
        );
        ILocalVerifier localVerifier = ILocalVerifier(emailOp.verifier);
        require(
            localVerifier.verifyEmailProof(
                emailOp.senderEmailAddrCommit,
                emailOp.recipientEmailAddrCommit,
                emailOp.emailNullifier,
                emailOp.pubKeyHash,
                emailOp.domainHash,
                emailOp.maskedSubjectStr,
                emailOp.isSubjectAddrNull,
                emailOp.emailProof
            ),
            "invalid email proof"
        );

        /// Check wallet proofs.
        if (emailOp.walletProofs.length != 0) {
            (
                SenderWalletProof[] memory senderWalletProofs,
                RecipientWalletProof memory recipientWalletProof
            ) = abi.decode(
                    emailOp.walletProofs,
                    (SenderWalletProof[], RecipientWalletProof)
                );
            for (uint i = 0; i < senderWalletProofs.length; i++) {
                require(
                    localVerifier.verifyWalletProof(
                        senderWalletProofs[i].oldSenderEmailAddrCommit,
                        emailOp.recipientEmailAddrCommit,
                        senderWalletProofs[i].cvkCommit,
                        senderWalletProofs[i].randomNonce,
                        senderWalletProofs[i].walletSalt,
                        senderWalletProofs[i].proof
                    )
                );
            }
            require(
                localVerifier.verifyWalletProof(
                    emailOp.senderEmailAddrCommit,
                    emailOp.recipientEmailAddrCommit,
                    recipientWalletProof.cvkCommit,
                    recipientWalletProof.randomNonce,
                    recipientWalletProof.walletSalt,
                    recipientWalletProof.proof
                )
            );
            /// [TODO] Check the token name.
            /// [TODO] Check the balance sum >= transfer amount.
        }

        /// Check extension params and proof.
        if (
            keccak256(bytes(emailOp.command)) !=
            keccak256(bytes(Constants.WALLET_COMMAND))
        ) {
            ExtensionParamsAndProof memory extensionParamsAndProof = abi.decode(
                emailOp.extensionParamsAndProof,
                (ExtensionParamsAndProof)
            );
            address extensionAddrMapAddr = extensionAddrOfCommandMap[
                emailOp.command
            ];
            require(
                extensionAddrMapAddr != address(0),
                "extension does not exist"
            );
            AnonMap extensionAddrMap = AnonMap(extensionAddrMapAddr);
            require(
                extensionAddrMap.isStored(
                    emailOp.senderSvkCommit,
                    abi.encodePacked(extensionParamsAndProof.extension),
                    extensionParamsAndProof.extensionAddrInclusionProof
                ),
                "invalid extension inclusion proof"
            );
            require(
                extensionParamsAndProof.extension != address(0),
                "extension must not be zero address"
            );
            IExtension extension = IExtension(
                extensionParamsAndProof.extension
            );
            IExtension.ExtValidationParams
                memory extValidationParams = extension.buildValidationParams(
                    extensionParamsAndProof.extensionParams
                );
            /// Check subject string.
            string memory subjectExpected = string.concat(
                Constants.SUBJECT_PREFIX,
                extension.commandName(),
                ": ",
                extValidationParams.expectedSubject
            );
            require(
                keccak256(bytes(emailOp.maskedSubjectStr)) ==
                    keccak256(bytes(subjectExpected)),
                "invalid subject string"
            );
            /// Check sender's and recipient's values in the anon map.
            address anonMapAddr = extensionAnonMapOfCommand[emailOp.command];
            require(anonMapAddr != address(0), "anon map does not exist");
            AnonMap anonMap = AnonMap(anonMapAddr);
            if (extValidationParams.getSenderAnonMap) {
                require(
                    extensionParamsAndProof.senderAnonMapValue.length != 0,
                    "sender anon map value must not be empty"
                );
                require(
                    anonMap.isStored(
                        emailOp.senderSvkCommit,
                        extensionParamsAndProof.senderAnonMapValue,
                        extensionParamsAndProof.senderAnonMapInclusionProof
                    ),
                    "invalid sender anon map inclusion proof"
                );
            }
            if (extValidationParams.getRecipientAnonMap) {
                require(
                    extensionParamsAndProof.recipientAnonMapValue.length != 0,
                    "recipient anon map value must not be empty"
                );
                require(
                    anonMap.isStored(
                        emailOp.recipientSvkCommit,
                        extensionParamsAndProof.recipientAnonMapValue,
                        extensionParamsAndProof.recipientAnonMapInclusionProof
                    ),
                    "invalid recipient anon map inclusion proof"
                );
            }
        }
    }

    function _executeEmailOp(EmailOperation memory emailOp) internal {
        if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.WALLET_COMMAND))
        ) {
            /// token transfer
            (
                SenderWalletProof[] memory senderWalletProofs,
                RecipientWalletProof memory recipientWalletProof
            ) = abi.decode(
                    emailOp.walletProofs,
                    (SenderWalletProof[], RecipientWalletProof)
                );
            /// [TODO] Convert token name to token address.
            /// [TODO] Construct Wallets.TransferRequest and call _processTransferRequest.
        } else {
            /// call extension
            ExtensionParamsAndProof memory extensionParamsAndProof = abi.decode(
                emailOp.extensionParamsAndProof,
                (ExtensionParamsAndProof)
            );
            IExtension extension = IExtension(
                extensionParamsAndProof.extension
            );
            IExtension.ExtValidationParams
                memory extValidationParams = extension.buildValidationParams(
                    extensionParamsAndProof.extensionParams
                );
            if (extValidationParams.transferRequest.amount > 0) {
                /// [TODO] Convert token name to token address.
                /// [TODO] Construct Wallets.TransferRequest and call _processTransferRequest (the recipient is `extensionParamsAndProof.extension`).
            }
            bytes memory senderAnonMapValue;
            bytes memory recipientAnonMapValue;
            if (extValidationParams.getSenderAnonMap) {
                senderAnonMapValue = extensionParamsAndProof.senderAnonMapValue;
            }
            if (extValidationParams.getRecipientAnonMap) {
                recipientAnonMapValue = extensionParamsAndProof
                    .recipientAnonMapValue;
            }
            IExtension.ExtResult memory extResult = extension.execute(
                extensionParamsAndProof.extensionParams,
                extValidationParams.transferRequest,
                senderAnonMapValue,
                recipientAnonMapValue
            );
            if (extResult.transferRequest.amount > 0) {
                /// [TODO] Convert token name to token address.
                /// [TODO] Construct Wallets.TransferRequest and call _processTransferRequest (the recipient is the recipient's wallet.).
            }
            if (extResult.senderAnonMapNewValue.length > 0) {
                require(extensionParamsAndProof.senderAnonMapValue.length > 0);
                _addPendingValue(
                    extensionAnonMapOfCommand[emailOp.command],
                    emailOp.senderSvkCommit,
                    extensionParamsAndProof.senderAnonMapValue,
                    extResult.senderAnonMapNewValue
                );
            }
            if (extResult.recipientAnonMapNewValue.length > 0) {
                require(
                    extensionParamsAndProof.recipientAnonMapValue.length > 0
                );
                _addPendingValue(
                    extensionAnonMapOfCommand[emailOp.command],
                    emailOp.recipientSvkCommit,
                    extensionParamsAndProof.recipientAnonMapValue,
                    extResult.recipientAnonMapNewValue
                );
            }
        }
    }
}
