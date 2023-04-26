// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "../interfaces/IERC20.sol";
import "forge-std/console.sol";
import "../EmailWallet.sol";

contract Rule1Manipulator is IManipulator, Rule1VerifierWrapper {
    EmailWallet wallet;
    event EmailTransfer(
        string indexed amount,
        string indexed currency,
        string indexed recipient
    );

    constructor(
        address _verifier,
        address payable _wallet
    ) Rule1VerifierWrapper(_verifier) {
        wallet = EmailWallet(_wallet);
    }

    function verifyWrap(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool) {
        Param memory param = abi.decode(param, (Param));
        return _verifyWrap(param, acc, proof);
    }

    function process(bytes calldata param) external {
        Param memory param = abi.decode(param, (Param));
        string memory tokenStr = param.substr1String;
        require(wallet.isRegisteredToken(tokenStr), "not registered token");
        IERC20 token = IERC20(wallet.erc20OfTokenName(tokenStr));
        uint decimals = uint(token.decimals());
        uint amount = param.substr0IntPart *
            10 ** decimals +
            param.substr0DecimalPart *
            10 ** (decimals - 1 - param.substr0DecNumZero);
        require(
            wallet.balanceOfUser(param.fromAddressString, tokenStr) >= amount
        );
        wallet.manipulateBalanceOfUser(
            param.fromAddressString,
            tokenStr,
            wallet.balanceOfUser(param.fromAddressString, tokenStr) - amount
        );
        wallet.manipulateBalanceOfUser(
            param.substr2String,
            tokenStr,
            wallet.balanceOfUser(param.substr2String, tokenStr) + amount
        );
        string memory amountStr = decString(
            param.substr0IntPart,
            param.substr0DecNumZero,
            param.substr0DecimalPart
        );
        emit EmailTransfer(amountStr, param.substr1String, param.substr2String);
    }

    function retrieveData(
        bytes calldata param
    ) external view returns (RetrievedData memory) {
        Param memory param = abi.decode(param, (Param));
        RetrievedData memory data;
        data.headerHash = param.headerHash;
        data.publicKey = param.publicKey;
        data.fromAddress = param.fromAddressString;
        data.toAddress = param.toAddressString;
        data.manipulationId = param.manipulationIdUint;
        return data;
    }
}
