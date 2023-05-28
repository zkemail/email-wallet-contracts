// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./AccountStorage.sol";
import "./AccountProxy.sol";
import "./IAccount.sol";
import "../verifier/IVerifierWrapper.sol";
import "../extension/IExtension.sol";
import "../utils/Create2.sol";
import "../utils/Constants.sol";

contract AccountLogic is IAccount, AccountStorage, Initializable {
    using Create2 for bytes32;

    modifier onlyEntry() {
        require(
            msg.sender == entry,
            "Only the entry contract can call this function."
        );
        _;
    }

    modifier onlySelf() {
        require(
            msg.sender == address(this),
            "Only myself can call this function."
        );
        _;
    }

    function initialize(
        address _verifier,
        uint256[] calldata _initExtensionIds,
        address[] calldata _initExtensionAddrs
    ) public initializer {
        require(_verifier != address(0), "_verifier must not be zero address.");
        require(
            _initExtensionIds.length == _initExtensionAddrs.length,
            "Not equal lengthes"
        );
        for (uint idx = 0; idx < _initExtensionIds.length; idx++) {
            changeExtension(_initExtensionIds[idx], _initExtensionAddrs[idx]);
        }
        // An entry contract owns the deployer contract (=msg.sender).
        Ownable deployer = Ownable(msg.sender);
        entry = deployer.owner();
        verifier = _verifier;
    }

    function getEntryAddr() external view returns (address) {
        return entry;
    }

    function getVerifierWrapper() public view returns (IVerifierWrapper) {
        require(verifier != address(0), "The verifier is not set.");
        return IVerifierWrapper(verifier);
    }

    function getExtension(uint extensionId) public view returns (IExtension) {
        require(
            extensionOfId[extensionId] != address(0),
            "not registered extension"
        );
        return IExtension(extensionOfId[extensionId]);
    }

    function isExtensionInstalled(
        uint extensionId
    ) external view returns (bool) {
        return extensionOfId[extensionId] != address(0);
    }

    function verifyCall(
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams,
        IVerifierWrapper verifier,
        IExtension extension
    ) public view {
        // 1. email proof verification
        require(verifier.verifyWrap(verifierParams, proof), "Invalid proof");
        // 2. nullifier check
        bytes32 headerHash = verifier.getHeaderHash(verifierParams);
        require(!emailNullifiers[headerHash], "already used email");
        // 3. subject check
        string memory subjectExpected = string.concat(
            SUBJECT_PREFIX,
            extension.commandName(),
            ": ",
            extension.buildSubject(extensionParams)
        );
        require(
            keccak256(bytes(verifier.getSubjectStr(verifierParams))) ==
                keccak256(bytes(subjectExpected)),
            "The subject is not equal to the expected one."
        );
    }

    function callExtension(
        IExtension.CallContext memory callCtx,
        bytes memory extensionParams
    ) external onlyEntry {
        emailNullifiers[callCtx.headerHash] = true;
        IExtension extension = getExtension(callCtx.extensionId);
        IExtension.ForwardContext memory forwardCtx = IExtension.ForwardContext(
            false,
            0
        );
        if (
            callCtx.extensionId == Constants.WALLET_EXTENSION_ID ||
            callCtx.extensionId == Constants.CONFIG_EXTENSION_ID ||
            callCtx.extensionId == Constants.EXT_EXTENSION_ID ||
            callCtx.extensionId == Constants.TRANSPORT_EXTENSION_ID
        ) {
            _delegateExtCall(
                address(extension),
                callCtx,
                forwardCtx,
                extensionParams
            );
        } else {
            extension.execute(callCtx, forwardCtx, extensionParams);
        }
        // IExtension.CallType calltype = extension.getCallType();
        // if (calltype == IExtension.CallType.Call) {
        //     extension.execute(subjectAddr, extensionParams);
        // } else if (calltype == IExtension.CallType.DelegateCall) {
        //     (bool success, bytes memory returnData) = address(extension)
        //         .delegatecall(
        //             abi.encodeWithSignature(
        //                 "execute(address,bytes)",
        //                 subjectAddr,
        //                 extensionParams
        //             )
        //         );
        //     if (!success) {
        //         if (returnData.length == 0) revert();
        //         assembly {
        //             revert(add(32, returnData), mload(returnData))
        //         }
        //     }
        // }
    }

    function forwardCall(
        IExtension.CallContext memory callCtx,
        bytes memory extensionParams
    ) public {
        uint256 callerExtensionId = extensionIdOfAddr[msg.sender];
        require(
            callerExtensionId != 0,
            "The id 0 extension cannot forward a call."
        );
        uint256 calleeExtensionId = callCtx.extensionId;
        require(
            forwardPermissions[callerExtensionId][calleeExtensionId],
            "Not permitted forward"
        );
        address calleeAddr = extensionOfId[calleeExtensionId];
        require(calleeAddr != address(0), "Not registered calleeExtensionId");
        IExtension.ForwardContext memory forwardCtx = IExtension.ForwardContext(
            true,
            callerExtensionId
        );
        if (
            calleeExtensionId == Constants.WALLET_EXTENSION_ID ||
            calleeExtensionId == Constants.CONFIG_EXTENSION_ID ||
            calleeExtensionId == Constants.EXT_EXTENSION_ID ||
            calleeExtensionId == Constants.TRANSPORT_EXTENSION_ID
        ) {
            _delegateExtCall(calleeAddr, callCtx, forwardCtx, extensionParams);
        } else {
            IExtension callee = IExtension(calleeAddr);
            callee.execute(callCtx, forwardCtx, extensionParams);
        }
    }

    function changeVerifier(address newVerifier) external onlySelf {
        require(newVerifier != address(0), "newVerifier is not zero address.");
        verifier = newVerifier;
    }

    function changeExtension(
        uint extensionId,
        address extensionAddr
    ) public onlySelf {
        require(
            extensionAddr != address(0),
            "extensionAddr is not zero address."
        );
        extensionOfId[extensionId] = extensionAddr;
        extensionIdOfAddr[extensionAddr] = extensionId;
    }

    function changeEntry(address newEntry) external onlySelf {
        require(newEntry != address(0), "newEntry is not zero address.");
        entry = newEntry;
    }

    function addPermission(uint256 fromId, uint256 toId) external onlySelf {
        require(!forwardPermissions[fromId][toId], "Already permitted");
        forwardPermissions[fromId][toId] = true;
    }

    function removePermission(uint256 fromId, uint256 toId) external onlySelf {
        require(forwardPermissions[fromId][toId], "Not permitted");
        forwardPermissions[fromId][toId] = false;
    }

    function _delegateExtCall(
        address extensionAddr,
        IExtension.CallContext memory callCtx,
        IExtension.ForwardContext memory forwardCtx,
        bytes memory extensionParams
    ) private {
        (bool success, bytes memory returnData) = extensionAddr.delegatecall(
            abi.encodeWithSignature(
                "execute((uint256,bytes32,address),(bool,uint256),bytes)",
                callCtx,
                forwardCtx,
                extensionParams
            )
        );
        if (!success) {
            if (returnData.length == 0) revert();
            assembly {
                revert(add(32, returnData), mload(returnData))
            }
        }
    }
}
