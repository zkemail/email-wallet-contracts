// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "../interfaces/IERC20.sol";
import "../Storage.sol";

contract Rule1Manipulator is Storage, IManipulator, Rule1VerifierWrapper {
    event EmailTransfer(
        string indexed amount,
        string indexed currency,
        string indexed recipient
    );

    constructor(address _verifier) Storage() Rule1VerifierWrapper(_verifier) {}

    function verifyWrap(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external view returns (bool) {
        Param memory param = abi.decode(param, (Param));
        return _verifyWrap(param, acc, proof);
    }

    function process(
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) external {
        Param memory param = abi.decode(param, (Param));
        string memory tokenStr = param.substr1String;
        require(isRegisteredToken[tokenStr], "not registered token");
        IERC20 token = IERC20(erc20OfTokenName[tokenStr]);
        uint decimals = uint(token.decimals());
        uint amount = param.substr0IntPart *
            10 ** decimals +
            param.substr0DecimalPart *
            10 ** (decimals - 1 - param.substr0DecNumZero);
        require(balanceOfUser[param.fromAddressString][tokenStr] >= amount);
        balanceOfUser[param.fromAddressString][tokenStr] -= amount;
        balanceOfUser[param.substr2String][tokenStr] += amount;
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
