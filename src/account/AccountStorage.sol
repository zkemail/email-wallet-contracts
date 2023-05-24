// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract AccountStorage {
    bytes32 selfSalt;
    string constant SUBJECT_PREFIX = "Email Wallet ";
    address public verifier;
    mapping(uint256 => address) public extensionOfId;
    mapping(bytes32 => bool) public nullifiers;
}
