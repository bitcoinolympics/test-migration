// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.4.18;

contract WrapEther {
    
    address internal WETH = 0xD89c1432EaA169C54dC7610C744c68a2F4b6B3e5;

    function wrapEther(uint256 amount) public  payable {

        //create WETH from ETH
        if (amount > 0) {
            IWETH(WETH).deposit.value(amount)();
            IWETH(WETH).transfer(msg.sender, amount);
        }
    }
}

interface IWETH {
  function() external  payable;

  function deposit() external  payable;

  function withdraw(uint256 wad) external;

  function transfer(address dst, uint wad) external  returns (bool);
}