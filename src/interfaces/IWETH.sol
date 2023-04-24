// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// original:https://solidity-by-example.org/defi/uniswap-v2/
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IERC20.sol";

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}
