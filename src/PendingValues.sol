// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";

contract PendingValues {
    /// Pending functions.
    address[] public pendingAnonMaps;
    bytes32[] public pendingViewingKeyCommits;
    bytes[] public pendingOldValues;
    bytes[] public pendingNewValues;

    struct ProcessPendingValueOperation {
        bytes32 newValuesRoot;
        bytes32 newNullifierRoot;
        bytes32 valueCommit;
        bytes32 nullifier;
        bytes insertProof;
        bytes removeProof;
    }

    function _addPendingValue(
        address anonMap,
        bytes32 viewingKey,
        bytes memory oldValue,
        bytes memory newValue
    ) internal {
        pendingAnonMaps.push(anonMap);
        pendingViewingKeyCommits.push(viewingKey);
        pendingOldValues.push(oldValue);
        pendingNewValues.push(newValue);
    }

    function _processPendingValue(
        ProcessPendingValueOperation memory op
    ) internal {
        AnonMap anonMap = AnonMap(pendingAnonMaps[0]);
        anonMap.insert(
            op.newValuesRoot,
            pendingViewingKeyCommits[0],
            op.valueCommit,
            pendingNewValues[0],
            op.insertProof
        );
        anonMap.remove(
            op.newNullifierRoot,
            pendingViewingKeyCommits[0],
            op.nullifier,
            pendingOldValues[0],
            op.removeProof
        );
        pendingAnonMaps.pop();
        pendingViewingKeyCommits.pop();
        pendingOldValues.pop();
        pendingNewValues.pop();
    }
}
