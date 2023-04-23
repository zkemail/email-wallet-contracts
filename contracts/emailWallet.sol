// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./interfaces/IManipulator.sol";
import "./interfaces/IWETH.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "./emailVerifier.sol";

contract EmailWallet {
    address verifier;
    mapping(string => address payable) public ethAddressOfUser;
    mapping(string => mapping(string => uint)) public balanceOfUser;
    mapping(bytes32 => bool) public isUsedEmailHash;
    mapping(uint => IManipulator) public manipulatorOfRuleId;
    mapping(string => address) public erc20OfTokenName;
    mapping(string => bool) public isRegisteredToken;

    string constant ETH_NAME = "ETH";

    address payable aggregator;
    string aggregatorToAddress;
    uint numRules;
    uint numTokens;
    uint fixedFee;
    bytes32 validPublicKeyHash; // Here we fix our public key to the gmail one.

    constructor(
        string memory _aggregatorToAddress,
        uint _fixedFee,
        bytes memory _publicKey,
        address[] memory _manipulatorAddresses,
        string[] memory _tokenNames,
        address[] memory _erc20Addresses,
        address _wethAddress
    ) {
        aggregator = payable(msg.sender);
        aggregatorToAddress = _aggregatorToAddress;
        numRules = _manipulatorAddresses.length;
        fixedFee = _fixedFee;
        validPublicKeyHash = keccak256(_publicKey);
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
            erc20OfTokenName[_tokenNames[i]] = _erc20Addresses[i];
            isRegisteredToken[_tokenNames[i]] = true;
        }
        erc20OfTokenName[ETH_NAME] = _wethAddress;
        isRegisteredToken[ETH_NAME] = true;
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
        ERC20 token = ERC20(erc20OfTokenName[tokenName]);
        token.transferFrom(msg.sender, address(this), amount);
        balanceOfUser[fromAddress][tokenName] += amount;
    }

    function process(
        uint manipulationId,
        bytes calldata param,
        bytes calldata acc,
        bytes calldata proof
    ) public {
        require(manipulationId <= numRules, "invalud rule ID");
        IManipulator ml = manipulatorOfRuleId[manipulationId - 1];
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
        (bool success, bytes memory returnData) = address(ml).delegatecall(
            abi.encodeWithSignature(
                "process(bytes,bytes,bytes)",
                param,
                acc,
                proof
            )
        );
        if (!success) {
            if (returnData.length == 0) revert();
            assembly {
                revert(add(32, returnData), mload(returnData))
            }
        }
        isUsedEmailHash[headerHash] = true;
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
        ERC20 token = ERC20(erc20OfTokenName[tokenName]);
        token.transferFrom(address(this), msg.sender, amount);
    }
}
