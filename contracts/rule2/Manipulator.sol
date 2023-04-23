// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "../interfaces/IUniswapV2Router.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// reference: https://solidity-by-example.org/defi/uniswap-v2/
contract Manipulator is IManipulator, VerifierWrapper {
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
    bytes32 validPublicKeyHash;

    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    IUniswapV2Router01 private router = IUniswapV2Router01(UNISWAP_V2_ROUTER);

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
        string memory tokenStrIn = param.substr1String;
        string memory tokenStrOut = param.substr2String;
        require(
            isRegisteredToken[tokenStrIn] && isRegisteredToken[tokenStrOut],
            "not registered token"
        );
        ERC20 tokenIn = ERC20(erc20OfTokenName[tokenStrIn]);
        ERC20 tokenOut = ERC20(erc20OfTokenName[tokenStrOut]);
        uint decimalsIn = uint(tokenIn.decimals());
        uint amountIn = param.substr0IntPart *
            10 ** decimalsIn +
            param.substr0DecimalPart *
            10 ** (decimalsIn - 1);
        require(balanceOfUser[param.fromAddressString][tokenStrIn] >= amountIn);
        balanceOfUser[param.fromAddressString][tokenStrIn] -= amountIn;
        require(tokenIn.approve(UNISWAP_V2_ROUTER, amountIn), "approve failed");
        // reference: https://cryptomarketpool.com/how-to-swap-tokens-on-uniswap-using-a-smart-contract/
        address[] memory path;
        address wethAddress = erc20OfTokenName[ETH_NAME];
        if (
            address(tokenIn) == wethAddress || address(tokenOut) == wethAddress
        ) {
            path = new address[](2);
            path[0] = address(tokenIn);
            path[1] = address(tokenOut);
        } else {
            path = new address[](3);
            path[0] = address(tokenIn);
            path[1] = wethAddress;
            path[2] = address(tokenOut);
        }
        (bool success, bytes memory returnData) = UNISWAP_V2_ROUTER.call(
            abi.encodeWithSignature("factory()")
        );
        console.log(
            "success %s, return %s",
            success,
            uint160(bytes20(returnData))
        );
        if (!success) {
            if (returnData.length == 0) revert();
            assembly {
                revert(add(32, returnData), mload(returnData))
            }
        }
        console.log("factory %s", router.factory());
        console.log("ok");
        uint[] memory amountOutMins = router.getAmountsOut(amountIn, path);
        // uint amountOutMin = amountOutMins[path.length - 1];
        // console.log("ok");
        // console.log("amountOutMin %s", amountOutMin);
        // uint amountOut = router.swapExactTokensForTokens(
        //     amountIn,
        //     amountOutMin,
        //     path,
        //     address(this),
        //     block.timestamp
        // )[path.length - 1];
        // console.log("ok");
        // balanceOfUser[param.fromAddressString][tokenStrOut] += amountOut;
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
