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

    struct ProcessPendingValueParams {
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
        ProcessPendingValueParams memory params
    ) internal {
        AnonMap anonMap = AnonMap(pendingAnonMaps[0]);
        anonMap.insert(
            params.newValuesRoot,
            pendingViewingKeyCommits[0],
            params.valueCommit,
            pendingNewValues[0],
            params.insertProof
        );
        anonMap.remove(
            params.newNullifierRoot,
            pendingViewingKeyCommits[0],
            params.nullifier,
            pendingOldValues[0],
            params.removeProof
        );
        pendingAnonMaps.pop();
        pendingViewingKeyCommits.pop();
        pendingOldValues.pop();
        pendingNewValues.pop();
    }
}
