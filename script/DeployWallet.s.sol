// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/EmailWallet.sol";

contract DeployScript is Script {
    function setUp() public {}

    // mainnet WETH: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
    // goerli WETH 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6
    // arbitrum mainnet WETH: 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1
    // mainnet DAI: 0x6B175474E89094C44Da98b954EedeAC495271d0F
    // goerli DAI: 0x73967c6a0904aA032C103b4104747E88c566B1A2
    // arbitrum mainnet DAI: 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1
    function run() public {
        uint256 privateKey = vm.parseUint(vm.readFile(".privateDeploy"));
        bytes memory publicKey = vm.parseBytes(
            vm.readFile("./test_data/gmail_pk.hex")
        );
        string[] memory tokenNames = new string[](1);
        tokenNames[0] = "DAI";
        address[] memory tokenAddresses = new address[](1);
        tokenAddresses[0] = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

        vm.startBroadcast(privateKey);
        new EmailWallet(
            "emailwallet.relayer@gmail.com",
            0,
            publicKey,
            tokenNames,
            tokenAddresses,
            address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1)
        );
        vm.stopBroadcast();
    }
}
