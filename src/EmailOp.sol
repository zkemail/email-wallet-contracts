// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";
import "./verifier/ILocalVerifier.sol";
import "./ViewingKeysMap.sol";
import "./Relayers.sol";

contract EmailOp is Relayers {
    address public verifierMap;
    mapping(string => address) public extensionsMap;
    mapping(bytes32 => bool) public emailNullifiers;
    mapping(bytes32 => bytes32) public pubkeyHashOfDomainHash;

    constructor(
        address _globalVerifier,
        uint _verifierListUpdateFrequency
    ) Relayers(_globalVerifier, _verifierListUpdateFrequency) {
        verifierMap = address(new AnonMap(globalVerifier));
    }

    /// Account functions.
    struct EmailOperation {
        address recipientRelayer;
        /// commitments
        bytes32 senderEmailAddrCommit;
        bytes32 recipientEmailAddrCommit;
        bytes32 senderSvkCommit;
        bytes32 recipientSvkCommit;
        bytes cvkCommit;
        /// Viewing key inclusion proof for the sender's svk.
        bytes senderSvkInclusionProof;
        /// Viewing key inclusion proof for the recipient's svk.
        bytes recipientSvkInclusionProof;
        /// Viewing key inclusion proof for the sender's cvk.
        // bytes cvkInclusionProof;
        /// Verifier address inclusion proof.
        address verifier;
        bytes verifierInclusionProof;
        /// Extension address inclusion proof.
        string extensionCommand;
        address extension;
        bytes extensionInclusionProof;
        /// email proof
        bytes32 emailNullifier;
        bytes32 pubKeyHash;
        bytes32 domainHash;
        string maskedSubjectStr;
        bool isSubjectAddrNull;
        bytes emailProof;
    }

    function _validateEmailOp(
        EmailOperation memory emailOp
    ) internal view returns (bool) {
        require(relayers[msg.sender], "relayer not registered");
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
        /// Check verifier and extension addresses.
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
        require(
            emailOp.extension != address(0),
            "extension must not be zero address"
        );
        address extensionMapAddr = extensionsMap[emailOp.extensionCommand];
        require(extensionMapAddr != address(0), "extension does not exist");
        AnonMap extensionMap = AnonMap(extensionMapAddr);
        require(
            extensionMap.isStored(
                emailOp.senderSvkCommit,
                abi.encodePacked(emailOp.extension),
                emailOp.extensionInclusionProof
            ),
            "invalid extension inclusion proof"
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
    }

    /// Account functions.
    // function validateEmailOpBeforeCharge(
    //     EmailOperation memory emailOp
    // ) private view returns (bool) {
    //     require(
    //         emailNullifiers[emailOp.emailNullifier] == false,
    //         "email nullifier already used"
    //     );
    //     require(
    //         emailOp.verifier != address(0),
    //         "verifier must not be zero address"
    //     );
    //     require(relayers[msg.sender], "relayer not registered");
    //     RelayerConfig relayerConfig = relayerConfigs[msg.sender];
    //     IGlobalVerifier globalVerifier = IGlobalVerifier(globalVerifier);
    //     AnonMap pointersMap = AnonMultiset(
    //         relayerConfig.viewingKeyPointersMap
    //     );
    //     require(
    //         globalVerifier.verifyPointerInclusionProof(
    //             pointersMap.valuesCommitment(),
    //             pointersMap.nullifiersCommitment(),
    //             relayerConfig.relayerHash,
    //             relayerConfig.nonce,
    //             emailOp.senderSvkIndicator,
    //             emailOp.senderEmailAddrCommit,
    //             bytes32(0),
    //             emailOp.senderSvkPointersProof
    //         ),
    //         "invalid pointer inclusion proof"
    //     );
    //     if (emailOp.senderCvkIndicator != bytes32(0)) {
    //         require(
    //             globalVerifier.verifyPointerInclusionProof(
    //                 pointersMap.valuesCommitment(),
    //                 pointersMap.nullifiersCommitment(),
    //                 relayerConfig.relayerHash,
    //                 relayerConfig.nonce,
    //                 emailOp.senderCvkIndicator,
    //                 emailOp.senderEmailAddrCommit,
    //                 emailOp.senderCvkPointersProof
    //             ),
    //             "invalid pointer inclusion proof"
    //         );
    //     }
    //     RelayerConfig recipientRelayerConfig = relayerConfigs[
    //         emailOp.recipientRelayer
    //     ];
    //     if (emailOp.recipientSvkIndicator != bytes32(0)) {
    //         require(
    //             emailOp.recipientRelayer != address(0),
    //             "recipient relayer must not be zero address"
    //         );
    //         require(
    //             globalVerifier.verifyPointerInclusionProof(
    //                 pointersMap.valuesCommitment(),
    //                 pointersMap.nullifiersCommitment(),
    //                 recipientRelayerConfig.relayerHash,
    //                 recipientRelayerConfig.nonce,
    //                 emailOp.recipientSvkIndicator,
    //                 emailOp.recipientEmailAddrCommit,
    //                 emailOp.recipientSvkPointersProof
    //             ),
    //             "invalid pointer inclusion proof"
    //         );
    //         require(
    //             emailOp.recipientCvkIndicator != bytes32(0),
    //             "recipient cvk indicator must not be zero"
    //         );
    //         require(
    //             globalVerifier.verifyPointerInclusionProof(
    //                 pointersMap.valuesCommitment(),
    //                 pointersMap.nullifiersCommitment(),
    //                 recipientRelayerConfig.relayerHash,
    //                 recipientRelayerConfig.nonce,
    //                 emailOp.recipientCvkIndicator,
    //                 emailOp.recipientEmailAddrCommit,
    //                 emailOp.recipientCvkPointersProof
    //             ),
    //             "invalid pointer inclusion proof"
    //         );
    //     }
    // }

    // function validateEmailOpAfterCharge(
    //     EmailOperation memory emailOp
    // ) private view returns (bool) {
    //     return true;
    // }

    /// Account data. We separate them from an account contract to prevent a malicious account logic from modifying them.
    // struct AccountData {
    //     bytes pubKey;
    //     bytes32 salt;
    //     address relayer;
    //     bytes32 relayerHash;
    //     address initAccountLogic;
    //     address initVerifier;
    //     address[] initExtensions;
    //     bytes32 initDepositEmailNullifier;
    // }

    // /// Extension Ids used to initialize an account contract.
    // function initExtensionIds() external pure returns (uint256[] calldata);

    // /// Given a salt, return the corresponding account contract address.
    // /// [Note] The salt does not derive the corresponding address with CREATE2 after the account is transported.
    // function getAccountOfSalt(bytes32 salt) external view returns (address);

    // /// Given an email nullifier, return the corresponding account contract address.
    // /// [TODO] Each account contract also stores emailNullifiers. How can we sync them efficiently?
    // function getAccountOfEmailNullifier(
    //     bytes32 emailNullifier
    // ) external view returns (address);

    // /// Given an account contract address, return the corresponding `AccountData`.
    // function getAccountData(
    //     address account
    // ) external view returns (AccountData memory);

    // /// Return true if the given address is a registered account contract and false otherwise.
    // function isRegisteredAccount(address account) external view returns (bool);

    // /// A bundler calls this function to deploy an account contract.
    // function createAccount(address account) external;

    // /// An account contract calls this function to register an account contract of the subject email address if it is not deployed yet.
    // /// It derives a new contract address from `salt` and inherits init contracts from those of msg.sender.
    // function registerNewAccount(bytes memory pubKey, bytes32 salt) external;

    // /// After calling the approve function of the ERC20 contract, a user who wants to deposit tokens from existing wallets calls this function.
    // /// If the user's account contract is not deployed, it registers that account.
    // /// The relayer later submits a proof of the user's deposit email, which depoly the user's account contract.
    // /// This function requires `initDepositEmailNullifier`, which must be the same as that of that deposit email.
    // /// `initDepositEmailNullifier` must not be zero.
    // function deposit(
    //     address accountAddr,
    //     bytes memory pubKey,
    //     address relayer,
    //     uint256 initAccountLogicIdx,
    //     address initVerifierIdx,
    //     address[] memory initExtensionIdxes,
    //     bytes32 initDepositEmailNullifier
    // ) external;

    // /// Any relayer can call this function to transport the account to the caller relayer.
    // /// It must verify a proof of the sender and transport circuit.
    // function transportAccount(
    //     address accountAddr,
    //     bytes memory params,
    //     bytes memory proof
    // ) external;

    // /// Relayer functions.

    // /// Relayer configuration.
    // struct RelayerConfigData {
    //     address[] supportedAccountLogicList;
    //     address[] supportedVerifierList;
    //     address[][] supportedInitExtensionList;
    //     bytes32 relayerHash;
    //     string emailAddr;
    //     uint256 verifierIdxOfPsi;
    // }

    // /// Given a relayer address, return true if it is a registered relayer and false otherwise.
    // function isRegisteredRelayer(address relayer) external view returns (bool);

    // /// Given a relayer address, return the corresponding `RelayerConfigData`.
    // function getConfigOfRelayer(
    //     address relayer
    // ) external view returns (RelayerConfigData memory);

    // /// Register a new relayer with the initial `RelayerConfigData`.
    // function registerRelayer(RelayerConfigData memory configData) external;

    // /// A relayer calls this function to add a new account logic contract to the relayer's `supportedAccountLogicList`.
    // function addSupportedAccountLogic(address newAccountLogic) external;

    // /// A relayer calls this function to add a new verifier contract to the relayer's `supportedVerifierList`.
    // function addSupportedVerifier(address newVerifier) external;

    // /// A relayer calls this function to add a new extension contract to the relayer's `supportedInitExtensionList`.
    // function addSupportedInitExtension(
    //     uint256 extensionId,
    //     address newExtension
    // ) external;

    // /// A relayer calls this function to change the relayer's `verifierIdxOfPsi`.
    // function changeVerifierIdxOfPsi(uint256 idx) external;

    // /// Private-set intersection (PSI) functions.
    // event QueryPsiPoint(
    //     address indexed relayer,
    //     bytes indexed psiPoint,
    //     bytes32 indexed addrCommit
    // );

    // /// Given a relayer address and bytes of the PSI point, return true if that point is registered and false otherwise.
    // function isRegisteredPsiPoint(
    //     address relayer,
    //     bytes calldata psiPoint
    // ) external view returns (bool);

    // /// Only a relayer can call this function to register a new PSI point of the registered account.
    // function registerPsiPoint(bytes calldata psiPoint) external;

    // /// Only a relayer can call this function to query a PSI point.
    // /// [NOTE] This function must take some fees from the relayer (msg.sender) to prevent a DoS scanning attack.
    // function queryPsiPoint(bytes calldata psiPoint) external;

    // function getAccountLogicOfNonRegisteredUser(
    //     address accountAddr
    // ) external view returns (address);

    // function isExportedAccount(
    //     address accountAddr
    // ) external view returns (bool);

    // function changeDefaultAccountLogic(address accountLogic) external;

    // function changeDefaultVerifier(address verifierAddress) external;

    // function changeDefaultExtensionOfId(
    //     uint256 extensionId,
    //     address extensionAddress
    // ) external;

    // function simulateVerification(
    //     bytes32 accountAddrSalt,
    //     uint extensionId,
    //     bytes memory verifierParams,
    //     bytes memory proof,
    //     bytes memory extensionParams
    // ) external view;

    // function entry(
    //     bytes32 accountAddrSalt,
    //     uint extensionId,
    //     bytes memory verifierParams,
    //     bytes memory proof,
    //     bytes memory extensionParams
    // ) external;

    // function depositFirst(
    //     bytes32 accountAddrSalt,
    //     bytes memory verifierParams,
    //     bytes memory proof,
    //     bytes memory extensionParams
    // ) external;

    // function exportAccount(
    //     bytes32 accountAddrSalt,
    //     bytes memory verifierParams,
    //     bytes memory proof,
    //     bytes memory extensionParams
    // ) external;

    // function importAccount(
    //     bytes32 accountAddrSalt,
    //     bytes memory verifierParams,
    //     bytes memory proof,
    //     bytes memory extensionParams,
    //     address oldEntryAddr
    // ) external;
}
