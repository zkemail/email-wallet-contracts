// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenRegistry is Ownable {
    mapping(string => address) public tokenOfSymbol;

    function getTokenOfSymbol(
        string calldata symbol
    ) public view returns (address) {
        require(tokenOfSymbol[symbol] != address(0), "Not registered token");
        return tokenOfSymbol[symbol];
    }

    function addToken(address tokenAddr) public onlyOwner {
        IERC20Metadata token = IERC20Metadata(tokenAddr);
        string memory symbol = token.symbol();
        require(
            tokenOfSymbol[symbol] == address(0),
            "Already registered token"
        );
        tokenOfSymbol[symbol] = tokenAddr;
    }
}
