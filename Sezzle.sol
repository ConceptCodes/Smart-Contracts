//SPDX-License-Identifier: MIT 


pragma solidity ^0.8.0;
/**
    @title Sezzle
    @dev this is a simple buy now pay later smart contract
 */
contract Sezzle {
    event Received(uint value);
    uint256 public amount;
    uint256 public duration;
    uint256 public paymentAmount;
    address owner;

    constructor(uint256  _amount, uint256  _duration) {
        require(msg.sender.balance > _amount, "You don't have enough to buy the item outright");
        amount = _amount;
        duration = _duration;
        paymentAmount = _amount / _duration;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function."); 
        _; 
    }

    /**
        @dev allow owner to withdraw funds
     */

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    /**
        @dev show balance of smart contract
     */
    function getBalance() public onlyOwner view  returns (uint256) {
        return address(this).balance;
    }

    /**
        @dev auto deduct payment
     */
    function makePayment() payable public {
        require(msg.value >= paymentAmount, "You need more than the minimal payment");
        
    }

}