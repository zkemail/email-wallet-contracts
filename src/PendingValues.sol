// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";

contract PendingValues {
    /// Pending functions.
    bytes32[] public pendingViewingKeyCommits;
    bytes[] public pendingOldValues;
    bytes[] public pendingNewValues;

    function _addPendingValue(
        bytes32 viewingKey,
        bytes memory oldValue,
        bytes memory newValue
    ) internal {
        pendingViewingKeyCommits.push(viewingKey);
        pendingOldValues.push(oldValue);
        pendingNewValues.push(newValue);
    }

    function _processPendingValue(
        AnonMap anonMap,
        bytes32 newValuesRoot,
        bytes32 newNullifierRoot,
        bytes32 valueCommit,
        bytes32 nullifier,
        bytes memory insertProof,
        bytes memory removeProof
    ) internal {
        anonMap.insert(
            newValuesRoot,
            pendingViewingKeyCommits[0],
            valueCommit,
            pendingNewValues[0],
            insertProof
        );
        anonMap.remove(
            newNullifierRoot,
            pendingViewingKeyCommits[0],
            nullifier,
            pendingOldValues[0],
            removeProof
        );
        pendingViewingKeyCommits.pop();
        pendingOldValues.pop();
        pendingNewValues.pop();
    }
}
