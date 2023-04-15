// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleSwap {
    ISwapRouter public immutable swapRouter = ISwapRouter(0xE9990801ABBCE8Ec4A1f0b12Ea2d972d6401959e);
    address public constant tRIF = 0x19F64674D8A5B4E652319F5e239eFd3bc969A1fE;
    address public constant SOV = 0x6a9A07972D07e58F0daf5122d11E069288A375fb;
    address public constant RBTC = 0xdF298421CB18740a7059b0Af532167fAA45e7A98;
    address public constant rDOC = 0xC3De9F38581f83e281f260d0DdbaAc0e102ff9F8;
    uint24 public constant feeTier = 3000;


    event Started();

    event Tranfered(address from, address to, uint256 amount);

    event Approved();

    function rifBalance() public view returns (uint256) {
        return ERC20(tRIF).balanceOf(msg.sender);
    }

    function swapTRIFforSOV(uint amountIn)
        external
        returns (uint256 amountOut)
    {
        emit Started();
        // Transfer the specified amount of tRIF to this contract.
        (bool success, bytes memory data) =
            tRIF.call(abi.encodeWithSelector(IERC20.transferFrom.selector, msg.sender, address(this), amountIn));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');

        emit Tranfered(msg.sender, address(this), amountIn);

        // Approve the router to spend tRIF.
        (success, data) = tRIF.call(abi.encodeWithSelector(IERC20.approve.selector, address(swapRouter), amountIn));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');

        emit Approved();

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tRIF,
                tokenOut: SOV,
                fee: feeTier,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
        return amountOut;
    }

    function swapRDOCforSOV(uint amountIn)
        external
        returns (uint256 amountOut)
    {
        // Transfer the specified amount of tRIF to this contract.
        (bool success, bytes memory data) =
            rDOC.call(abi.encodeWithSelector(IERC20.transferFrom.selector, msg.sender, address(this), amountIn));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');

        emit Tranfered(msg.sender, address(this), amountIn);

        // Approve the router to spend tRIF.
        (success, data) = rDOC.call(abi.encodeWithSelector(IERC20.approve.selector, address(swapRouter), amountIn));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: rDOC,
                tokenOut: SOV,
                fee: feeTier,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
        return amountOut;
    }
}
