//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;
/**
    @dev a buy now pay later contract
 */
contract Sezzle {
    uint256 public amount;
    uint256 public duration;

    constructor(uint256  _amount, uint256  _duration) {
        amount = _amount;
        duration = _duration;
    }

    /**
        @dev shows the total amount of the product
     */
    function totalAmount() public view returns(uint256) { 
        return amount;
    }

    /**
        @dev shows the minimal payment amount
     */
    function chunkedPayment() public view returns(uint256) { 
        return amount / duration;
    }

    /**
        @dev allows user to make the minimal payment for item
     */
    function makeChunkPayment() public payable {

    }
}