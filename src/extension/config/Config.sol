// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../IExtension.sol";
import "../ExtensionHelper.sol";
import "./ConfigRepository.sol";
import "../VersionManager.sol";
import "../../account/IAccount.sol";
import "../../account/IAccountDeployer.sol";
import "../../IEntry.sol";

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
    ConfigRepository public configRepository;

    constructor(address _configRepository) {
        configRepository = ConfigRepository(_configRepository);
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
            "my config of"
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
            " developed by "
        );
        regexes[5] = DecomposedRegex(
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
        string memory devName = configRepository.getCurrentDev(accountAddr);
        // This contract is delegate-called from the account contract.
        IAccount account = IAccount(address(this));
        string memory version;
        if (contractNameHash == ACCOUNT_NAME_HASH) {
            IEntry entry = IEntry(account.getEntryAddr());
            ProxyAdmin deployer = ProxyAdmin(
                address(entry.getAccountDeployer())
            );
            version = configRepository.accountLogicManager().getVersion(
                deployer.getProxyImplementation(
                    ITransparentUpgradeableProxy(address(this))
                )
            );
        } else if (contractNameHash == VERIFIER_NAME_HASH) {
            version = configRepository.verifierManager().getVersion(
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

    function execute(address subjectAddr, bytes memory extensionParams) public {
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        require(subjectAddr == address(0), "subjectAddr is not used.");
        bytes32 contractNameHash = keccak256(
            bytes(params.contractName.toString())
        );
        // This contract is delegate-called from the account contract.
        IAccount account = IAccount(address(this));
        string memory devName = params.devName.toString();
        if (bytes(devName).length == 0) {
            devName = configRepository.getCurrentDev(address(this));
        }
        address dev = configRepository.devManager().getAddress(devName);
        if (contractNameHash == ACCOUNT_NAME_HASH) {
            IEntry entry = IEntry(account.getEntryAddr());
            address accountLogic = configRepository
                .accountLogicManager()
                .getContract(dev, params.versionName.toString());
            entry.getAccountDeployer().upgradeLogic(accountLogic);
        } else if (contractNameHash == VERIFIER_NAME_HASH) {
            address verifier = configRepository.verifierManager().getContract(
                dev,
                params.versionName.toString()
            );
            account.changeVerifier(verifier);
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
