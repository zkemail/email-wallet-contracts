// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IManipulator.sol";
import "./interfaces/IWETH.sol";
import "./interfaces/IERC20.sol";
import "forge-std/console.sol";

contract Storage {
    mapping(string => address payable) public ethAddressOfUser;
    mapping(string => mapping(string => uint)) public balanceOfUser;
    mapping(string => address) public erc20OfTokenName;
    mapping(string => bool) public isRegisteredToken;
    string constant ETH_NAME = "ETH";
}
