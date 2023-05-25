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
            uint256 extensionId = _initExtensionIds[idx];
            address addr = _initExtensionAddrs[idx];
            require(addr != address(0), "addr must not be zero address.");
            extensionOfId[extensionId] = addr;
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

    function callExtension(
        uint extensionId,
        address subjectAddr,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external onlyEntry {
        IVerifierWrapper verifierWrapper = getVerifierWrapper();
        // 1. email proof verification
        require(
            verifierWrapper.verifyWrap(verifierParams, proof),
            "Invalid proof"
        );
        // 2. nullifier check
        bytes32 headerHash = verifierWrapper.getHeaderHash(verifierParams);
        require(!emailNullifiers[headerHash], "already used email");
        IExtension extension = getExtension(extensionId);
        // 3. subject check
        string memory subjectExpected = string.concat(
            SUBJECT_PREFIX,
            extension.commandName(),
            " ",
            extension.buildSubject(extensionParams)
        );
        require(
            keccak256(bytes(verifierWrapper.getSubjectStr(verifierParams))) ==
                keccak256(bytes(subjectExpected)),
            "The subject is not equal to the expected one."
        );
        emailNullifiers[headerHash] = true;
        // 4. call extension
        extension.execute(subjectAddr, extensionParams);
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

    function changeEntry(address newEntry) external onlyEntry {
        require(newEntry != address(0), "newEntry is not zero address.");
        entry = newEntry;
    }
}
