// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier/IVerifierWrapper.sol";
import "./extension/IExtension.sol";
import "./account/IAccount.sol";
import "./account/IAccountDeployer.sol";
import "./utils/Create2.sol";
import "./utils/Constants.sol";
import "./IEntry.sol";

contract Entry is IEntry, Ownable {
    using Create2 for *;

    bytes32 public saltRandHash;
    mapping(bytes32 => bool) public saltNullifiers;
    mapping(bytes32 => address) public addressOfSalt;
    mapping(address => address) public accountLogicOfNonRegisteredUser;
    mapping(address => address) public verifierOfNonRegisteredUser;
    mapping(uint256 => mapping(address => address))
        public extensionOfNonRegisteredUser;
    mapping(bytes32 => bool) public exportedAccountSalts;
    address public defaultAccountLogic;
    address public defaultVerifier;
    mapping(uint256 => address) public defaultExtensionOfId;
    IAccountDeployer public accountDeployer;
    bytes32 public pubKeyCommit;

    constructor(
        bytes32 _saltRandHash,
        address _defaultAccountLogic,
        address _defaultVerifier,
        address _defaultWalletExtension,
        address _defaultConfigExtension,
        address _defaultExtExtension,
        address _defaultTranspoteExtension,
        bytes memory _accountDeployerCode,
        bytes32 _pubKeyCommit
    ) {
        saltRandHash = _saltRandHash;
        defaultAccountLogic = _defaultAccountLogic;
        defaultVerifier = _defaultVerifier;
        defaultExtensionOfId[
            Constants.WALLET_EXTENSION_ID
        ] = _defaultWalletExtension;
        defaultExtensionOfId[
            Constants.CONFIG_EXTENSION_ID
        ] = _defaultConfigExtension;
        defaultExtensionOfId[Constants.EXT_EXTENSION_ID] = _defaultExtExtension;
        defaultExtensionOfId[
            Constants.TRANSPORT_EXTENSION_ID
        ] = _defaultTranspoteExtension;
        address accountDeployerAddr = Create2.deploy(
            0,
            bytes32(bytes20(address(this))),
            abi.encodePacked(_accountDeployerCode)
        );
        require(
            accountDeployerAddr != address(0),
            "accountDeployer deploy failed"
        );
        accountDeployer = IAccountDeployer(accountDeployerAddr);
        pubKeyCommit = _pubKeyCommit;
    }

    function getAddressOfSalt(bytes32 salt) public view returns (address) {
        return addressOfSalt[salt];
    }

    function getAccountDeployer() public view returns (IAccountDeployer) {
        return accountDeployer;
    }

    function getAccountLogicOfNonRegisteredUser(
        address accountAddr
    ) external view returns (address) {
        return accountLogicOfNonRegisteredUser[accountAddr];
    }

    function isExportedAccountSalt(
        bytes32 accountSalt
    ) external view returns (bool) {
        return exportedAccountSalts[accountSalt];
    }

    function changeDefaultAccountLogic(address accountLogic) public onlyOwner {
        require(
            accountLogic != address(0),
            "New accountLogic must not be zero."
        );
        defaultAccountLogic = accountLogic;
    }

    function changeDefaultVerifier(address verifierAddress) public onlyOwner {
        require(
            verifierAddress != address(0),
            "New verifierAddress must not be zero."
        );
        defaultVerifier = verifierAddress;
    }

    function changeDefaultExtensionOfId(
        uint256 extensionId,
        address extensionAddress
    ) public onlyOwner {
        require(
            extensionAddress != address(0),
            "New extensionAddress must not be zero."
        );
        defaultExtensionOfId[extensionId] = extensionAddress;
    }

    // function upgradeAccountLogic(address newLogic) public {
    //     require(newLogic != address(0), "newLogic must not be zero.");
    //     accountDeployer.upgradeLogic(msg.sender, newLogic);
    // }

    // function changeEntryOfAccount(
    //     address accountAddr,
    //     address newEntryAddr
    // ) public {
    //     require(accountAddr != address(0), "accountAddr must not be zero.");
    //     require(newEntryAddr != address(0), "newEntryAddr must not be zero.");
    //     IAccount account = IAccount(accountAddr);
    //     IExtension transportExt = account.getExtension(
    //         Constants.TRANSPORT_EXTENSION_ID
    //     );
    //     require(msg.sender == address(transportExt), "Invalid msg sender");
    //     account.changeEntry(newEntryAddr);
    //     IEntry newEntry = IEntry(newEntryAddr);
    //     accountDeployer.changeAdmin(
    //         accountAddr,
    //         address(newEntry.getAccountDeployer())
    //     );
    // }

    function entry(
        bytes32 accountAddrSalt,
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) public onlyOwner {
        _entry(
            accountAddrSalt,
            extensionId,
            verifierParams,
            proof,
            extensionParams,
            true
        );
    }

    function depositFirst(
        bytes32 accountAddrSalt,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) public onlyOwner {
        require(
            addressOfSalt[accountAddrSalt] == address(0),
            "Not first deposit"
        );
        IVerifierWrapper verifier = IVerifierWrapper(defaultVerifier);
        _getAccountAddrWithInit(
            accountAddrSalt,
            verifier.getFromSaltNullifier(verifierParams)
        );
        _entry(
            accountAddrSalt,
            Constants.WALLET_EXTENSION_ID,
            verifierParams,
            proof,
            extensionParams,
            true
        );
    }

    function exportAccount(
        bytes32 accountAddrSalt,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) public {
        require(!exportedAccountSalts[accountAddrSalt], "already exported");
        _entry(
            accountAddrSalt,
            Constants.TRANSPORT_EXTENSION_ID,
            verifierParams,
            proof,
            extensionParams,
            false
        );
        exportedAccountSalts[accountAddrSalt] = true;
    }

    function importAccount(
        bytes32 accountAddrSalt,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams,
        address oldEntryAddr
    ) public onlyOwner {
        require(oldEntryAddr != address(0), "oldEntryAddr must not be zero");
        IEntry oldEntry = IEntry(oldEntryAddr);
        oldEntry.exportAccount(
            accountAddrSalt,
            verifierParams,
            proof,
            extensionParams
        );
        require(
            oldEntry.isExportedAccountSalt(accountAddrSalt),
            "accountAddrSalt is not exported"
        );
        address accountAddr = oldEntry.getAddressOfSalt(accountAddrSalt);
        require(
            accountAddr != address(0),
            "The account does not exist in the oldEntry."
        );
        IAccount account = IAccount(accountAddr);
        IVerifierWrapper verifier = account.getVerifierWrapper();
        saltNullifiers[verifier.getFromSaltNullifier(verifierParams)] = true;
        addressOfSalt[accountAddrSalt] = accountAddr;
        accountLogicOfNonRegisteredUser[accountAddr] = oldEntry
            .getAccountLogicOfNonRegisteredUser(accountAddr);

        _entry(
            accountAddrSalt,
            Constants.TRANSPORT_EXTENSION_ID,
            verifierParams,
            proof,
            extensionParams,
            true
        );
    }

    function _entry(
        bytes32 accountAddrSalt,
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams,
        bool isSaltNullifierCheck
    ) private {
        // 1. accountAddr (fromAddr) check
        address accountAddr = addressOfSalt[accountAddrSalt];
        require(
            accountAddr != address(0),
            "The sender's account is not registered."
        );
        if (!accountAddr.isContractDeployed()) {
            accountDeployer.deployAccount(
                accountAddrSalt,
                accountLogicOfNonRegisteredUser[accountAddr]
            );
            uint256[] memory initExtensionIds = new uint256[](4);
            address[] memory initExtensionAddrs = new address[](4);
            initExtensionIds[0] = Constants.WALLET_EXTENSION_ID;
            initExtensionAddrs[0] = extensionOfNonRegisteredUser[
                Constants.WALLET_EXTENSION_ID
            ][accountAddr];
            initExtensionIds[1] = Constants.CONFIG_EXTENSION_ID;
            initExtensionAddrs[1] = extensionOfNonRegisteredUser[
                Constants.CONFIG_EXTENSION_ID
            ][accountAddr];
            initExtensionIds[2] = Constants.EXT_EXTENSION_ID;
            initExtensionAddrs[2] = extensionOfNonRegisteredUser[
                Constants.EXT_EXTENSION_ID
            ][accountAddr];
            initExtensionIds[3] = Constants.TRANSPORT_EXTENSION_ID;
            initExtensionAddrs[3] = extensionOfNonRegisteredUser[
                Constants.TRANSPORT_EXTENSION_ID
            ][accountAddr];
            IAccount(accountAddr).initialize(
                verifierOfNonRegisteredUser[accountAddr],
                initExtensionIds,
                initExtensionAddrs
            );
        }
        IAccount account = IAccount(accountAddr);
        IVerifierWrapper verifier = account.getVerifierWrapper();
        require(
            verifier.getFromSalt(verifierParams) == accountAddrSalt,
            "Invalid fromSalt"
        );
        require(
            !isSaltNullifierCheck ||
                saltNullifiers[verifier.getFromSaltNullifier(verifierParams)],
            "Invalid fromSaltNullifier"
        );

        // 2. saltRandHash check
        if (isSaltNullifierCheck) {
            require(
                verifier.getSaltRandHash(verifierParams) == saltRandHash,
                "Invalid saltRandHash"
            );
        }

        // 3. subjectAddr check
        bytes32 subjectSalt = verifier.getSubjectSalt(verifierParams);
        require(
            isSaltNullifierCheck || subjectSalt == bytes32(0),
            "The subjectSalt must be 0 when isSaltNullifierCheck is false"
        );
        address subjectAddr = address(0);
        if (subjectSalt != bytes32(0)) {
            subjectAddr = _getAccountAddrWithInit(
                subjectSalt,
                verifier.getSubjectSaltNullifier(verifierParams)
            );
        }

        // 4. ccSalt == subjectSalt check
        require(
            verifier.getCcSalt(verifierParams) == subjectSalt,
            "The subject email address must be included in the cc field."
        );

        // 5. pubKeyCommit check
        require(
            verifier.getPubKeyCommit(verifierParams) == pubKeyCommit,
            "Invalid pubKeyCommit"
        );

        // 6. call extension in the account contract
        account.callExtension(
            extensionId,
            subjectAddr,
            verifierParams,
            proof,
            extensionParams
        );
    }

    function _getAccountAddrWithInit(
        bytes32 salt,
        bytes32 saltNullifier
    ) private returns (address) {
        address addr = addressOfSalt[salt];
        if (addr == address(0)) {
            require(!saltNullifiers[saltNullifier], "Used saltNullifier");
            saltNullifiers[saltNullifier] = true;
            addr = accountDeployer.computeAccountAddress(
                salt,
                defaultAccountLogic
            );
            addressOfSalt[salt] = addr;
            accountLogicOfNonRegisteredUser[addr] = defaultAccountLogic;
            verifierOfNonRegisteredUser[addr] = defaultVerifier;
            uint256[4] memory extensionIds = [
                Constants.WALLET_EXTENSION_ID,
                Constants.CONFIG_EXTENSION_ID,
                Constants.EXT_EXTENSION_ID,
                Constants.TRANSPORT_EXTENSION_ID
            ];
            for (uint idx = 0; idx < 4; idx++) {
                extensionOfNonRegisteredUser[extensionIds[idx]][
                    addr
                ] = defaultExtensionOfId[extensionIds[idx]];
            }
        } else {
            require(
                saltNullifiers[saltNullifier],
                "saltNullifier is not registered."
            );
        }
        return addr;
    }
}
