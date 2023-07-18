// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";
// import "./verifier/ILocalVerifier.sol";
import "./ViewingKeysMap.sol";
import "./Relayers.sol";
import "./Wallets.sol";
import "./IExtension.sol";
import "./PendingValues.sol";

contract EmailOp is Relayers, Wallets, PendingValues {
    /// Anon mapping of the extension address for each command name.
    mapping(string => address) public extensionAddrOfCommandMap;
    /// Used email nullifiers.
    mapping(bytes32 => bool) public emailNullifiers;
    /// Pubkey hash of the domain hash.
    mapping(bytes32 => bytes32) public pubkeyHashOfDomainHash;
    /// Anon mapping that each extension uses.
    mapping(string => address) public extensionAnonMapOfCommand;

    constructor(
        address _globalVerifier,
        uint _verifierListUpdateFrequency
    ) Relayers(_globalVerifier, _verifierListUpdateFrequency) {}

    struct EmailOperation {
        address recipientRelayer;
        /// commitments
        bytes32 senderEmailAddrCommit;
        bytes32 recipientEmailAddrCommit;
        bytes32 senderViewingKeyCommit;
        bytes32 recipientViewingKeyCommit;
        /// viewing key inclusion proof for the sender's viewing key.
        bytes senderViewingKeyMappingProof;
        /// viewing key inclusion proof for the recipient's viewing key.
        bytes recipientViewingKeyMappingProof;
        bool isRecipientInitialized;
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
        bytes walletSaltProofs;
        uint transferAmount;
        string tokenName;
        uint deferBlockNumber;
        /// extension
        bytes extensionParamsAndProof;
    }

    struct WalletSaltProof {
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
        /// Check viewing keys.
        IGlobalVerifier globalVerifier = IGlobalVerifier(globalVerifier);
        RelayerConfig memory senderRelayerConfig = relayerConfigs[msg.sender];
        ViewingKeysMap senderViewingKeysMap = ViewingKeysMap(
            senderRelayerConfig.viewingKeysMap
        );
        /// Verify a mapping from the sender's email address to the sender's viewing key.
        /// The sender's account must exist and be initialized.
        require(
            senderViewingKeysMap.mapViewingKey(
                emailOp.senderEmailAddrCommit,
                emailOp.senderViewingKeyCommit,
                true,
                true,
                emailOp.senderViewingKeyMappingProof
            ),
            "invalid sender's viewing key."
        );
        if (!emailOp.isSubjectAddrNull) {
            require(
                emailOp.recipientRelayer != address(0),
                "recipientRelayer must not be zero address"
            );
            require(
                relayers[emailOp.recipientRelayer],
                "recipient relayer not registered"
            );
            RelayerConfig memory recipientRelayerConfig = relayerConfigs[
                emailOp.recipientRelayer
            ];
            ViewingKeysMap recipientViewingKeysMap = ViewingKeysMap(
                recipientRelayerConfig.viewingKeysMap
            );
            /// Verify a mapping from the recipient's email address to the recipient's viewing key.
            /// The recipient's account must exist but can be uninitialized.
            require(
                recipientViewingKeysMap.mapViewingKey(
                    emailOp.recipientEmailAddrCommit,
                    emailOp.recipientViewingKeyCommit,
                    true,
                    emailOp.isRecipientInitialized,
                    emailOp.recipientViewingKeyMappingProof
                ),
                "invalid sender's viewing key."
            );
        } else {
            require(
                emailOp.senderEmailAddrCommit ==
                    emailOp.recipientEmailAddrCommit,
                "senderEmailAddrCommit must be equal to recipientEmailAddrCommit when the recipient is not specified in the subject"
            );
            require(
                emailOp.senderViewingKeyCommit ==
                    emailOp.recipientViewingKeyCommit,
                "senderViewingKeyCommit must be equal to recipientViewingKeyCommit when the recipient is not specified in the subject"
            );
            require(
                emailOp.isRecipientInitialized,
                "recipient must be initialized as sender==recipient when the recipient is not specified in the subject"
            );
        }

        /// Check email proof.
        require(
            emailNullifiers[emailOp.emailNullifier] == false,
            "email nullifier already used"
        );
        require(
            pubkeyHashOfDomainHash[emailOp.domainHash] == emailOp.pubKeyHash,
            "invalid pubkey hash"
        );
        require(
            globalVerifier.verifyEmailProof(
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
        require(
            emailOp.walletSaltProofs.length != 0,
            "wallet salt proofs must not be empty"
        );
        (
            WalletSaltProof[] memory senderWalletSaltProofs,
            WalletSaltProof memory recipientWalletSaltProof
        ) = abi.decode(
                emailOp.walletSaltProofs,
                (WalletSaltProof[], WalletSaltProof)
            );
        for (uint i = 0; i < senderWalletSaltProofs.length; i++) {
            /// Verify the sender's wallet salt is correctly derived from the sender's viewing key.
            require(
                globalVerifier.verifyWalletSaltProof(
                    emailOp.senderViewingKeyCommit,
                    senderWalletSaltProofs[i].randomNonce,
                    senderWalletSaltProofs[i].walletSalt,
                    senderWalletSaltProofs[i].proof
                )
            );
        }
        /// Verify the recipient's wallet salt is correctly derived from the recipient's viewing key.
        require(
            globalVerifier.verifyWalletSaltProof(
                emailOp.recipientViewingKeyCommit,
                recipientWalletSaltProof.randomNonce,
                recipientWalletSaltProof.walletSalt,
                recipientWalletSaltProof.proof
            )
        );
        require(
            emailOp.deferBlockNumber != 0,
            "defer block number must not be zero"
        );
        /// If the recipient is initialized, deferring the transfer is not allowed.
        require(
            emailOp.isRecipientInitialized &&
                (emailOp.deferBlockNumber == type(uint256).max),
            "defer block number must be max uint256 if the recipient is initialized"
        );
        /// [TODO] Check the token name.
        /// [TODO] Check the balance sum >= transfer amount.
        /// [TODO] Check that deferBlockNumber is specified in the subject.

        if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.WALLET_COMMAND))
        ) {
            /// Check subject string.
            string memory subjectExpected = string.concat(
                Constants.SUBJECT_PREFIX,
                Constants.WALLET_COMMAND,
                ": "
                // [TODO] Concat "(tansfer amount) (token name) to".
            );
            require(
                keccak256(bytes(emailOp.maskedSubjectStr)) ==
                    keccak256(bytes(subjectExpected)),
                "invalid subject string"
            );
        } else if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.EXT_MANAGER_COMMAND))
        ) {
            // [TODO] Check the subject.
        } else if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.TRANSPORT_COMMAND))
        ) {
            // [TODO] Check the subject.
        } else {
            /// Check extension params and proof.
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
            /// Verify that the extension address is correctly retrieved from `extensionAddrMap` for the sender's viewing key.
            require(
                extensionAddrMap.isStored(
                    emailOp.senderViewingKeyCommit,
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
                    extensionParamsAndProof.extensionParams,
                    emailOp.isRecipientInitialized
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
            /// The extension requests a value in the anon map for the sender's viewing key.
            if (extValidationParams.getSenderAnonMap) {
                require(
                    extensionParamsAndProof.senderAnonMapValue.length != 0,
                    "sender anon map value must not be empty"
                );
                require(
                    anonMap.isStored(
                        emailOp.senderViewingKeyCommit,
                        extensionParamsAndProof.senderAnonMapValue,
                        extensionParamsAndProof.senderAnonMapInclusionProof
                    ),
                    "invalid sender anon map inclusion proof"
                );
            }
            /// The extension requests a value in the anon map for the recipient's viewing key.
            if (extValidationParams.getRecipientAnonMap) {
                require(
                    extensionParamsAndProof.recipientAnonMapValue.length != 0,
                    "recipient anon map value must not be empty"
                );
                require(
                    anonMap.isStored(
                        emailOp.recipientViewingKeyCommit,
                        extensionParamsAndProof.recipientAnonMapValue,
                        extensionParamsAndProof.recipientAnonMapInclusionProof
                    ),
                    "invalid recipient anon map inclusion proof"
                );
            }
            /// The requested transfer is the same as (emailOp.transferAmount, emailOp.tokenName).
            require(
                extValidationParams.transferRequest.amount ==
                    emailOp.transferAmount,
                "invalid transfer amount"
            );
            /// [TODO] Convert `emailOp.tokenName` to the corresponding ERC20 address and verify that it is equal to the `extValidationParams.transferRequest.token`.
        }
    }

    function _executeEmailOp(EmailOperation memory emailOp) internal {
        emailNullifiers[emailOp.emailNullifier] = true;
        if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.WALLET_COMMAND))
        ) {
            /// token transfer
            (
                WalletSaltProof[] memory senderWalletSaltProofs,
                WalletSaltProof memory recipientWalletSaltProof
            ) = abi.decode(
                    emailOp.walletSaltProofs,
                    (WalletSaltProof[], WalletSaltProof)
                );
            /// [TODO] Convert token name to token address.
            /// [TODO] Construct Wallets.TransferRequest and call _processTransferRequest.
        } else if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.EXT_MANAGER_COMMAND))
        ) {
            /// [TODO] Modfiy `extensionAddrOfCommandMap` for the installed extension and create its `extensionAnonMap`.
        } else if (
            keccak256(bytes(emailOp.command)) ==
            keccak256(bytes(Constants.EXT_MANAGER_COMMAND))
        ) {
            /// [TODO] Add nullifier to the user's current relayer's nullifiers tree and a pointer, an indicator, and an initializer to a new relayer's viewing keys tree and initializer tree.
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
                    extensionParamsAndProof.extensionParams,
                    emailOp.isRecipientInitialized
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
                emailOp.isRecipientInitialized,
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
                    emailOp.senderViewingKeyCommit,
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
                    emailOp.recipientViewingKeyCommit,
                    extensionParamsAndProof.recipientAnonMapValue,
                    extResult.recipientAnonMapNewValue
                );
            }
        }
    }
}
