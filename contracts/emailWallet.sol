// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./interfaces/manipulator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "./emailVerifier.sol";

contract EmailWallet {
    address payable aggregator;
    string aggregatorToAddress;
    uint numRules;
    uint numTokens;
    uint fixedFee;
    mapping(string => uint) ethBalanceOfUser;
    mapping(string => address payable) ethAddressOfUser;
    mapping(string => mapping(string => uint)) erc20BalanceOfUser;
    mapping(string => bool) isUsedEmailHash;
    mapping(uint => IManipulator) manipulatorOfRuleId;
    mapping(string => ERC20) erc20OfTokenName;
    mapping(string => bool) isRegisteredToken;

    string constant ETH_NAME = "ETH";

    constructor(
        string memory _aggregatorToAddress,
        uint _fixedFee,
        address[] memory _manipulatorAddresses,
        string[] memory _tokenNames,
        address[] memory _erc20Addresses
    ) {
        aggregator = payable(msg.sender);
        aggregatorToAddress = _aggregatorToAddress;
        numRules = 0;
        fixedFee = _fixedFee;
        numRules = _manipulatorAddresses.length;
        for (uint i = 0; i < _manipulatorAddresses.length; i++) {
            manipulatorOfRuleId[i] = IManipulator(_manipulatorAddresses[i]);
        }
        numTokens = _tokenNames.length;
        require(
            _tokenNames.length == _erc20Addresses.length,
            "tokens length must be equal"
        );
        for (uint i = 0; i < _tokenNames.length; i++) {
            erc20OfTokenName[_tokenNames[i]] = ERC20(_erc20Addresses[i]);
            isRegisteredToken[_tokenNames[i]] = true;
        }
    }

    function depositETH(string memory fromAddress) public payable {
        if (ethAddressOfUser[fromAddress] == address(0)) {
            ethAddressOfUser[fromAddress] = payable(msg.sender);
        } else if (ethAddressOfUser[fromAddress] != msg.sender) {
            revert("only register eth address user can make new deposits");
        }
        ethBalanceOfUser[fromAddress] += msg.value;
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
        ERC20 token = erc20OfTokenName[tokenName];
        token.transferFrom(msg.sender, address(this), amount);
        erc20BalanceOfUser[fromAddress][tokenName] += amount;
    }

    function process(
        uint ruleId,
        bytes calldata paramsBytes,
        bytes calldata acc,
        bytes calldata proof
    ) public {
        require(ruleId < numRules, "invalud rule ID");
        IManipulator ml = manipulatorOfRuleId[ruleId];
        require(ml.verifyBatch(paramsBytes, acc, proof), "proof is invalid");
        string[] memory bodyHashes = ml.retrieveBodyHashes(paramsBytes);
        for (uint i = 0; i < bodyHashes.length; i++) {
            require(
                isUsedEmailHash[bodyHashes[i]] == false,
                "already used email"
            );
        }
        string[] memory fromAddresses = ml.retrieveFromAddresses(paramsBytes);
        require(
            fromAddresses.length == bodyHashes.length,
            "The lengthes of fromAddresses and bodyHashes must be equal"
        );
        string[] memory toAddresses = ml.retrieveToAddresses(paramsBytes);
        require(
            toAddresses.length == bodyHashes.length,
            "The lengthes of toAddresses and bodyHashes must be equal"
        );
        for (uint i = 0; i < fromAddresses.length; i++) {
            require(
                ethAddressOfUser[fromAddresses[i]] != address(0),
                "not registered user"
            );
            require(
                ethBalanceOfUser[fromAddresses[i]] >= fixedFee,
                "not sufficient balance"
            );
            ethBalanceOfUser[fromAddresses[i]] -= fixedFee;
            aggregator.transfer(fixedFee);
        }
        uint[] memory ids = ml.retrieveManipulationIds(paramsBytes);
        require(
            ids.length == bodyHashes.length,
            "The lengthes of ids and bodyHashes must be equal"
        );
        for (uint i = 0; i < ids.length; i++) {
            require(ids[i] == ruleId, "Extracted Id must be the ruleId");
        }
        (bool success, ) = address(ml).delegatecall(
            abi.encodeWithSignature("processBatch(bytes calldata)", paramsBytes)
        );
        require(success, "Manipulation failed");
        // ml.processBatch(paramsBytes);
        for (uint i = 0; i < bodyHashes.length; i++) {
            isUsedEmailHash[bodyHashes[i]] = true;
        }
    }

    function withdrawETH(string memory fromAddress, uint amount) public {
        require(
            ethAddressOfUser[fromAddress] == msg.sender,
            "invalid msg sender"
        );
        require(
            ethBalanceOfUser[fromAddress] >= amount,
            "not sufficient balance"
        );
        ethBalanceOfUser[fromAddress] -= amount;
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
            erc20BalanceOfUser[fromAddress][tokenName] >= amount,
            "not sufficient balance"
        );
        erc20BalanceOfUser[fromAddress][tokenName] -= amount;
        ERC20 token = erc20OfTokenName[tokenName];
        token.transferFrom(address(this), msg.sender, amount);
    }
}
