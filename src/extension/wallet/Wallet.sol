// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../IExtension.sol";
import "../ExtensionHelper.sol";
import "./TokenRegistry.sol";

contract Wallet is IExtension {
    using ExtensionHelper for *;
    using Strings for address;

    struct ExecuteParams {
        ExtensionHelper.StringType opType;
        ExtensionHelper.DecimalType amount;
        ExtensionHelper.StringType currency;
        ExtensionHelper.AddressType recipient;
    }

    string public constant COMMAND = "wallet";
    string public constant OP_TRANSFER = "transfer";
    bytes32 public constant OP_TRANSFER_HASH = keccak256(bytes(OP_TRANSFER));
    string public constant OP_DEPOSIT = "deposit";
    bytes32 public constant OP_DEPOSIT_HASH = keccak256(bytes(OP_DEPOSIT));
    string public constant OP_WITHDRAW = "withdraw";
    bytes32 public constant OP_WITHDRAW_HASH = keccak256(bytes(OP_WITHDRAW));
    TokenRegistry public tokenRegistry;

    constructor(address _tokenRegistry) {
        tokenRegistry = TokenRegistry(_tokenRegistry);
    }

    function commandName() public pure returns (string memory) {
        return COMMAND;
    }

    function buildSubject(
        bytes memory extensionParams
    ) public pure returns (string memory) {
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        bytes32 opTypeHash = keccak256(bytes(params.opType.toString()));
        if (opTypeHash == OP_TRANSFER_HASH) {
            require(
                params.recipient.isEmailAddr,
                "recipient must be the email address if opType==OP_TRANSFER."
            );
        } else if (
            opTypeHash == OP_DEPOSIT_HASH || opTypeHash == OP_WITHDRAW_HASH
        ) {
            require(
                !params.recipient.isEmailAddr,
                "recipient must not be the email address if opType is OP_DEPOSIT or OP_WITHDRAW."
            );
        } else {
            require(false, "Not supported opType.");
        }
        string memory subject = string.concat(
            params.opType.toString(),
            " ",
            params.amount.toString(),
            " ",
            params.currency.toString()
        );
        if (opTypeHash == OP_DEPOSIT_HASH) {
            subject = string.concat(subject, " from ");
        } else {
            subject = string.concat(subject, " to ");
        }
        subject = string.concat(subject, params.recipient.toString());
        return subject;
    }

    function execute(address subjectAddr, bytes memory extensionParams) public {
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        address sender = msg.sender;
        IERC20Metadata token = IERC20Metadata(
            tokenRegistry.getTokenOfSymbol(params.currency.toString())
        );
        uint256 decimals = uint(token.decimals());
        uint256 amount = params.amount.intPart *
            10 ** decimals +
            params.amount.decimalPart *
            10 ** (decimals - 1 - params.amount.decNumZero);
        bytes32 opTypeHash = keccak256(bytes(params.opType.toString()));
        if (opTypeHash == OP_TRANSFER_HASH) {
            require(
                token.allowance(sender, address(this)) >= amount,
                "Not sufficient allowance"
            );
            token.transferFrom(sender, subjectAddr, amount);
        } else if (opTypeHash == OP_DEPOSIT_HASH) {
            require(
                token.allowance(params.recipient.value, address(this)) >=
                    amount,
                "Not sufficient allowance"
            );
            token.transferFrom(params.recipient.value, sender, amount);
        } else if (opTypeHash == OP_WITHDRAW_HASH) {
            require(
                token.allowance(sender, address(this)) >= amount,
                "Not sufficient allowance"
            );
            token.transferFrom(sender, params.recipient.value, amount);
        }
        string memory eventMsg = buildSubject(extensionParams);
        if (opTypeHash == OP_TRANSFER_HASH) {
            eventMsg = string.concat(eventMsg, subjectAddr.toHexString());
        }
        emit Executed(COMMAND, eventMsg, msg.sender);
    }
}
