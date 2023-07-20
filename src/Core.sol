// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./utils/Create2.sol";
import "./verifier/IGlobalVerifier.sol";
import "./ViewingKeysMap.sol";
import "./EmailOp.sol";
import "./PendingValues.sol";

contract Core is EmailOp {
    /// `emailAddrCommit` is the commitment of the email address defined as `hash(temporaryRand, emailAddr)`.
    /// It is used to constrain that the same email address is used for different proofs without exposing its value.
    /// Therefore, the `emailAddrCommit` in two different `EmailOperation` are not the same even for the same email address.
    /// An example of the `temporaryRand` is an RSA signature in the email.
    /// The other kinds of the commitment are defined in the same manner.

    mapping(address => mapping(bytes => bool)) public psiPointOfRelayer;

    struct AccountCreationOpeartion {
        bytes32 newViewingKeysRoot;
        bytes32 emailAddrCommit;
        bytes32 viewingKeyCommit;
        bytes32 newPointer;
        bytes32 newIndicator;
        bytes mappingProof;
        bytes creationProof;
    }

    struct AccountInitializationOpeartion {
        bytes32 newInitializerRoot;
        bytes32 emailAddrCommit;
        bytes32 viewingKeyCommit;
        bytes32 newInitializer;
        bytes32 emailNullifier;
        bytes32 pubKeyHash;
        string domainName;
        bytes psiPoint;
        bytes mappingProof;
        bytes initializationProof;
        bytes emailProof;
        bytes psiProof;
    }

    struct RefundOperation {
        address recipientRelayer;
        bytes32 emailAddrCommit;
        bytes32 viewingKeyCommit;
        bool isRecipientInitialized;
        uint randomNonce;
        bytes32 walletSalt;
        bytes mappingProof;
        bytes walletSaltProof;
    }

    constructor(
        address _globalVerifier,
        uint _verifierListUpdateFrequency
    ) EmailOp(_globalVerifier, _verifierListUpdateFrequency) {}

    function processBundle(
        ProcessPendingValueOperation[] memory processPendingValueOps,
        AccountCreationOpeartion[] memory accountCreationOps,
        AccountInitializationOpeartion[] memory accountInitializationOps,
        RefundOperation[] memory refundOps,
        EmailOperation[] memory emailOps
    ) public {
        require(relayers[msg.sender], "relayer not registered");
        /// 1. Process pending values.
        for (uint i = 0; i < processPendingValueOps.length; i++) {
            _processPendingValue(processPendingValueOps[i]);
        }

        IGlobalVerifier globalVerifier = IGlobalVerifier(globalVerifier);
        RelayerConfig memory relayerConfig = relayerConfigs[msg.sender];
        ViewingKeysMap viewingKeysMap = ViewingKeysMap(
            relayerConfig.viewingKeysMap
        );

        /// 2. Create accounts.
        for (uint i = 0; i < accountCreationOps.length; i++) {
            /// The account does not exist now.
            require(
                viewingKeysMap.mapViewingKey(
                    accountCreationOps[i].emailAddrCommit,
                    accountCreationOps[i].viewingKeyCommit,
                    false,
                    false,
                    accountCreationOps[i].mappingProof
                ),
                "account already exists"
            );
            /// The account is created.
            viewingKeysMap.createAccount(
                accountCreationOps[i].newViewingKeysRoot,
                accountCreationOps[i].emailAddrCommit,
                accountCreationOps[i].viewingKeyCommit,
                accountCreationOps[i].newPointer,
                accountCreationOps[i].newIndicator,
                accountCreationOps[i].creationProof
            );
        }

        /// 3. Initialize accounts.
        for (uint i = 0; i < accountInitializationOps.length; i++) {
            /// The account exists but is not initialized.
            require(
                viewingKeysMap.mapViewingKey(
                    accountInitializationOps[i].emailAddrCommit,
                    accountInitializationOps[i].viewingKeyCommit,
                    true,
                    false,
                    accountInitializationOps[i].mappingProof
                ),
                "account is already initialized"
            );
            /// The nullifier of the email for account initialization is not used.
            require(
                emailNullifiers[accountInitializationOps[i].emailNullifier] ==
                    false,
                "email nullifier already used"
            );
            /// The pubkey hash is correct for the domain.
            require(
                pubkeyHashOfDomainName[
                    accountInitializationOps[i].domainName
                ] == accountInitializationOps[i].pubKeyHash,
                "invalid pubkey hash"
            );
            /// The proof of the email for account initialization is valid.
            require(
                globalVerifier.verifyAccountInitializationEmailProof(
                    accountInitializationOps[i].emailAddrCommit,
                    accountInitializationOps[i].emailNullifier,
                    accountInitializationOps[i].pubKeyHash,
                    accountInitializationOps[i].domainName,
                    accountInitializationOps[i].viewingKeyCommit,
                    accountInitializationOps[i].emailProof
                ),
                "invalid email proof"
            );
            /// The proof of the psi point is valid.
            require(
                !psiPointOfRelayer[msg.sender][
                    accountInitializationOps[i].psiPoint
                ],
                "already registered psi point"
            );
            require(
                globalVerifier.verifyPsiProof(
                    accountInitializationOps[i].emailAddrCommit,
                    relayerConfig.relayerHash,
                    accountInitializationOps[i].psiPoint,
                    accountInitializationOps[i].psiProof
                ),
                "invalid psi proof"
            );
            emailNullifiers[accountInitializationOps[i].emailNullifier] = true;
            psiPointOfRelayer[msg.sender][
                accountInitializationOps[i].psiPoint
            ] = true;
            viewingKeysMap.initializeAccount(
                accountInitializationOps[i].newInitializerRoot,
                accountInitializationOps[i].emailAddrCommit,
                accountInitializationOps[i].viewingKeyCommit,
                accountInitializationOps[i].newInitializer,
                accountInitializationOps[i].initializationProof
            );
        }

        /// 4. Refund deferred transfers.
        address[] memory refundRecipients = new address[](refundOps.length);
        bool[] memory refundIsInitialized = new bool[](refundOps.length);
        RelayerConfig memory recipientRelayerConfig;
        ViewingKeysMap recipientViewingKeysMap;
        for (uint i = 0; i < refundOps.length; i++) {
            /// The recipient relayer is registered.
            require(
                relayers[refundOps[i].recipientRelayer],
                "relayer not registered"
            );
            recipientRelayerConfig = relayerConfigs[
                refundOps[i].recipientRelayer
            ];
            recipientViewingKeysMap = ViewingKeysMap(
                recipientRelayerConfig.viewingKeysMap
            );
            /// The recipient account exists.
            require(
                recipientViewingKeysMap.mapViewingKey(
                    refundOps[i].emailAddrCommit,
                    refundOps[i].viewingKeyCommit,
                    true,
                    refundOps[i].isRecipientInitialized,
                    refundOps[i].mappingProof
                ),
                "recipient account not found"
            );
            /// The recipient's wallet salt is valid.
            require(
                globalVerifier.verifyWalletSaltProof(
                    refundOps[i].emailAddrCommit,
                    refundOps[i].randomNonce,
                    refundOps[i].walletSalt,
                    refundOps[i].walletSaltProof
                ),
                "invalid wallet salt proof"
            );
            /// Derive the recipient contract address.
            /// [TODO] Fix the bytecode to compute the recipient contract address.
            address recipient = Create2.computeAddress(
                refundOps[i].walletSalt,
                bytes32(0),
                address(this)
            );
            refundRecipients[i] = recipient;
            refundIsInitialized[i] = refundOps[i].isRecipientInitialized;
        }
        /// Refund deferred transfers.
        _refundDeferredTransfers(refundRecipients, refundIsInitialized);

        /// 5. Execute email operations.
        for (uint i = 0; i < emailOps.length; i++) {
            /// Validate the email operation.
            _validateEmailOp(emailOps[i]);
        }
        for (uint i = 0; i < emailOps.length; i++) {
            /// Execute the email operation.
            uint256 startGas = gasleft();
            _executeEmailOp(emailOps[i]);
            uint256 gasUsed = startGas - gasleft();
            /// [TODO] Gas payment.
        }
    }
}
