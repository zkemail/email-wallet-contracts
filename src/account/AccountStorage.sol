// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract AccountStorage {
    string constant SUBJECT_PREFIX = "Email ";
    address public verifier;
    mapping(uint256 => address) public extensionOfId;
    mapping(bytes32 => bool) public emailNullifiers;
}
