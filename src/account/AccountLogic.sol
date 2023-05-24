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

    function initialize(address _verifier) public initializer {
        verifier = _verifier;
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
    ) external onlyOwner {
        IVerifierWrapper verifierWrapper = getVerifierWrapper();
        require(
            verifierWrapper.verifyWrap(verifierParams, proof),
            "Invalid proof"
        );
        bytes32 headerHash = verifierWrapper.getHeaderHash(verifierParams);
        require(!emailNullifiers[headerHash], "already used email");
        IExtension extension = getExtension(extensionId);
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
}
