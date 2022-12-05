// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//A contract that can be activated when sent any ether to selfdestruct,
//therefore forcing any ether to be sent to a contract without recieve
contract Autodestruct {
    receive() external payable {
        address payable addr = payable(
            address(0x2abc76ab66503eeb2d1f3C086C63B644761bfD12)
        );
        selfdestruct(addr);
    }
}
