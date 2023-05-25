// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";

library ExtensionHelper {
    using Strings for *;
    struct StringType {
        string value;
    }

    struct UintType {
        uint256 value;
    }

    struct DecimalType {
        uint256 intPart;
        uint256 decNumZero;
        uint256 decimalPart;
    }

    struct AddressType {
        bool isEmailAddr;
        address value;
    }

    function toString(
        StringType memory value
    ) external pure returns (string memory) {
        return value.value;
    }

    function toString(
        UintType memory value
    ) external pure returns (string memory) {
        return value.value.toString();
    }

    function toString(
        DecimalType memory value
    ) external pure returns (string memory) {
        string memory decString = string.concat(value.intPart.toString(), ".");
        for (uint i = 0; i < value.decNumZero; i++) {
            decString = string.concat(decString, "0");
        }
        decString = string.concat(decString, value.decimalPart.toString());
        return decString;
    }

    function toString(
        AddressType memory value
    ) external pure returns (string memory) {
        if (value.isEmailAddr) return "";
        return value.value.toHexString();
    }
}
