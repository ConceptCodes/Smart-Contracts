// SPDX-License-Identifier: MIT

pragma solidity ^0.5.8;

import "@openzeppelin/contracts/ownership/Secondary.sol";

contract BasicStorage is Secondary {
    string public data;

    constructor() public Secondary() { }

    /** 
        @dev only the contract that deployed this contract can call this fn
     */
    function setData(string calldata _data) external onlyPrimary {
        data = _data;
    }
}