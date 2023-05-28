// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../IExtension.sol";
import "../ExtensionHelper.sol";
import "./ConfigRegistry.sol";
import "../VersionManager.sol";
import "../../account/IAccount.sol";
import "../../account/IAccountFactory.sol";
import "../../IEntry.sol";
import "../../utils/Constants.sol";

contract Config is IExtension {
    using ExtensionHelper for *;
    struct ExecuteParams {
        ExtensionHelper.StringType contractName;
        ExtensionHelper.StringType versionName;
        ExtensionHelper.StringType devName;
    }
    string public constant COMMAND = "config";
    string public constant ACCOUNT_NAME = "account";
    bytes32 public constant ACCOUNT_NAME_HASH = keccak256(bytes(ACCOUNT_NAME));
    string public constant VERIFIER_NAME = "verifier";
    bytes32 public constant VERIFIER_NAME_HASH =
        keccak256(bytes(VERIFIER_NAME));
    string public constant DEV_NAME_PREFIX = " developed by ";
    ConfigRegistry public configRegistry;

    constructor(address _configRegistry) {
        configRegistry = ConfigRegistry(_configRegistry);
    }

    function commandName() public pure returns (string memory) {
        return COMMAND;
    }

    function queryDecomposedRegexes()
        public
        pure
        returns (DecomposedRegex[] memory)
    {
        DecomposedRegex[] memory regexes;
        regexes[0] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            "my config of "
        );
        regexes[1] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat("(", ACCOUNT_NAME, "|", VERIFIER_NAME, ")")
        );
        return regexes;
    }

    function executeDecomposedRegexes()
        external
        pure
        returns (DecomposedRegex[] memory)
    {
        DecomposedRegex[] memory regexes;
        regexes[0] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            "change my "
        );
        regexes[1] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat("(", ACCOUNT_NAME, "|", VERIFIER_NAME, ")")
        );
        regexes[2] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            " to version "
        );
        regexes[3] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat(
                "(",
                ExtensionHelper.CAPITAL_ALPHABET,
                "|",
                ExtensionHelper.SMALL_ALPHABET,
                "|",
                ExtensionHelper.DIGEST,
                "|",
                "\\.|-|:",
                ")+"
            )
        );
        regexes[4] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat(
                "(",
                DEV_NAME_PREFIX,
                ExtensionHelper.CAPITAL_ALPHABET,
                "|",
                ExtensionHelper.SMALL_ALPHABET,
                "|",
                ExtensionHelper.DIGEST,
                "|",
                "\\.|-|:",
                ")*"
            )
        );
        return regexes;
    }

    function permissionRequests() external pure returns (uint256[] memory) {
        uint256[] memory ids;
        return ids;
    }

    function query(
        address accountAddr,
        bytes memory queryData
    ) public view returns (string memory) {
        string memory contractName = abi.decode(queryData, (string));
        bytes32 contractNameHash = keccak256(bytes(contractName));
        // This contract is delegate-called from the account contract.
        IAccount account = IAccount(accountAddr);
        string memory devName;
        string memory version;
        if (contractNameHash == ACCOUNT_NAME_HASH) {
            devName = configRegistry.getAccountCurrentDev(accountAddr);
            IEntry entry = IEntry(account.getEntryAddr());
            ProxyAdmin factory = ProxyAdmin(address(entry.getAccountFactory()));
            version = configRegistry.accountLogicManager().getVersion(
                factory.getProxyImplementation(
                    ITransparentUpgradeableProxy(accountAddr)
                )
            );
        } else if (contractNameHash == VERIFIER_NAME_HASH) {
            devName = configRegistry.getVerifierCurrentDev(accountAddr);
            version = configRegistry.verifierManager().getVersion(
                address(account.getVerifierWrapper())
            );
        } else {
            return
                string.concat(
                    "ERROR: The contract name ",
                    contractName,
                    " is invalid."
                );
        }
        return
            string.concat(
                "You are using version ",
                version,
                " developed by ",
                devName,
                "."
            );
    }

    function buildSubject(
        bytes memory extensionParams
    ) public pure returns (string memory) {
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        return buildSubject(params);
    }

    function execute(
        IExtension.CallContext memory callCtx,
        IExtension.ForwardContext memory,
        bytes memory extensionParams
    ) public {
        require(
            callCtx.extensionId == Constants.CONFIG_EXTENSION_ID,
            "Invalid extensionId"
        );
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        address subjectAddr = callCtx.subjectAddr;
        require(subjectAddr == address(0), "subjectAddr is not used.");
        bytes32 contractNameHash = keccak256(
            bytes(params.contractName.toString())
        );
        // This contract is delegate-called from the account contract.
        string memory devName = params.devName.toString().beyond(
            DEV_NAME_PREFIX.toSlice()
        );
        IAccount account = IAccount(address(this));
        if (contractNameHash == ACCOUNT_NAME_HASH) {
            if (bytes(devName).length == 0) {
                devName = configRegistry.getAccountCurrentDev(address(this));
            }
            address dev = configRegistry.devManager().getAddress(devName);
            IEntry entry = IEntry(account.getEntryAddr());
            address accountLogic = configRegistry
                .accountLogicManager()
                .getContract(dev, params.versionName.toString());
            entry.getAccountFactory().upgradeLogic(accountLogic);
            configRegistry.setAccountCurrentDev(devName);
        } else if (contractNameHash == VERIFIER_NAME_HASH) {
            if (bytes(devName).length == 0) {
                devName = configRegistry.getVerifierCurrentDev(address(this));
            }
            address dev = configRegistry.devManager().getAddress(devName);
            address verifier = configRegistry.verifierManager().getContract(
                dev,
                params.versionName.toString()
            );
            account.changeVerifier(verifier);
            configRegistry.setVerifierCurrentDev(devName);
        } else {
            require(false, "Not supported contract name.");
        }
    }

    function buildSubject(
        ExecuteParams memory params
    ) public pure returns (string memory) {
        string memory subject = string.concat(
            "change my ",
            params.contractName.toString(),
            " to version ",
            params.versionName.toString()
        );
        string memory devName = params.devName.toString();
        if (bytes(devName).length > 0) {
            subject = string.concat(subject, " developed by ", devName);
        }
        return subject;
    }
}
