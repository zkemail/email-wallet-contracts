// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";
import "./ViewingKeysMap.sol";
import "./EmailOp.sol";
import "./PendingValues.sol";

// import "./verifier/IVerifier.sol";
// import "./extension/IExtension.sol";
// import "./account/IAccount.sol";
// import "./utils/Create2.sol";
// import "./utils/Constants.sol";

contract Core is PendingValues, EmailOp {
    constructor(
        address _globalVerifier,
        uint _verifierListUpdateFrequency
    ) EmailOp(_globalVerifier, _verifierListUpdateFrequency) {}
}
