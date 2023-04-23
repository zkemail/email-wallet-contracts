// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Manipulator is IManipulator, VerifierWrapper {
    mapping(string => address payable) public ethAddressOfUser;
    mapping(string => mapping(string => uint)) public balanceOfUser;
    mapping(bytes32 => bool) public isUsedEmailHash;
    mapping(uint => IManipulator) public manipulatorOfRuleId;
    mapping(string => address) public erc20OfTokenName;
    mapping(string => bool) public isRegisteredToken;

    string constant ETH_NAME = "ETH";

    constructor(address _verifier) VerifierWrapper(_verifier) {}

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
        ERC20 token = ERC20(erc20OfTokenName[tokenStr]);
        uint decimals = uint(token.decimals());
        uint amount = param.substr0IntPart *
            10 ** decimals +
            param.substr0DecimalPart *
            10 ** (decimals - 1 - param.substr0DecNumZero);
        require(balanceOfUser[param.fromAddressString][tokenStr] >= amount);
        balanceOfUser[param.fromAddressString][tokenStr] -= amount;
        balanceOfUser[param.substr2String][tokenStr] += amount;
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
