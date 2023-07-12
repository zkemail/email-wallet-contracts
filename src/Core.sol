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

contract Core is EmailOp {
    constructor(
        address _globalVerifier,
        uint _verifierListUpdateFrequency
    ) EmailOp(_globalVerifier, _verifierListUpdateFrequency) {}

    function processBundle(
        ProcessPendingValueParams[] memory processPendingValueParams,
        EmailOperation[] memory emailOps
    ) public {
        require(relayers[msg.sender], "relayer not registered");
        for (uint i = 0; i < processPendingValueParams.length; i++) {
            _processPendingValue(processPendingValueParams[i]);
        }
        for (uint i = 0; i < emailOps.length; i++) {
            _validateEmailOp(emailOps[i]);
        }
        for (uint i = 0; i < emailOps.length; i++) {
            uint256 startGas = gasleft();
            _executeEmailOp(emailOps[i]);
            uint256 gasUsed = startGas - gasleft();
            /// [TODO] Gas payment.
        }
    }
}
