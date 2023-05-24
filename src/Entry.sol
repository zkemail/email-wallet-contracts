// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier/IVerifierWrapper.sol";
import "./extension/IExtension.sol";
import "./account/IAccount.sol";

contract Entry is Ownable {
    mapping(bytes32 => address) public addressOfSalt;
    mapping(address => address) public verifierOfNonRegisteredUser;
    mapping(uint256 => mapping(address => address))
        public extensionOfNonRegisteredUser;
    address public defaultVerifier;
    mapping(uint256 => address) public defaultExtensionOfId;

    function entry(
        bytes32 accountAddrSalt,
        uint extensionId,
        bytes memory verifierParams,
        bytes memory proof,
        bytes memory extensionParams
    ) public onlyOwner {
        address accountAddr = addressOfSalt[accountAddrSalt];
        require(
            accountAddr != address(0),
            "The sender's account is not registered."
        );
        IAccount account = IAccount(accountAddr);
        // require(
        //     account.verifyOp(
        //         verifierParams,
        //         proof,
        //         extensionId,
        //         extensionParams
        //     ),
        //     "invalid operation"
        // );
        account.callExtension(
            extensionId,
            verifierParams,
            proof,
            extensionParams
        );
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
