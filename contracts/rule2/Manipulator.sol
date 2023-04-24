// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "../interfaces/IUniswapV3Router.sol";
import "../interfaces/IERC20.sol";

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
        0xE592427A0AEce92De3Edee1F18E0157C05861564;

    ISwapRouter private router = ISwapRouter(UNISWAP_V2_ROUTER);
    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

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
        IERC20 tokenIn = IERC20(erc20OfTokenName[tokenStrIn]);
        IERC20 tokenOut = IERC20(erc20OfTokenName[tokenStrOut]);
        console.log(
            "Router DAI balance %s",
            tokenOut.balanceOf(UNISWAP_V2_ROUTER)
        );
        uint decimals = uint(tokenIn.decimals());
        uint amountIn = param.substr0IntPart *
            10 ** decimals +
            param.substr0DecimalPart *
            10 ** (decimals - 1 - param.substr0DecNumZero);
        require(balanceOfUser[param.fromAddressString][tokenStrIn] >= amountIn);
        balanceOfUser[param.fromAddressString][tokenStrIn] -= amountIn;
        require(tokenIn.approve(UNISWAP_V2_ROUTER, amountIn), "approve failed");
        ISwapRouter.ExactInputSingleParams memory swapParams = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: address(tokenIn),
                tokenOut: address(tokenOut),
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // uint amountOut = router.exactInputSingle(swapParams);

        // reference: https://cryptomarketpool.com/how-to-swap-tokens-on-uniswap-using-a-smart-contract/
        // address[] memory path;
        // address wethAddress = erc20OfTokenName[ETH_NAME];
        // if (
        //     address(tokenIn) == wethAddress || address(tokenOut) == wethAddress
        // ) {
        //     path = new address[](2);
        //     path[0] = address(tokenIn);
        //     path[1] = address(tokenOut);
        // } else {
        //     path = new address[](3);
        //     path[0] = address(tokenIn);
        //     path[1] = wethAddress;
        //     path[2] = address(tokenOut);
        // }
        // uint amountOutMin = router.getAmountsOut(amountIn, path)[
        //     path.length - 1
        // ];
        // uint amountOut = router.swapExactTokensForTokens(
        //     amountIn,
        //     0,
        //     path,
        //     address(this),
        //     block.timestamp
        // )[path.length - 1];
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
