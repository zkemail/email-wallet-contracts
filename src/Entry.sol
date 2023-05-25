// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier/IVerifierWrapper.sol";
import "./extension/IExtension.sol";
import "./account/IAccount.sol";
import "./utils/Create2.sol";
import "./utils/Constants.sol";

contract Entry is Ownable {
    using Create2 for *;

    bytes32 public saltRandHash;
    mapping(bytes32 => bool) public saltNullifiers;
    mapping(bytes32 => address) public addressOfSalt;
    mapping(address => bytes) public accountBytesOfNonRegisteredUser;
    mapping(address => address) public verifierOfNonRegisteredUser;
    mapping(uint256 => mapping(address => address))
        public extensionOfNonRegisteredUser;
    bytes public defaultAccountBytes;
    address public defaultVerifier;
    mapping(uint256 => address) public defaultExtensionOfId;

    constructor(
        bytes32 _saltRandHash,
        bytes memory _defaultAccountBytes,
        address _defaultVerifier,
        address _defaultWalletExtension,
        address _defaultExtExtension,
        address _defaultTranspoteExtension
    ) {
        saltRandHash = _saltRandHash;
        defaultAccountBytes = _defaultAccountBytes;
        defaultVerifier = _defaultVerifier;
        defaultExtensionOfId[
            Constants.WALLET_EXTENSION_ID
        ] = _defaultWalletExtension;
        defaultExtensionOfId[Constants.EXT_EXTENSION_ID] = _defaultExtExtension;
        defaultExtensionOfId[
            Constants.TRANSPORT_EXTENSION_ID
        ] = _defaultTranspoteExtension;
    }

    function entry(
        bytes32 accountAddrSalt,
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) public onlyOwner {
        // 1. from address check
        address accountAddr = addressOfSalt[accountAddrSalt];
        require(
            accountAddr != address(0),
            "The sender's account is not registered."
        );
        if (!accountAddr.isContractDeployed()) {
            require(
                Create2.deploy(
                    0,
                    accountAddrSalt,
                    accountBytesOfNonRegisteredUser[accountAddr]
                ) == accountAddr,
                "deploy failed 1"
            );
            require(accountAddr.isContractDeployed(), "deploy failed 2");
        }
        IAccount account = IAccount(accountAddr);
        IVerifierWrapper verifier = account.getVerifierWrapper();
        require(
            verifier.getFromAddrSalt(verifierParams) == accountAddrSalt,
            "Invalid accountAddrSalt"
        );

        // 2. saltRandHash check
        require(
            verifier.getSaltRandHash(verifierParams) == saltRandHash,
            "Invalid saltRandHash"
        );

        // 3. subjectAddr check
        bytes32 subjectAddrSalt = verifier.getSubjectAddrSalt(verifierParams);
        address subjectAddr = addressOfSalt[subjectAddrSalt];
        bytes32 saltNullifier = verifier.getSaltNullifier(verifierParams);
        if (subjectAddr == address(0)) {
            require(!saltNullifiers[saltNullifier], "used saltNullifier");
            saltNullifiers[saltNullifier] = true;
            subjectAddr = subjectAddrSalt.computeAddress(
                keccak256(defaultAccountBytes),
                address(this)
            );
            addressOfSalt[subjectAddrSalt] = subjectAddr;
            accountBytesOfNonRegisteredUser[subjectAddr] = defaultAccountBytes;
            verifierOfNonRegisteredUser[subjectAddr] = defaultVerifier;
            extensionOfNonRegisteredUser[Constants.WALLET_EXTENSION_ID][
                subjectAddr
            ] = defaultExtensionOfId[Constants.WALLET_EXTENSION_ID];
            extensionOfNonRegisteredUser[Constants.EXT_EXTENSION_ID][
                subjectAddr
            ] = defaultExtensionOfId[Constants.EXT_EXTENSION_ID];
            extensionOfNonRegisteredUser[Constants.TRANSPORT_EXTENSION_ID][
                subjectAddr
            ] = defaultExtensionOfId[Constants.TRANSPORT_EXTENSION_ID];
        } else {
            require(
                saltNullifiers[saltNullifier],
                "saltNullifier is not registered"
            );
        }

        // require(
        //     account.verifyOp(
        //         verifierParams,
        //         proof,
        //         extensionId,
        //         extensionParams
        //     ),
        //     "invalid operation"
        // );
        // 4. call extension in the account contract
        account.callExtension(
            extensionId,
            subjectAddr,
            verifierParams,
            proof,
            extensionParams
        );
    }

    function setDefaultAccountBytes(
        bytes calldata accountBytes
    ) public onlyOwner {
        defaultAccountBytes = accountBytes;
    }

    function setDefaultVerifier(address verifierAddress) public onlyOwner {
        defaultVerifier = verifierAddress;
    }

    function setDefaultExtensionOfId(
        uint256 extensionId,
        address extensionAddress
    ) public onlyOwner {
        defaultExtensionOfId[extensionId] = extensionAddress;
    }
}
