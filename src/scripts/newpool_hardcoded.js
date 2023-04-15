
const { ethers } = require("hardhat");

const positionManager = await ethers.getContractAt('INonfungiblePositionManager', "0x650824EaddD2d12cb918286b1B2Dd9F66726961d");
const tRIF = await ethers.getContractAt('IERC20', "0x19F64674D8A5B4E652319F5e239eFd3bc969A1fE");
const SOV = await ethers.getContractAt('IERC20', "0x6a9A07972D07e58F0daf5122d11E069288A375fb");
// call approve for tokens before adding a new pool
await tRIF.connect(deployer).approve(positionManager.address, ethers.utils.parseEther('34'), {gasPrice: 0});
await SOV.connect(deployer).approve(positionManager.address, ethers.utils.parseEther('6'), {gasPrice: 0});
let multiCallParams = [
// first call
"0x13ead562" + // encoded function signature ( createAndInitializePoolIfNecessary(address, address, uint24, uint160) )
"000000000000000000000000" + tRIF.address.toLowerCase().substring(2) + // token1 address
"000000000000000000000000" +  SOV.address.toLowerCase().substring(2) + // token2 address
"00000000000000000000000000000000000000000000000000000000000001f4" + // fee
"000000000000000000000000000000000000000005b96aabfac7cdc4b3b58fc2", // sqrtPriceX96
// second call
"0x88316456" + // encoded function signature ( mint((address,address,uint24,int24,int24,uint256,uint256,uint256,uint256,address,uint256)) )
"000000000000000000000000" + tRIF.address.toLowerCase().substring(2) + // token1 address
"000000000000000000000000" +  SOV.address.toLowerCase().substring(2) + // token2 address
"00000000000000000000000000000000000000000000000000000000000001f4" + // fee
"fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff89f0e" + // tick lower
"0000000000000000000000000000000000000000000000000000000000010dd8" + // tick upper
"00000000000000000000000000000000000000000000000ad5a4b6712c4647c3" + // amount 1 desired
"000000000000000000000000000000000000000000000000016345785d8a0000" + // amount 2 desired
"00000000000000000000000000000000000000000000000acebaf563cd50439c" + // min amount 1 expected
"000000000000000000000000000000000000000000000000016261cfc3291456" + // min amount 2 expected 
"000000000000000000000000" + signer3.address.toLowerCase().substring(2) + // deployer address "00000000000000000000000000000000000000000000000000000000610bb8b6" // deadline
];
// adding a new liquidity pool through position manager
await positionManager.connect(deployer).multicall(multiCallParams, {gasPrice: 0});