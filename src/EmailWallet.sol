// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IManipulator.sol";
import "./interfaces/IWETH.sol";
import "./interfaces/IERC20.sol";
import "forge-std/console.sol";

contract EmailWallet {
    mapping(string => address payable) public ethAddressOfUser;
    mapping(string => mapping(string => uint)) public balanceOfUser;
    mapping(string => address) public erc20OfTokenName;
    mapping(string => bool) public isRegisteredToken;
    mapping(uint => IManipulator) public manipulationOfId;
    mapping(address => bool) public isAllowedManipulator;
    mapping(bytes32 => bool) public isUsedEmailHash;
    address payable aggregator;
    string aggregatorToAddress;
    uint numManipulations;
    uint numTokens;
    uint fixedFee;
    bytes32 validPublicKeyHash; // Here we fix our public key to the gmail one.
    string constant ETH_NAME = "ETH";

    event EmailProcessed(
        string indexed fromAddress,
        uint indexed manipulationId,
        bytes32 indexed emailHeaderHash
    );

    constructor(
        string memory _aggregatorToAddress,
        uint _fixedFee,
        bytes memory _publicKey,
        string[] memory _tokenNames,
        address[] memory _erc20Addresses,
        address _wethAddress
    ) {
        aggregator = payable(msg.sender);
        aggregatorToAddress = _aggregatorToAddress;
        fixedFee = _fixedFee;
        validPublicKeyHash = keccak256(_publicKey);
        numManipulations = 0;
        numTokens = _tokenNames.length;
        require(
            _tokenNames.length == _erc20Addresses.length,
            "tokens length must be equal"
        );
        for (uint i = 0; i < _tokenNames.length; i++) {
            erc20OfTokenName[_tokenNames[i]] = _erc20Addresses[i];
            isRegisteredToken[_tokenNames[i]] = true;
        }
        erc20OfTokenName[ETH_NAME] = _wethAddress;
        isRegisteredToken[ETH_NAME] = true;
    }

    function ethTokenName() public view returns (string memory) {
        return ETH_NAME;
    }

    function addManipulation(address _manipulatorAddress) public {
        require(msg.sender == aggregator, "only aggregator");
        uint newId = numManipulations + 1;
        manipulationOfId[newId] = IManipulator(_manipulatorAddress);
        isAllowedManipulator[_manipulatorAddress] = true;
        numManipulations += 1;
    }

    function manipulateBalanceOfUser(
        string memory emailAddress,
        string memory tokenStr,
        uint value
    ) public {
        require(isAllowedManipulator[msg.sender], "only allowed manipulator");
        balanceOfUser[emailAddress][tokenStr] = value;
    }

    function approveERC20(
        string memory tokenStr,
        uint value
    ) public returns (bool) {
        require(isAllowedManipulator[msg.sender], "only allowed manipulator");
        require(isRegisteredToken[tokenStr], "not registered token");
        IERC20 erc20 = IERC20(erc20OfTokenName[tokenStr]);
        return erc20.approve(msg.sender, value);
    }

    function depositETH(string memory fromAddress) public payable {
        if (ethAddressOfUser[fromAddress] == address(0)) {
            ethAddressOfUser[fromAddress] = payable(msg.sender);
        } else if (ethAddressOfUser[fromAddress] != msg.sender) {
            revert("only register eth address user can make new deposits");
        }
        IWETH weth = IWETH(erc20OfTokenName[ETH_NAME]);
        uint oldWethValue = weth.balanceOf(address(this));
        weth.deposit{value: msg.value}();
        require(
            weth.balanceOf(address(this)) == oldWethValue + msg.value,
            "the balance of weth is invalid"
        );
        balanceOfUser[fromAddress][ETH_NAME] += msg.value;
    }

    function depositERC20(
        string memory fromAddress,
        string calldata tokenName,
        uint amount
    ) public {
        require(isRegisteredToken[tokenName], "not registered token");
        if (ethAddressOfUser[fromAddress] == address(0)) {
            ethAddressOfUser[fromAddress] = payable(msg.sender);
        } else if (ethAddressOfUser[fromAddress] != msg.sender) {
            revert("only register eth address user can make new deposits");
        }
        IERC20 token = IERC20(erc20OfTokenName[tokenName]);
        token.transferFrom(msg.sender, address(this), amount);
        balanceOfUser[fromAddress][tokenName] += amount;
    }

    function process(
        uint manipulationId,
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) public {
        require(msg.sender == aggregator, "only aggregator");
        require(manipulationId <= numManipulations, "invalud manipulation ID");
        IManipulator ml = manipulationOfId[manipulationId];
        require(ml.verifyWrap(param, acc, proof), "invalid proof");
        IManipulator.RetrievedData memory data = ml.retrieveData(param);
        bytes32 headerHash = data.headerHash;
        require(isUsedEmailHash[headerHash] == false, "already used email");
        require(
            data.manipulationId == manipulationId,
            "Extracted Id is not equal to the specified manipulationId."
        );
        require(
            keccak256(bytes(data.toAddress)) ==
                keccak256(bytes(aggregatorToAddress)),
            "invalid to email address"
        );
        require(
            keccak256(data.publicKey) == validPublicKeyHash,
            "invalid public key"
        );
        string memory fromAddress = data.fromAddress;
        require(
            ethAddressOfUser[fromAddress] != address(0),
            "not registered user"
        );
        require(
            balanceOfUser[fromAddress][ETH_NAME] >= fixedFee,
            "not sufficient balance"
        );
        balanceOfUser[fromAddress][ETH_NAME] -= fixedFee;
        balanceOfUser[aggregatorToAddress][ETH_NAME] += fixedFee;
        ml.process(param);
        // (bool success, bytes memory returnData) = address(ml).delegatecall(
        //     abi.encodeWithSignature(
        //         "process(bytes,bytes,bytes)",
        //         param,
        //         acc,
        //         proof
        //     )
        // );
        // if (!success) {
        //     if (returnData.length == 0) revert();
        //     assembly {
        //         revert(add(32, returnData), mload(returnData))
        //     }
        // }
        isUsedEmailHash[headerHash] = true;
        emit EmailProcessed(fromAddress, manipulationId, headerHash);
    }

    function withdrawETH(string memory fromAddress, uint amount) public {
        require(
            ethAddressOfUser[fromAddress] == msg.sender,
            "invalid msg sender"
        );
        require(
            balanceOfUser[fromAddress][ETH_NAME] >= amount,
            "not sufficient balance"
        );
        balanceOfUser[fromAddress][ETH_NAME] -= amount;
        IWETH weth = IWETH(erc20OfTokenName[ETH_NAME]);
        uint oldWethValue = weth.balanceOf(address(this));
        weth.withdraw(amount);
        require(
            weth.balanceOf(address(this)) + amount == oldWethValue,
            "the balance of weth is invalid"
        );
        payable(msg.sender).transfer(amount);
    }

    function withdrawERC20(
        string memory fromAddress,
        string calldata tokenName,
        uint amount
    ) public {
        require(
            ethAddressOfUser[fromAddress] == msg.sender,
            "invalid msg sender"
        );
        require(isRegisteredToken[tokenName], "not registered token");
        require(
            balanceOfUser[fromAddress][tokenName] >= amount,
            "not sufficient balance"
        );
        balanceOfUser[fromAddress][tokenName] -= amount;
        IERC20 token = IERC20(erc20OfTokenName[tokenName]);
        require(
            token.transferFrom(address(this), msg.sender, amount),
            "failed transfer"
        );
    }

    function destructWallet() public {
        require(msg.sender == aggregator, "only aggregator");
        IERC20 weth = IERC20(erc20OfTokenName[ETH_NAME]);
        require(
            weth.balanceOf(address(this)) == 0,
            "All WETH must be withdrawn."
        );
        require(address(this).balance == 0, "The balance is not zero");
        selfdestruct(aggregator);
    }

    receive() external payable {}

    fallback() external payable {}
}
