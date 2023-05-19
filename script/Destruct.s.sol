// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/EmailWallet.sol";

contract Destruct is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.parseUint(vm.readFile(".privateDeploy"));
        address walletAddress = vm.envAddress("EMAIL_WALLET_ADDRESS");
        EmailWallet wallet = EmailWallet(payable(walletAddress));
        vm.startBroadcast(privateKey);
        wallet.destructWallet();
        vm.stopBroadcast();
    }
}
