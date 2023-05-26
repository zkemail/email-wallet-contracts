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

    function queryDecomposedRegexes()
        public
        pure
        returns (DecomposedRegex[] memory)
    {
        DecomposedRegex[] memory regexes;
        regexes[0] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            "my balance of "
        );
        regexes[1] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat("(", ExtensionHelper.CAPITAL_ALPHABET, ")+")
        );
        return regexes;
    }

    function executeDecomposedRegexes()
        public
        pure
        returns (DecomposedRegex[] memory)
    {
        DecomposedRegex[] memory regexes;
        regexes[0] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat(
                "(",
                OP_TRANSFER,
                "|",
                OP_DEPOSIT,
                "|",
                OP_WITHDRAW,
                ")"
            )
        );
        regexes[1] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            " "
        );
        regexes[2] = DecomposedRegex(
            true,
            ExtensionHelper.DECIMAL_TYPE_NAME,
            ""
        );
        regexes[3] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            " "
        );
        regexes[4] = DecomposedRegex(
            true,
            ExtensionHelper.STRING_TYPE_NAME,
            string.concat("(", ExtensionHelper.CAPITAL_ALPHABET, ")+")
        );
        regexes[5] = DecomposedRegex(
            false,
            ExtensionHelper.STRING_TYPE_NAME,
            " (to|from) "
        );
        regexes[6] = DecomposedRegex(
            true,
            ExtensionHelper.ADDRESS_TYPE_NAME,
            ""
        );
        return regexes;
    }

    function query(
        address accountAddr,
        bytes memory queryData
    ) public view returns (string memory) {
        string memory currency = abi.decode(queryData, (string));
        address tokenAddr = tokenRegistry.getTokenOfSymbol(currency);
        if (tokenAddr == address(0)) {
            return
                string.concat("ERROR: The token ", currency, "does not exist.");
        }
        IERC20Metadata token = IERC20Metadata(tokenAddr);
        uint256 balance = token.balanceOf(accountAddr);
        uint256 decimals = uint(token.decimals());
        uint256 intPart = balance / (10 ** decimals);
        uint256 decimalPart = balance - intPart * (10 ** decimals);
        uint256 decNumZero = decimals;
        for (uint idx = 0; idx < decimals; idx++) {
            if (decimalPart < 10 ** idx) {
                break;
            }
            decNumZero--;
        }
        ExtensionHelper.DecimalType memory decimal = ExtensionHelper
            .DecimalType(intPart, decNumZero, decimalPart);
        return
            string.concat("You have ", decimal.toString(), " ", currency, ".");
    }

    function buildSubject(
        bytes memory extensionParams
    ) public pure returns (string memory) {
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
        return buildSubject(params);
    }

    function execute(address subjectAddr, bytes memory extensionParams) public {
        ExecuteParams memory params = abi.decode(
            extensionParams,
            (ExecuteParams)
        );
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
            token.transfer(subjectAddr, amount);
        } else if (opTypeHash == OP_DEPOSIT_HASH) {
            require(
                token.allowance(params.recipient.value, address(this)) >=
                    amount,
                "Not sufficient allowance"
            );
            token.transferFrom(params.recipient.value, address(this), amount);
        } else if (opTypeHash == OP_WITHDRAW_HASH) {
            token.transfer(params.recipient.value, amount);
        }
        string memory eventMsg = buildSubject(params);
        if (opTypeHash == OP_TRANSFER_HASH) {
            eventMsg = string.concat(eventMsg, subjectAddr.toHexString());
        }
        emit Executed(COMMAND, eventMsg, address(this));
    }

    function buildSubject(
        ExecuteParams memory params
    ) public pure returns (string memory) {
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
}
