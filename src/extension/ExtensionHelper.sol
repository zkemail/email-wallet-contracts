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

    string public constant STRING_TYPE_NAME = "String";
    string public constant UINT_TYPE_NAME = "Uint";
    string public constant DECIMAL_TYPE_NAME = "Decimal";
    string public constant ADDRESS_TYPE_NAME = "Address";

    // string public constant UINT_REGEX = "(0|1|2|3|4|5|6|7|8|9)+";
    // string public constant DECIMAL_REGEX = "(0|1|2|3|4|5|6|7|8|9|\\.)+";
    // string public constant EMAIL_ADDRESS_REGEX =
    //     "(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|0|1|2|3|4|5|6|7|8|9|_|\\.|-)+@(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|0|1|2|3|4|5|6|7|8|9|_|\\.|-)+";
    // string public constant ETH_ADDRESS_REGEX =
    //     "0x(0|1|2|3|4|5|6|7|8|9|a|b|c|d|e|f)+";
    string public constant CAPITAL_ALPHABET =
        "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z";
    string public constant SMALL_ALPHABET =
        "a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z";
    string public constant DIGEST = "0|1|2|3|4|5|6|7|8|9";

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
