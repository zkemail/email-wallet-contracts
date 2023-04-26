// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/EmailWallet.sol";
import "../src/rule1/Verifier.sol";
import "../src/rule1/VerifierWrapper.sol";
import "../src/rule1/Manipulator.sol";
import "../src/rule2/Verifier.sol";
import "../src/rule2/VerifierWrapper.sol";
import "../src/rule2/Manipulator.sol";

contract WithdrawETH is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.parseUint(vm.readFile(".privateWithdraw"));
        address walletAddress = vm.envAddress("EMAIL_WALLET_ADDRESS");
        EmailWallet wallet = EmailWallet(payable(walletAddress));
        string memory emailAddress = vm.envString("WITHDRAW_EMAIL_ADDRESS");
        uint weiAmount = vm.envUint("WITHDRAW_WEI");
        vm.startBroadcast(privateKey);
        wallet.withdrawETH(emailAddress, weiAmount);
        vm.stopBroadcast();
    }
}
