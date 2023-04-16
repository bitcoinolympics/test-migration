// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DirectSwapOnPool is IUniswapV3SwapCallback {
    IUniswapV3Pool internal immutable pool = IUniswapV3Pool(0x2aC9B2F7f7ac9BFBdf206228E3D4D3cDB618557e);

    address public constant SOV = 0x6a9A07972D07e58F0daf5122d11E069288A375fb;
    address public constant rDOC = 0xC3De9F38581f83e281f260d0DdbaAc0e102ff9F8;
    uint24 public constant feeTier = 3000;

    /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_SQRT_RATIO = 4295128739;
    /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

    address payable internal  owner;

    constructor() {
        owner = payable(msg.sender);
    }

    event CallbackReceived(int256 amount0Delta, int256 amount1Delta, address sender);
    event Decoded(address token0, uint24 fee, address token1);


    function directSwap(bool zeroForOne, int256 amount) external payable returns (int256 amount0, int256 amount1) {

        ( bool success, bytes memory data) =
            msg.sender.call(abi.encodeWithSelector(IERC20.approve.selector, address(this), amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');

        ( success, data) = SOV.call(abi.encodeWithSelector(IERC20.approve.selector, address(pool), amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');

        bytes memory callbackData = abi.encodePacked(SOV, feeTier, rDOC);
        uint160 sqrt = (zeroForOne ? MIN_SQRT_RATIO + 1 : MAX_SQRT_RATIO - 1);
        return pool.swap(msg.sender, zeroForOne, amount, sqrt, callbackData);
    }

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external override {
        emit CallbackReceived(amount0Delta, amount1Delta, msg.sender);
        (address token0, uint24 fee, address token1) = abi.decode(data, (address, uint24, address));
        emit Decoded(token0, fee, token1);
        if (amount0Delta > 0)
            IERC20(IUniswapV3Pool(msg.sender).token0()).transferFrom(owner, msg.sender, uint256(amount0Delta));
        else IERC20(IUniswapV3Pool(msg.sender).token0()).transferFrom(msg.sender, owner, uint256(amount0Delta));
        if (amount1Delta > 0)
            IERC20(IUniswapV3Pool(msg.sender).token1()).transferFrom(owner, msg.sender, uint256(amount1Delta));
        else IERC20(IUniswapV3Pool(msg.sender).token1()).transferFrom(msg.sender, owner, uint256(amount1Delta));
    }

}