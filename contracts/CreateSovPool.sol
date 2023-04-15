// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CreateSovPool {
    IUniswapV3Factory internal immutable factory = IUniswapV3Factory(0x645eaefA3dfE93b6140e4AB68113f56Fb1910Ca8);
    IUniswapV3Pool internal immutable deployedPool = IUniswapV3Pool(payable(0x21093aBe69592271272bf4d59FA771cB6B4E92bF));

    address public constant tRIF = 0x19F64674D8A5B4E652319F5e239eFd3bc969A1fE;
    address public constant SOV = 0x6a9A07972D07e58F0daf5122d11E069288A375fb;
    address public constant rDOC = 0xC3De9F38581f83e281f260d0DdbaAc0e102ff9F8;
    uint24 public constant feeTier = 3000;

    address internal owner;

    constructor() {
        owner = msg.sender;
    }

    event PoolCreated(address indexed poolAddr);

    function createTRIFSOVPool() external returns (address addr) {
        address pool = factory.createPool(tRIF, SOV, feeTier);
        emit PoolCreated(pool);
        return pool;
    }

    function createSOVRDOCPool() external returns (address addr) {
        address pool = factory.createPool(SOV, rDOC, feeTier);
        emit PoolCreated(pool);
        return pool;
    }


    function createRDOCSOVPool() external returns (address addr) {
        address pool = factory.createPool(rDOC, SOV, feeTier);
        emit PoolCreated(pool);
        return pool;
    }



    function getPool(address t0, address t1) public  view returns (address addr) {
        return factory.getPool(t0, t1, feeTier);
    }

    function getSlot0(address poolAddr) external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked) {
        return IUniswapV3Pool(poolAddr).slot0();
    }

    function initPool(address poolAddr, uint160 val) external {
        IUniswapV3Pool(poolAddr).initialize(val);/*33076711533436630000000000000*/
    }

    function mintPosition(address poolAddr, int24 tickLower, int24 tickUpper, uint128 amount, bytes calldata data) external {

        IUniswapV3Pool(poolAddr).mint(msg.sender, tickLower, tickUpper, amount, data);
    }

    event MintCallback(uint256 amount0Owed, uint256 amount1Owed);


    function uniswapV3MintCallback(
        uint256 amount0Owed,
        uint256 amount1Owed,
        bytes calldata
    ) external {
            emit MintCallback(amount0Owed, amount1Owed);
            (bool success, bytes memory data) = IUniswapV3Pool(msg.sender).token0().call(abi.encodeWithSelector(IERC20.approve.selector, msg.sender, amount0Owed));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');

            (success, data) = IUniswapV3Pool(msg.sender).token1().call(abi.encodeWithSelector(IERC20.approve.selector, msg.sender, amount1Owed));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');
            if (amount0Owed > 0)
                IERC20(IUniswapV3Pool(msg.sender).token0()).transferFrom(owner, msg.sender, amount0Owed);
            if (amount1Owed > 0)
                IERC20(IUniswapV3Pool(msg.sender).token1()).transferFrom(owner, msg.sender, amount1Owed);
    }
}