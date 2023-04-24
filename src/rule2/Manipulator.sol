// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./VerifierWrapper.sol";
import "../interfaces/IManipulator.sol";
import "../interfaces/IUniswapV3Router.sol";
import "../interfaces/IERC20.sol";
import "forge-std/console.sol";
import "../EmailWallet.sol";

// reference: https://solidity-by-example.org/defi/uniswap-v2/
contract Rule2Manipulator is IManipulator, Rule2VerifierWrapper {
    address private constant UNISWAP_V3_ROUTER =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter private router = ISwapRouter(UNISWAP_V3_ROUTER);

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;
    EmailWallet wallet;

    constructor(
        address _verifier,
        address _wallet
    ) Rule2VerifierWrapper(_verifier) {
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
        string memory tokenStrIn = param.substr1String;
        string memory tokenStrOut = param.substr2String;
        require(
            wallet.isRegisteredToken(tokenStrIn) &&
                wallet.isRegisteredToken(tokenStrOut),
            "not registered token"
        );
        IERC20 tokenIn = IERC20(wallet.erc20OfTokenName(tokenStrIn));
        IERC20 tokenOut = IERC20(wallet.erc20OfTokenName(tokenStrOut));
        uint decimals = uint(tokenIn.decimals());
        uint amountIn = param.substr0IntPart *
            10 ** decimals +
            param.substr0DecimalPart *
            10 ** (decimals - 1 - param.substr0DecNumZero);
        uint curBalanceIn = wallet.balanceOfUser(
            param.fromAddressString,
            tokenStrIn
        );
        require(curBalanceIn >= amountIn);
        wallet.manipulateBalanceOfUser(
            param.fromAddressString,
            tokenStrIn,
            curBalanceIn - amountIn
        );
        require(
            wallet.approveERC20(tokenStrIn, amountIn),
            "approve from wallet to manipulator failed"
        );
        require(
            tokenIn.transferFrom(address(wallet), address(this), amountIn),
            "transfer from wallet to manipulator failed"
        );
        require(
            tokenIn.approve(address(router), amountIn),
            "approve from manipulator to router failed"
        );
        ISwapRouter.ExactInputSingleParams memory swapParams = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: address(tokenIn),
                tokenOut: address(tokenOut),
                fee: poolFee,
                recipient: address(wallet),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

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
        wallet.manipulateBalanceOfUser(
            param.fromAddressString,
            tokenStrOut,
            wallet.balanceOfUser(param.fromAddressString, tokenStrOut) +
                router.exactInputSingle(swapParams)
        );
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
