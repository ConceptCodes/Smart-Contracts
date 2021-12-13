// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

/// @title Family Trust
/// @author concept
/// @notice simple implementation of creating a trust for your kids, more advance version will have voting rights
contract Trust is Ownable{ 
    struct Child { 
        uint256 amt;
        uint maturity;
        bool paid;
    }

    mapping(address => Kid) public children;

    modifier hasNotBeenPaid(address _child) {
        require(children[_child].paid == false, "Child has already been paid");
        _;
    }

    constructor() Ownable() { }

    function addChild(address _child, uint256 _timeToMaturity) external payable onlyOwner {
        require(children[_child].amt == 0, "Child already exists");
        children[_child] = Child(msg.value, block.timestamp + _timeToMaturity, false);
    }

    function increaseFundsforChild(address _child, uint256 _amt) external payable onlyOwner hasNotBeenPaid(_child) {
        require(children[_child].maturity >= block.timestamp, "Child has reached maturity already");
        children[_child].amt += _amt;
    }

    function withdraw() external hasNotBeenPaid(msg.sender) {
        Child storage _child = children[msg.sender];
        require(_child.maturity <= block.timestamp, "Child has not reached maturity yet");
        require(_child.amt > 0, "Child doesn't have any funds to withdraw");
       (bool success, ) = payable(msg.sender).transfer(_child.amt);
       require(success, "withdraw was unsuccessful");
        _child.paid = true;
    }
}