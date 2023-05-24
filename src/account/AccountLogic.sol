// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./AccountStorage.sol";
import "./AccountProxy.sol";
import "./IAccount.sol";
import "../verifier/IVerifierWrapper.sol";
import "../extension/IExtension.sol";
import "../Entry.sol";
import "../utils/Create2.sol";

contract AccountLogic is IAccount, AccountStorage, Ownable, Initializable {
    using Create2 for bytes32;

    function initialize(
        bytes32 _selfSalt,
        address _verifier
    ) public initializer {
        selfSalt = _selfSalt;
        verifier = _verifier;
    }

    function getVerifierWrapper() external view returns (address) {
        return verifier;
    }

    function getExtension(uint extensionId) external view returns (address) {
        return extensionOfId[extensionId];
    }

    // function verifyOp(
    //     bytes memory verifierParams,
    //     bytes memory proof,
    //     uint extensionId,
    //     bytes memory extensionParams
    // ) external returns (bool) {
    //     require(verifier != address(0), "The verifier is not set.");
    //     IVerifierWrapper verifierWrapper = IVerifierWrapper(verifier);
    //     require(
    //         verifierWrapper.verifyWrap(verifierParams, proof),
    //         "Invalid proof"
    //     );
    //     bytes32 headerHash = verifierWrapper.getHeaderHash(verifierParams);
    //     require(nullifiers[headerHash] == false, "already used nullifier");
    //     bytes32 fromSalt = verifierWrapper.getFromAddrSalt(verifierParams);
    //     require(fromSalt == selfSalt, "Invalid fromSalt");
    //     address extensionAddr = extensionOfId[extensionId];
    //     require(extensionAddr != address(0), "not registered extension");
    //     IExtension extension = IExtension(extensionAddr);
    //     string memory commandStr = extension.commandName();
    //     string memory paramsStr = extension.buildSubject(extensionParams);
    //     string memory subjectExpected = string.concat(
    //         SUBJECT_PREFIX,
    //         commandStr,
    //         paramsStr
    //     );
    //     string memory subjectStr = verifierWrapper.getSubjectStr(
    //         verifierParams
    //     );
    //     require(
    //         keccak256(subjectStr) == keccak256(subjectExpected),
    //         "The subject is not equal to the expected one."
    //     );
    //     nullifiers[headerHash] = true;
    //     return true;
    // }

    function callExtension(
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) external onlyOwner {
        require(verifier != address(0), "The verifier is not set.");
        IVerifierWrapper verifierWrapper = IVerifierWrapper(verifier);
        require(
            verifierWrapper.verifyWrap(verifierParams, proof),
            "Invalid proof"
        );
        bytes32 headerHash = verifierWrapper.getHeaderHash(verifierParams);
        require(nullifiers[headerHash] == false, "already used nullifier");
        bytes32 fromSalt = verifierWrapper.getFromAddrSalt(verifierParams);
        require(fromSalt == selfSalt, "Invalid fromSalt");
        address extensionAddr = extensionOfId[extensionId];
        require(extensionAddr != address(0), "not registered extension");
        IExtension extension = IExtension(extensionAddr);
        string memory subjectExpected = string.concat(
            SUBJECT_PREFIX,
            extension.commandName(),
            extension.buildSubject(extensionParams)
        );
        string memory subjectStr = verifierWrapper.getSubjectStr(
            verifierParams
        );
        require(
            keccak256(bytes(subjectStr)) == keccak256(bytes(subjectExpected)),
            "The subject is not equal to the expected one."
        );
        nullifiers[headerHash] = true;
        bytes32 subjectAddrSalt = verifierWrapper.getSubjectAddrSalt(
            verifierParams
        );
        Entry entry = Entry(owner());
        address subjectAddr = entry.addressOfSalt(subjectAddrSalt);
        if (subjectAddr == address(0)) {
            subjectAddr = subjectAddrSalt.computeAddress(
                keccak256(type(AccountProxy).creationCode),
                address(entry)
            );
        }
        IExtension.CallType calltype = extension.getCallType();
        if (calltype == IExtension.CallType.Call) {
            extension.execute(subjectAddr, extensionParams);
        } else if (calltype == IExtension.CallType.DelegateCall) {
            (bool success, bytes memory returnData) = address(extension)
                .delegatecall(
                    abi.encodeWithSignature(
                        "execute(address,bytes)",
                        subjectAddr,
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
}
