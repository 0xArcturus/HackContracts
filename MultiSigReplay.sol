// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";


//to prevent a signature replay attack we create a nonce, that is introduced in the hash, and therefore transactions have a count and cannot be sent
//several times
//to prevent a sig replay attack we also introduce a mapping that relates txHashes with a bool, therefore no tx with the exact same hash can be reproduced. 

//with these two systems a user can select a nonce for the transaction, if in the future he wants to do the exact same transaction he will add 1 to the nonce
//and that tx will be not replayable

//lastly we add address(this) to the hash inputs to check that the transaction is only valid for this address, and cannot be replicated in other contracts with the same bytecode.

//the user can now execute getTxHash with the desired inputs. He will pass that hash to the other owner,
// call an offchain method to sign the tx, and request the signed message from the other owner
//introduce the tx inputs in the transfer function, and the signatures from the owners, and the tx will succesfully be called.
contract MultiSigWallet {
    using ECDSA for bytes32;

    address[2] public owners;
    mapping(bytes32 => bool) public executed;

    constructor(address[2] memory _owners) public payable {
        owners = _owners;
    }

    function deposit() external payable {}

    function transfer(address to, uint amount, uint nonce, bytes[2] memory sigs) external {
        bytes32 txHash = getTxHash(to, amount, nonce);

        //if true it will execute the transaciton in one single call
        require(checkSigs(sigs, txHash), "invalid sig");
        require(!executed[txHash], "tx executed")

        (bool sent, ) = to.call{value: amount}("");

        require(sent, "failed to send ether");
        executed[txHash] = true;
    }

    function getTxHash(address to, uint amount, uint nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this),to, amount, nonce));
    }

    function checkSigs(
        bytes[2] memory sigs,
        bytes32 txHash
    ) private view returns (bool) {
        //it first signs the txHash
        bytes32 ethSignedHash = txHash.toEthSignedMessageHash();
        //if the signer of the signedTxHash recovered by the ECDSA function recover matches any owner, it returns true
        for (uint i = 0; i < sigs.length; i++) {
            address signer = ethSignedHash.recover(sigs[i]);
            bool valid = signer == owners[i];

            if (!valid) {
                return false;
            }

            return true;
        }
    }
}
