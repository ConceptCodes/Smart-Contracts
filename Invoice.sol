// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Invoice {
    uint dueDate;
    uint amount;
    address serviceProvider;

    constructor(uint _amount) public {
        dueDate = block.timestamp + 200;
        amount = _amount;
        serviceProvider = msg.sender;
    }

    fallback() payable external {
        require(msg.value == amount, "incorrect invoice amount");
    }

    function withdraw() public {
        require(msg.sender == serviceProvider, "only service provider can withdraw funds");
        require(block.timestamp > dueDate, "due date has not been reached");
        msg.sender.transfer(address(this).balance);
    }

    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }

}