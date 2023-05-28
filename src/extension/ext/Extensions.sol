// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "solidity-stringutils/src/strings.sol";
import "../IExtension.sol";
import "../ExtensionHelper.sol";
import "./ExtensionRegistry.sol";
import "../VersionManager.sol";
import "../../account/IAccount.sol";
import "../../account/IAccountFactory.sol";
import "../../IEntry.sol";
import "../../utils/Constants.sol";

contract Config is IExtension {
    using ExtensionHelper for *;
    using strings for *;
    struct ExecuteParams {
        ExtensionHelper.StringType opType;
        ExtensionHelper.StringType extensionName;
        ExtensionHelper.StringType versionName;
        ExtensionHelper.StringType devName;
    }
    string public constant COMMAND = "extension";
    string public constant VER_NAME_PREFIX = " at version ";
    string public constant DEV_NAME_PREFIX = " developed by ";
    string public constant OP_INSTALL = "install";
    bytes32 public constant OP_INSTALL_HASH = keccak256(bytes(OP_INSTALL));
    string public constant OP_UNINSTALL = "uninstall";
    bytes32 public constant OP_UNINSTALL_HASH = keccak256(bytes(OP_UNINSTALL));
    ExtensionRegistry public extRegistry;

    constructor(address _extRegistry) {
        extRegistry = ExtensionRegistry(_extRegistry);
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
        return regexes;
    }

    function executeDecomposedRegexes()
        external
        pure
        returns (DecomposedRegex[] memory)
    {
        DecomposedRegex[] memory regexes;
        regexes[0] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat("(", OP_INSTALL, "|", OP_UNINSTALL, ")")
        );
        regexes[1] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            " "
        );
        regexes[2] = DecomposedRegex(
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
        regexes[3] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat(
                VER_NAME_PREFIX,
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
            true,
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
        string memory extensionName = abi.decode(queryData, (string));
        // This contract is delegate-called from the account contract.
        uint256 extensionId = extRegistry.getExtensionId(extensionName);
        string memory devName = extRegistry.getCurrentDev(
            accountAddr,
            extensionId
        );
        address managerAddr = extRegistry.getExtensionManager(extensionId);
        if (managerAddr == address(0)) {
            return
                string.concat(
                    "ERROR: The extension ",
                    extensionName,
                    " does not exist."
                );
        }
        IAccount account = IAccount(address(this));
        if (!account.isExtensionInstalled(extensionId)) {
            return
                string.concat(
                    "ERROR: The extension ",
                    extensionName,
                    " is not installed."
                );
        }
        IExtension extension = account.getExtension(extensionId);
        string memory version = VersionManager(managerAddr).getVersion(
            address(extension)
        );
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
            callCtx.extensionId == Constants.EXT_EXTENSION_ID,
            "Invalid extensionId"
        );
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        address subjectAddr = callCtx.subjectAddr;
        require(subjectAddr == address(0), "subjectAddr is not used.");
        string memory extensionName = params.extensionName.toString();
        uint256 extensionId = extRegistry.getExtensionId(extensionName);
        address managerAddr = extRegistry.getExtensionManager(extensionId);
        require(managerAddr != address(0), "The extension does not exist.");
        bytes32 opTypeHash = keccak256(bytes(params.opType.toString()));
        // This contract is delegate-called from the account contract.
        string memory version = params
            .versionName
            .toString()
            .toSlice()
            .beyond(VER_NAME_PREFIX.toSlice())
            .toString();
        string memory devName = params
            .devName
            .toString()
            .toSlice()
            .beyond(DEV_NAME_PREFIX.toSlice())
            .toString();
        IAccount account = IAccount(address(this));
        if (opTypeHash == OP_INSTALL_HASH) {
            require(
                bytes(version).length > 0,
                "The version cannot be omitted when opType==install."
            );
            if (!account.isExtensionInstalled(extensionId)) {
                require(
                    bytes(devName).length > 0,
                    "The devName cannot be omitted when the extension is not installed."
                );
            } else if (bytes(devName).length == 0) {
                devName = extRegistry.getCurrentDev(address(this), extensionId);
            }
            address dev = extRegistry.devManager().getAddress(devName);
            address extensionAddr = VersionManager(managerAddr).getContract(
                dev,
                version
            );
            account.changeExtension(extensionId, extensionAddr);
            uint[] memory permissionRequests = IExtension(extensionAddr)
                .permissionRequests();
            for (uint idx = 0; idx < permissionRequests.length; idx++) {
                account.addPermission(extensionId, permissionRequests[idx]);
            }
        } else if (opTypeHash == OP_UNINSTALL_HASH) {
            require(
                bytes(version).length == 0 && bytes(devName).length == 0,
                "version and devName must be omitted when opType==uninstall."
            );
            account.changeExtension(extensionId, address(0));
            address dev = extRegistry.devManager().getAddress(
                extRegistry.getCurrentDev(address(this), extensionId)
            );
            address extensionAddr = VersionManager(managerAddr).getContract(
                dev,
                version
            );
            uint[] memory permissionRequests = IExtension(extensionAddr)
                .permissionRequests();
            for (uint idx = 0; idx < permissionRequests.length; idx++) {
                account.removePermission(extensionId, permissionRequests[idx]);
            }
        } else {
            require(false, "Not supported operation.");
        }
    }

    function buildSubject(
        ExecuteParams memory params
    ) public pure returns (string memory) {
        string memory subject = string.concat(
            params.opType.toString(),
            " ",
            params.extensionName.toString(),
            " at version ",
            params.versionName.toString()
        );
        bytes32 opTypeHash = keccak256(bytes(params.opType.toString()));
        if (opTypeHash == OP_INSTALL_HASH) {
            subject = string.concat(
                subject,
                " at version ",
                params.versionName.toString()
            );
            string memory devName = params.devName.toString();
            if (bytes(devName).length > 0) {
                subject = string.concat(subject, " developed by ", devName);
            }
        }

        return subject;
    }
}
