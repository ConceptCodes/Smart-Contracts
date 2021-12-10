// SPDX-License-Identifier: MIT

pragma solidity ^0.5.8;

import "@openzeppelin/contracts/ownership/Ownable.sol";

contract OwnableSimple is Ownable {
    constructor() public Ownable() {}

    /**
        @dev anyone can call this function
     */
    function publicFn() external { }
    
    /**
        @dev only the owner can call this function
     */
    function privateFn() external onlyOwner() {}

    /**
        @dev renounce ownership of contract, only the owner can call this function
     */
    function renounce() external onlyOwner() {
        renounceOwnership();
    }
}