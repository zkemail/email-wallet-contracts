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

contract DepositETH is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.parseUint(vm.readFile(".privateDeposit"));
        address walletAddress = vm.envAddress("EMAIL_WALLET_ADDRESS");
        EmailWallet wallet = EmailWallet(payable(walletAddress));
        string memory emailAddress = vm.envString("DEPOSIT_EMAIL_ADDRESS");
        uint weiAmount = vm.envUint("DEPOSIT_WEI");
        vm.startBroadcast(privateKey);
        wallet.depositETH{value: weiAmount}(emailAddress);
        vm.stopBroadcast();
    }
}
